Manages an IotHub

## [Example Usage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#example-usage)

```hcl
resource "azurerm_resource_group" "example" { name = "example-resources" location = "West Europe" } resource "azurerm_storage_account" "example" { name = "examplestorage" resource_group_name = azurerm_resource_group.example.name location = azurerm_resource_group.example.location account_tier = "Standard" account_replication_type = "LRS" } resource "azurerm_storage_container" "example" { name = "examplecontainer" storage_account_name = azurerm_storage_account.example.name container_access_type = "private" } resource "azurerm_eventhub_namespace" "example" { name = "example-namespace" resource_group_name = azurerm_resource_group.example.name location = azurerm_resource_group.example.location sku = "Basic" } resource "azurerm_eventhub" "example" { name = "example-eventhub" resource_group_name = azurerm_resource_group.example.name namespace_name = azurerm_eventhub_namespace.example.name partition_count = 2 message_retention = 1 } resource "azurerm_eventhub_authorization_rule" "example" { resource_group_name = azurerm_resource_group.example.name namespace_name = azurerm_eventhub_namespace.example.name eventhub_name = azurerm_eventhub.example.name name = "acctest" send = true } resource "azurerm_iothub" "example" { name = "Example-IoTHub" resource_group_name = azurerm_resource_group.example.name location = azurerm_resource_group.example.location local_authentication_enabled = false sku { name = "S1" capacity = "1" } endpoint { type = "AzureIotHub.StorageContainer" connection_string = azurerm_storage_account.example.primary_blob_connection_string name = "export" batch_frequency_in_seconds = 60 max_chunk_size_in_bytes = 10485760 container_name = azurerm_storage_container.example.name encoding = "Avro" file_name_format = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}" } endpoint { type = "AzureIotHub.EventHub" connection_string = azurerm_eventhub_authorization_rule.example.primary_connection_string name = "export2" } route { name = "export" source = "DeviceMessages" condition = "true" endpoint_names = ["export"] enabled = true } route { name = "export2" source = "DeviceMessages" condition = "true" endpoint_names = ["export2"] enabled = true } enrichment { key = "tenant" value = "$twin.tags.Tenant" endpoint_names = ["export", "export2"] } cloud_to_device { max_delivery_count = 30 default_ttl = "PT1H" feedback { time_to_live = "PT1H10M" max_delivery_count = 15 lock_duration = "PT30S" } } tags = { purpose = "testing" } }
```

## [Argument Reference](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#argument-reference)

The following arguments are supported:

-   [`name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#name) - (Required) Specifies the name of the IotHub resource. Changing this forces a new resource to be created.
    
-   [`resource_group_name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#resource_group_name) - (Required) The name of the resource group under which the IotHub resource has to be created. Changing this forces a new resource to be created.
    
-   [`location`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#location) - (Required) Specifies the supported Azure location where the resource has to be created. Changing this forces a new resource to be created.
    
-   [`sku`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#sku) - (Required) A `sku` block as defined below.
    
-   [`local_authentication_enabled`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#local_authentication_enabled) - (Optional) If false, SAS tokens with Iot hub scoped SAS keys cannot be used for authentication. Defaults to `true`.
    
-   [`event_hub_partition_count`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#event_hub_partition_count) - (Optional) The number of device-to-cloud partitions used by backing event hubs. Must be between `2` and `128`. Defaults to `4`.
    
-   [`event_hub_retention_in_days`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#event_hub_retention_in_days) - (Optional) The event hub retention to use in days. Must be between `1` and `7`. Defaults to `1`.
    
-   [`endpoint`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#endpoint) - (Optional) An `endpoint` block as defined below.
    
-   [`fallback_route`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#fallback_route) - (Optional) A `fallback_route` block as defined below. If the fallback route is enabled, messages that don't match any of the supplied routes are automatically sent to this route. Defaults to messages/events.
    

-   [`file_upload`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#file_upload) - (Optional) A `file_upload` block as defined below.
    
-   [`identity`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#identity) - (Optional) An `identity` block as defined below.
    
-   [`network_rule_set`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#network_rule_set) - (Optional) A `network_rule_set` block as defined below.
    
-   [`route`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#route) - (Optional) A `route` block as defined below.
    
-   [`enrichment`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#enrichment) - (Optional) A `enrichment` block as defined below.
    
-   [`cloud_to_device`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#cloud_to_device) - (Optional) A `cloud_to_device` block as defined below.
    
-   [`public_network_access_enabled`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#public_network_access_enabled) - (Optional) Is the IotHub resource accessible from a public network?
    
-   [`min_tls_version`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#min_tls_version) - (Optional) Specifies the minimum TLS version to support for this hub. The only valid value is `1.2`. Changing this forces a new resource to be created.
    
-   [`tags`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#tags) - (Optional) A mapping of tags to assign to the resource.
    

___

A `sku` block supports the following:

-   [`name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#name) - (Required) The name of the sku. Possible values are `B1`, `B2`, `B3`, `F1`, `S1`, `S2`, and `S3`.

-   [`capacity`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#capacity) - (Required) The number of provisioned IoT Hub units.

___

An `endpoint` block supports the following:

-   [`type`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#type) - (Required) The type of the endpoint. Possible values are `AzureIotHub.StorageContainer`, `AzureIotHub.ServiceBusQueue`, `AzureIotHub.ServiceBusTopic` or `AzureIotHub.EventHub`.
    
-   [`name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#name) - (Required) The name of the endpoint. The name must be unique across endpoint types. The following names are reserved: `events`, `operationsMonitoringEvents`, `fileNotifications` and `$default`.
    
-   [`authentication_type`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#authentication_type) - (Optional) The type used to authenticate against the endpoint. Possible values are `keyBased` and `identityBased`. Defaults to `keyBased`.
    
-   [`identity_id`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#identity_id) - (Optional) The ID of the User Managed Identity used to authenticate against the endpoint.
    

-   [`endpoint_uri`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#endpoint_uri) - (Optional) URI of the Service Bus or Event Hubs Namespace endpoint. This attribute can only be specified and is mandatory when `authentication_type` is `identityBased` for endpoint type `AzureIotHub.ServiceBusQueue`, `AzureIotHub.ServiceBusTopic` or `AzureIotHub.EventHub`.
    
-   [`entity_path`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#entity_path) - (Optional) Name of the Service Bus Queue/Topic or Event Hub. This attribute can only be specified and is mandatory when `authentication_type` is `identityBased` for endpoint type `AzureIotHub.ServiceBusQueue`, `AzureIotHub.ServiceBusTopic` or `AzureIotHub.EventHub`.
    
-   [`connection_string`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#connection_string) - (Optional) The connection string for the endpoint. This attribute is mandatory and can only be specified when `authentication_type` is `keyBased`.
    
-   [`batch_frequency_in_seconds`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#batch_frequency_in_seconds) - (Optional) Time interval at which blobs are written to storage. Value should be between 60 and 720 seconds. Default value is 300 seconds. This attribute is applicable for endpoint type `AzureIotHub.StorageContainer`.
    
-   [`max_chunk_size_in_bytes`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#max_chunk_size_in_bytes) - (Optional) Maximum number of bytes for each blob written to storage. Value should be between 10485760(10MB) and 524288000(500MB). Default value is 314572800(300MB). This attribute is applicable for endpoint type `AzureIotHub.StorageContainer`.
    
-   [`container_name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#container_name) - (Optional) The name of storage container in the storage account. This attribute is mandatory for endpoint type `AzureIotHub.StorageContainer`.
    
-   [`encoding`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#encoding) - (Optional) Encoding that is used to serialize messages to blobs. Supported values are `Avro`, `AvroDeflate` and `JSON`. Default value is `Avro`. This attribute is applicable for endpoint type `AzureIotHub.StorageContainer`. Changing this forces a new resource to be created.
    
-   [`file_name_format`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#file_name_format) - (Optional) File name format for the blob. All parameters are mandatory but can be reordered. This attribute is applicable for endpoint type `AzureIotHub.StorageContainer`. Defaults to `{iothub}/{partition}/{YYYY}/{MM}/{DD}/{HH}/{mm}`.
    
-   [`resource_group_name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#resource_group_name) - (Optional) The resource group in which the endpoint will be created.
    

___

An `identity` block supports the following:

-   [`type`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#type) - (Required) Specifies the type of Managed Service Identity that should be configured on this IoT Hub. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both).
    
-   [`identity_ids`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#identity_ids) - (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this IoT Hub.
    

___

A `network_rule_set` block supports the following:

-   [`default_action`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#default_action) - (Optional) Default Action for Network Rule Set. Possible values are `Deny`, `Allow`. Defaults to `Deny`.
    
-   [`apply_to_builtin_eventhub_endpoint`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#apply_to_builtin_eventhub_endpoint) - (Optional) Determines if Network Rule Set is also applied to the BuiltIn EventHub EndPoint of the IotHub. Defaults to `false`.
    
-   [`ip_rule`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#ip_rule) - (Optional) One or more `ip_rule` blocks as defined below.
    

___

A `ip_rule` block supports the following:

-   [`name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#name) - (Required) The name of the IP rule.
    
-   [`ip_mask`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#ip_mask) - (Required) The IP address range in CIDR notation for the IP rule.
    
-   [`action`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#action) - (Optional) The desired action for requests captured by this rule. Possible values are `Allow`. Defaults to `Allow`.
    

___

A `route` block supports the following:

-   [`name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#name) - (Required) The name of the route.
    
-   [`source`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#source) - (Required) The source that the routing rule is to be applied to, such as `DeviceMessages`. Possible values include: `Invalid`, `DeviceMessages`, `TwinChangeEvents`, `DeviceLifecycleEvents`, `DeviceConnectionStateEvents`, `DeviceJobLifecycleEvents` and `DigitalTwinChangeEvents`.
    
-   [`condition`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#condition) - (Optional) The condition that is evaluated to apply the routing rule. Defaults to `true`. For grammar, see: [https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-query-language](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-query-language).
    
-   [`endpoint_names`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#endpoint_names) - (Required) The list of endpoints to which messages that satisfy the condition are routed.
    
-   [`enabled`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#enabled) - (Required) Used to specify whether a route is enabled.
    

___

An `enrichment` block supports the following:

-   [`key`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#key) - (Required) The key of the enrichment.
    
-   [`value`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#value) - (Required) The value of the enrichment. Value can be any static string, the name of the IoT Hub sending the message (use `$iothubname`) or information from the device twin (ex: `$twin.tags.latitude`)
    
-   [`endpoint_names`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#endpoint_names) - (Required) The list of endpoints which will be enriched.
    

___

A `fallback_route` block supports the following:

-   [`source`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#source) - (Optional) The source that the routing rule is to be applied to, such as `DeviceMessages`. Possible values include: `Invalid`, `DeviceMessages`, `TwinChangeEvents`, `DeviceLifecycleEvents`, `DeviceConnectionStateEvents`, `DeviceJobLifecycleEvents` and `DigitalTwinChangeEvents`. Defaults to `DeviceMessages`.
    
-   [`condition`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#condition) - (Optional) The condition that is evaluated to apply the routing rule. Defaults to `true`. For grammar, see: [https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-query-language](https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-query-language).
    
-   [`endpoint_names`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#endpoint_names) - (Optional) The endpoints to which messages that satisfy the condition are routed. Currently only 1 endpoint is allowed.
    
-   [`enabled`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#enabled) - (Optional) Used to specify whether the fallback route is enabled. Defaults to `true`.
    

___

A `file_upload` block supports the following:

-   [`authentication_type`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#authentication_type) - (Optional) The type used to authenticate against the storage account. Possible values are `keyBased` and `identityBased`. Defaults to `keyBased`.
    
-   [`identity_id`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#identity_id) - (Optional) The ID of the User Managed Identity used to authenticate against the storage account.
    

-   [`connection_string`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#connection_string) - (Required) The connection string for the Azure Storage account to which files are uploaded.
    
-   [`container_name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#container_name) - (Required) The name of the root container where the files should be uploaded to. The container need not exist but should be creatable using the connection\_string specified.
    
-   [`sas_ttl`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#sas_ttl) - (Optional) The period of time for which the SAS URI generated by IoT Hub for file upload is valid, specified as an [ISO 8601 timespan duration](https://en.wikipedia.org/wiki/ISO_8601#Durations). This value must be between 1 minute and 24 hours. Defaults to `PT1H`.
    
-   [`notifications`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#notifications) - (Optional) Used to specify whether file notifications are sent to IoT Hub on upload. Defaults to `false`.
    
-   [`lock_duration`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#lock_duration) - (Optional) The lock duration for the file upload notifications queue, specified as an [ISO 8601 timespan duration](https://en.wikipedia.org/wiki/ISO_8601#Durations). This value must be between 5 and 300 seconds. Defaults to `PT1M`.
    
-   [`default_ttl`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#default_ttl) - (Optional) The period of time for which a file upload notification message is available to consume before it expires, specified as an [ISO 8601 timespan duration](https://en.wikipedia.org/wiki/ISO_8601#Durations). This value must be between 1 minute and 48 hours. Defaults to `PT1H`.
    
-   [`max_delivery_count`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#max_delivery_count) - (Optional) The number of times the IoT Hub attempts to deliver a file upload notification message. Defaults to `10`.
    

___

A `cloud_to_device` block supports the following:

-   [`max_delivery_count`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#max_delivery_count) - (Optional) The maximum delivery count for cloud-to-device per-device queues. This value must be between `1` and `100`. Defaults to `10`.
    
-   [`default_ttl`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#default_ttl) - (Optional) The default time to live for cloud-to-device messages, specified as an [ISO 8601 timespan duration](https://en.wikipedia.org/wiki/ISO_8601#Durations). This value must be between 1 minute and 48 hours. Defaults to `PT1H`.
    
-   [`feedback`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#feedback) - (Optional) A `feedback` block as defined below.
    

___

A `feedback` block supports the following:

-   [`time_to_live`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#time_to_live) - (Optional) The retention time for service-bound feedback messages, specified as an [ISO 8601 timespan duration](https://en.wikipedia.org/wiki/ISO_8601#Durations). This value must be between 1 minute and 48 hours. Defaults to `PT1H`.
    
-   [`max_delivery_count`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#max_delivery_count) - (Optional) The maximum delivery count for the feedback queue. This value must be between `1` and `100`. Defaults to `10`.
    
-   [`lock_duration`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#lock_duration) - (Optional) The lock duration for the feedback queue, specified as an [ISO 8601 timespan duration](https://en.wikipedia.org/wiki/ISO_8601#Durations). This value must be between 5 and 300 seconds. Defaults to `PT60S`.
    

## [Attributes Reference](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#attributes-reference)

In addition to the Arguments listed above - the following Attributes are exported:

-   [`id`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#id) - The ID of the IoTHub.
    
-   [`event_hub_events_endpoint`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#event_hub_events_endpoint) - The EventHub compatible endpoint for events data
    
-   [`event_hub_events_namespace`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#event_hub_events_namespace) - The EventHub namespace for events data
    
-   [`event_hub_events_path`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#event_hub_events_path) - The EventHub compatible path for events data
    
-   [`event_hub_operations_endpoint`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#event_hub_operations_endpoint) - The EventHub compatible endpoint for operational data
    
-   [`event_hub_operations_path`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#event_hub_operations_path) - The EventHub compatible path for operational data
    

-   [`hostname`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#hostname) - The hostname of the IotHub Resource.
    
-   [`identity`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#identity) - An `identity` block as documented below.
    
-   [`shared_access_policy`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#shared_access_policy) - One or more `shared_access_policy` blocks as defined below.
    

___

An `identity` block exports the following:

-   [`principal_id`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#principal_id) - The Principal ID associated with this Managed Service Identity.
    
-   [`tenant_id`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#tenant_id) - The Tenant ID associated with this Managed Service Identity.
    

___

A `shared_access_policy` block contains the following:

-   [`key_name`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#key_name) - The name of the shared access policy.
    
-   [`primary_key`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#primary_key) - The primary key.
    
-   [`secondary_key`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#secondary_key) - The secondary key.
    
-   [`permissions`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#permissions) - The permissions assigned to the shared access policy.
    

## [Timeouts](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#timeouts)

The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:

-   [`create`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#create) - (Defaults to 30 minutes) Used when creating the IotHub.
-   [`update`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#update) - (Defaults to 30 minutes) Used when updating the IotHub.
-   [`read`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#read) - (Defaults to 5 minutes) Used when retrieving the IotHub.
-   [`delete`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#delete) - (Defaults to 30 minutes) Used when deleting the IotHub.

## [Import](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/iothub#import)

IoTHubs can be imported using the `resource id`, e.g.

```shell
terraform import azurerm_iothub.hub1 /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/mygroup1/providers/Microsoft.Devices/iotHubs/hub1
```