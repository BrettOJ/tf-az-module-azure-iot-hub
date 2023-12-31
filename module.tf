resource "azurerm_iothub" "iothub" {
  name                = module.iothub_name.naming_convention_output[var.naming_convention_info.name].names.0
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.sku_name
    capacity = var.sku_capacity
  }

dynamic "endpoint" {
    for_each = var.endpoints != null ? var.endpoints : []
    content {
        type = endpoint.value.type
        name = endpoint.value.name
        authentication_type = endpoint.value.authentication_type
        identity_id = endpoint.value.identity_id
        endpoint_uri = endpoint.value.endpoint_uri
        entity_path = endpoint.value.entity_path
        connection_string = endpoint.value.connection_string
        batch_frequency_in_seconds = endpoint.value.batch_frequency_in_seconds
        max_chunk_size_in_bytes = endpoint.value.max_chunk_size_in_bytes
        container_name = endpoint.value.container_name
        encoding = endpoint.value.encoding
        file_name_format = endpoint.value.file_name_format
        resource_group_name = endpoint.value.resource_group_name
    }
}

dynamic "route" {
    for_each = var.routes != null ? var.routes : []
    content {
        name = route.value.name
        source = route.value.source
        endpoint_names = route.value.endpoint_names
        condition = route.value.condition
        enabled = route.value.enabled
    }
}

dynamic "enrichment" {
    for_each = var.enrichment != null ? [var.enrichment] : []
    content {
        key = var.enrichment.key
        value = var.enrichment.value
        endpoint_names = var.enrichment.endpoint_names
    }
}

  cloud_to_device  {
    max_delivery_count = var.cloud_to_device.max_delivery_count
    default_ttl        = var.cloud_to_device.default_ttl
    feedback  {
      time_to_live       = var.cloud_to_device.feedback.time_to_live
      max_delivery_count = var.cloud_to_device.feedback.max_delivery_count
      lock_duration      = var.cloud_to_device.feedback.lock_duration
    }
  }


  tags = var.tags
}