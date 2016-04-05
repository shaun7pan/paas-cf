output "cf1_subnet_id" {
  value = "${aws_subnet.cf.0.id}"
}

output "cf2_subnet_id" {
  value = "${aws_subnet.cf.1.id}"
}

output "cf3_subnet_id" {
  value = "${aws_subnet.cf.2.id}"
}

output "cell1_subnet_id" {
  value = "${aws_subnet.cell.0.id}"
}

output "cell2_subnet_id" {
  value = "${aws_subnet.cell.1.id}"
}

output "router1_subnet_id" {
  value = "${aws_subnet.router.0.id}"
}

output "router2_subnet_id" {
  value = "${aws_subnet.router.1.id}"
}

output "ssh_elb_name" {
  value = "${aws_elb.ssh-proxy-router.name}"
}

output "cf_root_domain" {
  value = "${var.system_dns_zone_name}"
}

output "cf_apps_domain" {
  value = "${var.apps_dns_zone_name}"
}

output "elb_name" {
  value = "${aws_elb.router.name}"
}

output "cf_rds_client_security_group" {
  value = "${aws_security_group.cf_rds_client.name}"
}

output "cf_db_address" {
  value = "${aws_db_instance.cf.address}"
}

output "ingestor_elb_name" {
  value = "${aws_elb.ingestor_elb.name}"
}

output "ingestor_elb_dns_name" {
  value = "${aws_elb.ingestor_elb.dns_name}"
}

output "elastic_master_elb_name" {
  value = "${aws_elb.es_master_elb.name}"
}

output "elastic_master_elb_dns_name" {
  value = "${aws_elb.es_master_elb.dns_name}"
}

output "metrics_elb_name" {
  value = "${aws_elb.metrics_elb.name}"
}

output "logsearch_elb_name" {
  value = "${aws_elb.logsearch_elb.name}"
}

output "cf_cells_security_group" {
  value = "${aws_security_group.cf_cells.name}"
}

output "consul_server_security_group" {
  value = "${aws_security_group.consul_server.name}"
}

output "consul_client_security_group" {
  value = "${aws_security_group.consul_client.name}"
}

output "elb_to_router_security_group" {
  value = "${aws_security_group.elb_to_router.name}"
}

output "file_server_security_group" {
  value = "${aws_security_group.file_server.name}"
}

output "file_server_client_security_group" {
  value = "${aws_security_group.file_server_client.name}"
}

output "ccuploader_server_security_group" {
  value = "${aws_security_group.ccuploader_server.name}"
}

output "ccuploader_client_security_group" {
  value = "${aws_security_group.ccuploader_client.name}"
}

output "doppler_server_security_group" {
  value = "${aws_security_group.doppler_server.name}"
}

output "doppler_client_security_group" {
  value = "${aws_security_group.doppler_client.name}"
}

output "statsd_server_security_group" {
  value = "${aws_security_group.statsd_server.name}"
}

output "statsd_client_security_group" {
  value = "${aws_security_group.statsd_client.name}"
}

output "bbs_server_security_group" {
  value = "${aws_security_group.bbs_server.name}"
}

output "bbs_client_security_group" {
  value = "${aws_security_group.bbs_client.name}"
}

output "cc_server_security_group" {
  value = "${aws_security_group.cc_server.name}"
}

output "cc_client_security_group" {
  value = "${aws_security_group.cc_client.name}"
}
