#! /usr/bin/env ruby

require 'net/http'
require 'json'

ES_HOST = ENV.fetch("ES_HOST").delete(' ')
ES_PORT = ENV.fetch("ES_PORT").delete(' ')

ES_URL = "http://#{ES_HOST}:#{ES_PORT}"

def config_uri
  config_url = "#{ES_URL}/.kibana/config/4.3.1"
  URI(config_url)
end

def index_settings_uri
  index_settings_url = ES_URL + '/.kibana'
  URI(index_settings_url)
end

def update_es_index(uri, document)
  raise "Document is not a hash" unless document.is_a? Hash
  Net::HTTP.new(uri.host, uri.port).start do |http|
    req = Net::HTTP::Put.new(uri.path, 'Content-Type' => 'application/json')
    req.body = document.to_json
    response = http.request(req)
    raise "Unexpected response code: #{response.code}\n#{response.body}" unless (response.code == '200' || response.code == '201')
  end
end

def need_to_create_index(response)
  !response["found"]
end

def need_to_set_timezone(response)
  need_to_create_index(response) || response["_source"]["dateFormat:tz"] != "UTC"
end

response = JSON.parse(Net::HTTP.get(config_uri))

if need_to_create_index(response)
  index_settings = {
    settings: {
      index: {
        number_of_shards: 1,
        number_of_replicas: 1,
      }
    }
  }
  update_es_index(index_settings_uri, index_settings)
end

if need_to_set_timezone(response)
  update_es_index(config_uri, { "dateFormat:tz" => "UTC" })
end
