resource "shoreline_notebook" "frequent_wiredtiger_cache_flush_events_in_mongodb" {
  name       = "frequent_wiredtiger_cache_flush_events_in_mongodb"
  data       = file("${path.module}/data/frequent_wiredtiger_cache_flush_events_in_mongodb.json")
  depends_on = [shoreline_action.invoke_update_wt_cache_size]
}

resource "shoreline_file" "update_wt_cache_size" {
  name             = "update_wt_cache_size"
  input_file       = "${path.module}/data/update_wt_cache_size.sh"
  md5              = filemd5("${path.module}/data/update_wt_cache_size.sh")
  description      = "Increase the cache size to reduce the frequency of cache flushes"
  destination_path = "/tmp/update_wt_cache_size.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_wt_cache_size" {
  name        = "invoke_update_wt_cache_size"
  description = "Increase the cache size to reduce the frequency of cache flushes"
  command     = "`chmod +x /tmp/update_wt_cache_size.sh && /tmp/update_wt_cache_size.sh`"
  params      = ["NEW_CACHE_SIZE","PATH_TO_WIREDTIGER_CONFIG_FILE"]
  file_deps   = ["update_wt_cache_size"]
  enabled     = true
  depends_on  = [shoreline_file.update_wt_cache_size]
}

