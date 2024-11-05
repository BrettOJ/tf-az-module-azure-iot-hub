variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
  type        = string
}

variable "location" {
  description = "The location in which the resources will be created"
  type        = string
}

variable "locaL_authentication_enabled" {
  description = "If false, SAS tokens with Iot hub scoped SAS keys cannot be used for authentication. Defaults to true."
  type        = bool
}

variable "event_hub_partition_count" {
  description = "The number of device-to-cloud partitions used by backing event hubs. Must be between 2 and 128. Defaults to 4."
  type        = number
}

variable "event_hub_retention_in_days" {
  description = "The event hub retention to use in days. Must be between 1 and 7. Defaults to 1."
  type        = number
}

variable "public_network_access_enabled" {
  description = "Is the IotHub resource accessible from a public network?"
  type        = bool
}

variable "min_tls_version" {
  description = "Specifies the minimum TLS version to support for this hub. The only valid value is 1.2. Changing this forces a new resource to be created."
  type        = string
}   

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map
}

variable "sku" {
  description = "A sku block as defined below."
  type        = object({
    name     = string
    capacity = number
  })
}

variable "endpoint" {
  description = "An endpoint block as defined below."
  type        = object({
    type                = string
    name                = string
    authentication_type = string
    identity_id         = string
    endpoint_uri        = string
    entity_path         = string
    connection_string   = string
    batch_frequency_in_seconds = number
    max_chunk_size_in_bytes    = number
    container_name             = string
    encoding                   = string
    file_name_format           = string
    resource_group_name        = string
  })
}

variable "identity" {
  description = "An identity block as defined below."
  type        = object({
    type         = string
    identity_ids = list(string)
  })
}

variable "network_rule_set" {
  description = "A network_rule_set block as defined below."
  type        = object({
    default_action = string
    apply_to_builtin_eventhub_endpoint = bool
    ip_rule = object({
      name   = string
      action = string
      ip_mask = string
    })
  })
}

variable "route" {
  description = "A route block as defined below."
  type        = object({
    name           = string
    source         = string
    condition      = string
    endpoint_names = list(string)
    enabled        = bool
  })
}


variable "enrichment" {
  description = "An enrichment block as defined below."
  type        = object({
    key            = string
    value          = string
    endpoint_names = list(string)
  })
}

variable "fallback_route" {
  description = "A fallback_route block as defined below."
  type        = object({
    source         = string
    condition      = string
    endpoint_names = list(string)
    enabled        = bool
  })
}

variable "file_upload" {
  description = "A file_upload block as defined below."
  type        = object({
    authentication_type = string
    identity_id         = string
    connection_string   = string
    container_name      = string
    sas_ttl             = string
    notifications       = bool
    lock_duration       = string
    default_ttl         = string
    max_delivery_count  = number
  })
}

variable "cloud_to_device" {
  description = "A cloud_to_device block as defined below."
  type        = object({
    max_delivery_count = number
    default_ttl        = string
    feedback           = object({
      time_to_live       = string
      max_delivery_count = number
      lock_duration      = string
    })
  })
}
