#!/bin/bash
set -e

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

env=${DEPLOY_ENV-$1}

[[ -z "${env}" ]] && echo "Must provide environment name" && exit 100

extract_cf_version(){
  set -u
  manifest=$1
  ruby -e "require 'yaml'; \
    puts YAML.load(STDIN.read)['releases'].select { |item| item['name'] == 'cf' }.first['version']" < "$manifest"
}

cf_release_version=$(extract_cf_version "${SCRIPT_DIR}"/../../manifests/cf-manifest/deployments/000-base-cf-deployment.yml)

generate_vars_file() {
   set -u # Treat unset variables as an error when substituting
   cat <<EOF
---
aws_account: ${AWS_ACCOUNT:-dev}
deploy_env: ${env}
state_bucket: ${env}-state
pipeline_trigger_file: ${pipeline_name}.trigger
branch_name: ${BRANCH:-master}
aws_region: ${AWS_DEFAULT_REGION:-eu-west-1}
debug: ${DEBUG:-}
cf-release-version: v${cf_release_version}
EOF
}

generate_manifest_file() {
   # This exists because concourse does not support boolean value interpolation by design
   enable_auto_deploy=$([ "${ENABLE_AUTO_DEPLOY:-}" ] && echo "true" || echo "false")
   sed -e "s/{{auto_deploy}}/${enable_auto_deploy}/" \
       < "${SCRIPT_DIR}/../pipelines/${pipeline_name}.yml"
}

pipeline_name="create-bosh-cloudfoundry"
generate_vars_file > /dev/null # Check for missing vars
bash "${SCRIPT_DIR}/deploy-pipeline.sh" \
  "${env}" "${pipeline_name}" \
  <(generate_manifest_file) \
  <(generate_vars_file)

for component in cloudfoundry microbosh; do
  pipeline_name="destroy-${component}"
  generate_vars_file > /dev/null # Check for missing vars
  bash "${SCRIPT_DIR}/deploy-pipeline.sh" \
    "${env}" "${pipeline_name}" \
    <(generate_manifest_file) \
    <(generate_vars_file)
done

pipeline_name="autodelete-cloudfoundry"
if [ ! "${DISABLE_AUTODELETE:-}" ]; then
  bash "${SCRIPT_DIR}/deploy-pipeline.sh" \
	  "${env}" "${pipeline_name}" \
    "${SCRIPT_DIR}/../pipelines/${pipeline_name}.yml" \
    <(generate_vars_file)

  echo
  echo "WARNING: Pipeline to autodelete Cloud Foundry has been setup and enabled."
  echo "         To disable it, set DISABLE_AUTODELETE=1 or pause the pipeline."
else
  yes y | ${FLY_CMD:-fly} -t "${FLY_TARGET:-$env}" destroy-pipeline --pipeline "${pipeline_name}" || true

  echo
  echo "WARNING: Pipeline to autodelete Cloud Foundry has NOT been setup"
fi