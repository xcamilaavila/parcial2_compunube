output "haproxy_public_ip" {
  value = azurerm_public_ip.pip_haproxy.ip_address
}

output "microservices_public_ip" {
  value = azurerm_public_ip.pip_micro.ip_address
}

output "haproxy_private_ip" {
  value = azurerm_network_interface.nic_haproxy.private_ip_address
}

output "microservices_private_ip" {
  value = azurerm_network_interface.nic_micro.private_ip_address
}
