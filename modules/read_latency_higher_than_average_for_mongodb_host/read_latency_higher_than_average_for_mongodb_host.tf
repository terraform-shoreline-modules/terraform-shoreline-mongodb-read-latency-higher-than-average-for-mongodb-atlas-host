resource "shoreline_notebook" "read_latency_higher_than_average_for_mongodb_host" {
  name       = "read_latency_higher_than_average_for_mongodb_host"
  data       = file("${path.module}/data/read_latency_higher_than_average_for_mongodb_host.json")
  depends_on = [shoreline_action.invoke_network_latency_check,shoreline_action.invoke_config_mongo]
}

resource "shoreline_file" "network_latency_check" {
  name             = "network_latency_check"
  input_file       = "${path.module}/data/network_latency_check.sh"
  md5              = filemd5("${path.module}/data/network_latency_check.sh")
  description      = "7. Check the read latency for the MongoDB host"
  destination_path = "/agent/scripts/network_latency_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "config_mongo" {
  name             = "config_mongo"
  input_file       = "${path.module}/data/config_mongo.sh"
  md5              = filemd5("${path.module}/data/config_mongo.sh")
  description      = "Optimize the MongoDB configuration settings to reduce read latency."
  destination_path = "/agent/scripts/config_mongo.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_network_latency_check" {
  name        = "invoke_network_latency_check"
  description = "7. Check the read latency for the MongoDB host"
  command     = "`chmod +x /agent/scripts/network_latency_check.sh && /agent/scripts/network_latency_check.sh`"
  params      = ["DATABASE_NAME","MONGODB_HOSTNAME","CLIENT_IP","MONGODB_ATLAS_PORT","USERNAME","PASSWORD"]
  file_deps   = ["network_latency_check"]
  enabled     = true
  depends_on  = [shoreline_file.network_latency_check]
}

resource "shoreline_action" "invoke_config_mongo" {
  name        = "invoke_config_mongo"
  description = "Optimize the MongoDB configuration settings to reduce read latency."
  command     = "`chmod +x /agent/scripts/config_mongo.sh && /agent/scripts/config_mongo.sh`"
  params      = []
  file_deps   = ["config_mongo"]
  enabled     = true
  depends_on  = [shoreline_file.config_mongo]
}

