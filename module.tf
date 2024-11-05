resource "azurerm_iothub" "example" {
    name                         = module.naming_convention.iothub_name.
    resource_group_name          = var.resource_group_name
    location                     = var.location
    local_authentication_enabled = var.locaL_authentication_enabled
    event_hub_partition_count = var.event_hub_partition_count
    event_hub_retention_in_days = var.event_hub_retention_in_days
    public_network_access_enabled = var.public_network_access_enabled
    min_tls_version = var.min_tls_version
    tags = var.tags
    sku {
        name     = var.sku.name
        capacity = var.sku.capacity
    }

   dynamic endpoint {
    for_each = var.endpoint != null ? var.endpoint : {}
    content {
    type                = var.endpoint.type
    name                = var.endpoint.name
    authentication_type = var.endpoint.authentication_type
    identity_id         = var.endpoint.identity_id
    endpoint_uri        = var.endpoint.endpoint_uri
    entity_path         = var.endpoint.entity_path
    connection_string   = var.endpoint.connection_string
    batch_frequency_in_seconds = var.endpoint.batch_frequency_in_seconds
    max_chunk_size_in_bytes    = var.endpoint.max_chunk_size_in_bytes
    container_name             = var.endpoint.container_name
    encoding                   = var.endpoint.encoding
    file_name_format           = var.endpoint.file_name_format
    resource_group_name        = var.endpoint.resource_group_name
    }
   }

    dynamic identity {
        for_each = var.identity != null ? var.identity : {}
        content {
        type         = var.identity.type
        identity_ids = var.identity.identity_ids
        }
    }

    dynamic network_rule_set {
        for_each = var.network_rule_set != null ? var.network_rule_set : {}
        content {
        default_action = var.network_rule_set.default_action
        apply_to_builtin_eventhub_endpoint = var.network_rule_set.apply_to_builtin_eventhub_endpoint
        dynamic ip_rule {
            for_each = var.network_rule_set.ip_rule != null ? var.network_rule_set.ip_rule : {}
            content {
            name = var.network_rule_set.ip_rule.name
            action = var.network_rule_set.ip_rule.action
            ip_mask = var.network_rule_set.ip_rule.ip_mask
            }
        }
    }
}
    dynamic route {
        for_each = var.route != null ? var.route : {}
        content {
        name = var.route.name
        source = var.route.source
        endpoint_names = var.route.endpoint_names
        condition = var.route.condition
        enabled = var.route.enabled
        }
    }

    dynamic enrichment {
        for_each = var.enrichment != null ? var.enrichment : {}
        content {
        key = var.enrichment.key
        value    = var.enrichment.value
        endpoint_names = var.enrichment.endpoint_names
        }
    }

dynamic fallback_route {
    for_each = var.fallback_route != null ? var.fallback_route : {}
    content {
    source         = var.fallback_route.source
    condition      = var.fallback_route.condition
    endpoint_names = var.fallback_route.endpoint_names
    enabled        = var.fallback_route.enabled
    }
}

dynamic file_upload {
    for_each = var.file_upload != null ? var.file_upload : {}
    content {
    authentication_type = var.file_upload.authentication_type
    identity_id         = var.file_upload.identity_id
    connection_string   = var.file_upload.connection_string
    container_name      = var.file_upload.container_name
    sas_ttl             = var.file_upload.sas_ttl
    notifications       = var.file_upload.notifications
    lock_duration       = var.file_upload.lock_duration
    default_ttl         = var.file_upload.default_ttl
    max_delivery_count  = var.file_upload.max_delivery_count
    }
}

dynamic cloud_to_device {
    for_each = var.cloud_to_device != null ? var.cloud_to_device : {}
    content {
    default_ttl = var.cloud_to_device.default_ttl
    max_delivery_count = var.cloud_to_device.max_delivery_count
    feedback {
        max_delivery_count = var.cloud_to_device.feedback.max_delivery_count
        time_to_live       = var.cloud_to_device.feedback.time_to_live
        lock_duration = var.cloud_to_device.feedback.lock_duration
    }
    }
}


}




