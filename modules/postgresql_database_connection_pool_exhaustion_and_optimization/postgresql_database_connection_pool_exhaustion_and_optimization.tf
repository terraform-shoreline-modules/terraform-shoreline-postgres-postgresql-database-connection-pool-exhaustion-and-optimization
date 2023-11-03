resource "shoreline_notebook" "postgresql_database_connection_pool_exhaustion_and_optimization" {
  name       = "postgresql_database_connection_pool_exhaustion_and_optimization"
  data       = file("${path.module}/data/postgresql_database_connection_pool_exhaustion_and_optimization.json")
  depends_on = [shoreline_action.invoke_check_db_connections,shoreline_action.invoke_update_connection_limit_script]
}

resource "shoreline_file" "check_db_connections" {
  name             = "check_db_connections"
  input_file       = "${path.module}/data/check_db_connections.sh"
  md5              = filemd5("${path.module}/data/check_db_connections.sh")
  description      = "The maximum number of connections allowed in the pool is set too low, leading to contention for available connections and eventual pool exhaustion."
  destination_path = "/tmp/check_db_connections.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_connection_limit_script" {
  name             = "update_connection_limit_script"
  input_file       = "${path.module}/data/update_connection_limit_script.sh"
  md5              = filemd5("${path.module}/data/update_connection_limit_script.sh")
  description      = "Increase the maximum number of connections allowed in the connection pool. This can be done by editing the configuration file of the application and adjusting the connection pool settings."
  destination_path = "/tmp/update_connection_limit_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_db_connections" {
  name        = "invoke_check_db_connections"
  description = "The maximum number of connections allowed in the pool is set too low, leading to contention for available connections and eventual pool exhaustion."
  command     = "`chmod +x /tmp/check_db_connections.sh && /tmp/check_db_connections.sh`"
  params      = ["USERNAME","DATABASE_HOST","DATABASE_PORT","MAXIMUM_NUMBER_OF_CONNECTIONS","DATABASE_NAME"]
  file_deps   = ["check_db_connections"]
  enabled     = true
  depends_on  = [shoreline_file.check_db_connections]
}

resource "shoreline_action" "invoke_update_connection_limit_script" {
  name        = "invoke_update_connection_limit_script"
  description = "Increase the maximum number of connections allowed in the connection pool. This can be done by editing the configuration file of the application and adjusting the connection pool settings."
  command     = "`chmod +x /tmp/update_connection_limit_script.sh && /tmp/update_connection_limit_script.sh`"
  params      = ["PATH_TO_CONFIG_FILE","NEW_MAXIMUM_CONNECTION_LIMIT","APPLICATION_NAME"]
  file_deps   = ["update_connection_limit_script"]
  enabled     = true
  depends_on  = [shoreline_file.update_connection_limit_script]
}

