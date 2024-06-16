#Create a Resource Group
resource "azurerm_resource_group" "RG" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "AKS" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kubernetes_version  = var.kubernetes_version
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name                = "aksnodepool"
    vm_size             = "Standard_B2s"
    enable_auto_scaling = true
    node_count          = 1
    min_count           = 1
    max_count           = 3
    vnet_subnet_id      = azurerm_subnet.aks-default.id

    node_labels = {
      role = "aksnodepool"
    }
  }
  identity {
    type = "SystemAssigned"
  }
  tags = {

    Environment = "Production"

  }

  role_based_access_control_enabled = true

}

# Define the Azure Container Registry
resource "azurerm_container_registry" "ACR" {
  name                = "your-azure-name"
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Allow AKS Cluster access to Azure Container Registry 
resource "azurerm_role_assignment" "example" {
  principal_id                     = azurerm_kubernetes_cluster.AKS.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.ACR.id
  skip_service_principal_aad_check = true
}
 

# Define the null_resource for pushing the Docker image to ACR
resource "null_resource" "push_to_acr" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<-EOT
     az acr login --name ${azurerm_container_registry.ACR.name} --expose-token
     docker tag netflix:latest ${azurerm_container_registry.ACR.login_server}//your-dockerhub-name/netflix:latest
     docker push ${azurerm_container_registry.ACR.login_server}/your-dockerhub-name/netflix:latest
   EOT
  }
}


 

#Create a V-N
resource "azurerm_virtual_network" "aksvnet" {
  name                = "aks-network2"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/8"]
}

# Create a Subnet for AKS
resource "azurerm_subnet" "aks-default" {
  name                 = "subnet2"
  virtual_network_name = azurerm_virtual_network.aksvnet.name
  resource_group_name  = azurerm_resource_group.RG.name
  address_prefixes     = ["10.240.0.0/16"]
}

# #Prometheus
# resource "azurerm_monitor_action_group" "example" {
#   name                = "example-mag"
#   resource_group_name = azurerm_resource_group.RG.name
#   short_name          = "testag"
# }

# resource "azurerm_monitor_workspace" "example" {
#   name                = "example-amw"
#   resource_group_name = azurerm_resource_group.RG.name
#   location            = azurerm_resource_group.RG.location
# }

# resource "azurerm_monitor_alert_prometheus_rule_group" "example" {
#   name                = "example-amprg"
#   location            = "West Europe"
#   resource_group_name = azurerm_resource_group.RG.name
#   cluster_name        = azurerm_kubernetes_cluster.AKS.name
#   description         = "This is the description of the following rule group"
#   rule_group_enabled  = false
#   interval            = "PT1M"
#   scopes              = [azurerm_monitor_workspace.example.id]
#   rule {
#     enabled    = false
#     expression = <<EOF
# histogram_quantile(0.99, sum(rate(jobs_duration_seconds_bucket{service="billing-processing"}[5m])) by (job_type))
# EOF
#     record     = "job_type:billing_jobs_duration_seconds:99p5m"
#     labels = {
#       team = "prod"
#     }
#   }

#   rule {
#     alert      = "Billing_Processing_Very_Slow"
#     enabled    = true
#     expression = <<EOF
# histogram_quantile(0.99, sum(rate(jobs_duration_seconds_bucket{service="billing-processing"}[5m])) by (job_type))
# EOF
#     for        = "PT5M"
#     severity   = 2

#     action {
#       action_group_id = azurerm_monitor_action_group.example.id
#     }

#     alert_resolution {
#       auto_resolved   = true
#       time_to_resolve = "PT10M"
#     }

#     annotations = {
#       annotationName = "annotationValue"
#     }

#     labels = {
#       team = "prod"
#     }
#   }
#   tags = {
#     key = "value"
#   }
# }

# resource "azurerm_log_analytics_workspace" "example" {
#   name                = "acctest-01"
#   location            = azurerm_resource_group.RG.location
#   resource_group_name = azurerm_resource_group.RG.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
# }