
provider "azurerm" {
  storage_use_azuread        = false
  use_msi                    = false
  skip_provider_registration = false
  tenant_id            = ""
  subscription_id      = ""
   features {}
}

resource "azurerm_resource_group" "bojtest" {
  name     = "bojtest-resources"
  location = "West Europe"
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
  name                = "bojtest-IoTHub"
  resource_group_name = azurerm_resource_group.bojtest.name
  location            = azurerm_resource_group.bojtest.location

  sku {
    name     = "S1"
    capacity = "1"
  }

  endpoint = {
    AzureStorageContainer = {
    type                       = "AzureStorageContainer"
    connection_string          = azurerm_storage_account.bojtest.primary_blob_connection_string
    name                       = "export"
    batch_frequency_in_seconds = 60
    max_chunk_size_in_bytes    = 10485760
    container_name             = azurerm_storage_container.bojtest.name
    encoding                   = "Avro"
    file_name_format           = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"

    }
    eventhub = {
    type              = "AzureIotHub.EventHub"
    connection_string = azurerm_eventhub_authorization_rule.bojtest.primary_connection_string
    name              = "export2"
    }
  }

route = {
    export = {
    name           = "export"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["export"]
    enabled        = true
    }
    export2 = {
    name           = "export2"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["export2"]
    enabled        = true
    }
  }


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