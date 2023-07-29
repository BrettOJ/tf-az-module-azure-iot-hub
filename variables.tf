
variable "resource_group_name" {
    type = string
    default = "iot-hub-resources"
}
  
variable "location" {
    type = string
    default = "southeastasia"
}

variable "sku_name" {
    type = string
    default = "S1"
}

variable "sku_capacity" {
    type = number
    default = 1
}

variable "enpoint" {
    type = list(object({
        type = string
        name = string
        authentication_type = string
        identity_id = string
        endpoint_uri = string
        entity_path = string
        connection_string = string
        batch_frequency_in_seconds = number
        max_chunk_size_in_bytes = number
        container_name = string
        encoding = string
        file_name_format = string
        resource_group_name = string
  }))
    default = null  
}

variable "route" {
    type = list(object({
        name = string
        source = string
        endpoint_names = list(string)
        condition = string
  }))
    default = null  
}

variable "enrichment" {
    type = list(object({
        key = string
        value = string
        endpoint_names = list(string)
  }))
    default = null  
}

variable "cloud_to_device" {
    type = object({
        max_delivery_count = number
        default_ttl = number
        feedback = object({
            time_to_live = number
            max_delivery_count = number
            lock_duration = number
        })
  })
    default = null  
}

variable "tags" {
    type = map(string)
    default = null
}
