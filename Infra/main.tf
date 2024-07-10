terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}
provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "main" {
    name = "testlab-rg"
}

output "resourceGroup" {
  value = data.azurerm_resource_group.main
}

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name                                                                                                                                        
    location            = var.location
    resource_group_name = data.azurerm_resource_group.main.name
    dns_prefix          = var.dns_prefix
   
    default_node_pool {
        name            = "syspool"
        node_count      = var.agent_count
        vm_size         = "Standard_D2_v2"
    }

    identity {
      type = "SystemAssigned"
    }

    network_profile {
        load_balancer_sku = "Standard"
        network_plugin = "kubenet"
    }

    tags = {
        Environment = "test"
    }
}