locals {
    naming_convention_info = {
    name         = "001"
    project_code = "ml"
    env          = "de"
    zone         = "in"
    agency_code  = "mrl"
    tier         = "pp"
  }
}
resource "azurerm_resource_group" "bojtest" {
  name     = "industrial-iot-hub-rg"
  location = "southeastasia"
}

resource "azurerm_storage_account" "bojtest" {
  name                     = "bojteststorage"
  resource_group_name      = azurerm_resource_group.bojtest.name
  location                 = azurerm_resource_group.bojtest.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "bojtest" {
  name                  = "bojtestcontainer"
  storage_account_name  = azurerm_storage_account.bojtest.name
  container_access_type = "private"
}

resource "azurerm_eventhub_namespace" "bojtest-ns" {
  name                = "boj-test-ns"
  resource_group_name = azurerm_resource_group.bojtest.name
  location            = azurerm_resource_group.bojtest.location
  sku                 = "Basic"
}

resource "azurerm_eventhub" "bojtest" {
  name                = "bojtest-eventhub"
  resource_group_name = azurerm_resource_group.bojtest.name
  namespace_name      = azurerm_eventhub_namespace.bojtest-ns.name
  partition_count     = 2
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "bojtest" {
  resource_group_name = azurerm_resource_group.bojtest.name
  namespace_name      = azurerm_eventhub_namespace.bojtest-ns.name
  eventhub_name       = azurerm_eventhub.bojtest.name
  name                = "acctest"
  send                = true
}

module azurerm_iothub {
  source = "git::https://github.com/BrettOJ/tf-az-module-azure-iot-hub?ref=main"
  resource_group_name = azurerm_resource_group.bojtest.name
  location            = azurerm_resource_group.bojtest.location
  naming_convention_info = local.naming_convention_info
  sku_name     = "S1"
  sku_capacity = "1"
  

  endpoints = [
    {
      type                       = "AzureIotHub.StorageContainer"
      connection_string          = azurerm_storage_account.bojtest.primary_blob_connection_string
      name                       = "export"
      batch_frequency_in_seconds = 60
      max_chunk_size_in_bytes    = 10485760
      container_name             = azurerm_storage_container.bojtest.name
      encoding                   = "Avro"
      file_name_format           = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
      resource_group_name        = azurerm_resource_group.bojtest.name
      authentication_type = null
      identity_id = null
      endpoint_uri = null
      entity_path = null
    },
    {
      type              = "AzureIotHub.EventHub"
      connection_string = azurerm_eventhub_authorization_rule.bojtest.primary_connection_string
      name              = "export2"
      batch_frequency_in_seconds = null
      max_chunk_size_in_bytes    = null
      container_name             = null
      encoding                   = null
      file_name_format           = null
      resource_group_name        = null
      authentication_type = null
      identity_id = null
      endpoint_uri = null
      entity_path = null
    }
  ]

routes = [
   {
    name           = "export"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["export"]
    enabled        = true
    },
  {
    name           = "export2"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["export2"]
    enabled        = true
    }
  ]


  enrichment = {
    key            = "tenant"
    value          = "$twin.tags.Tenant"
    endpoint_names = ["export", "export2"]
  }

  cloud_to_device = {
    max_delivery_count = 30
    default_ttl        = "PT1H"
    feedback = {
      time_to_live       = "PT1H10M"
      max_delivery_count = 15
      lock_duration      = "PT30S"
    }
  }

  tags = {
    purpose = "testing"
  }

}