output "resource_group_name" {
  value     = azurerm_resource_group.RG
  sensitive = true
}

output "kubernetes_cluster_name" {
  value     = azurerm_kubernetes_cluster.AKS
  sensitive = true
}
