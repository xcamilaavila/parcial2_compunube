variable "resource_group_name" {
  default = "rg-microproyecto2"
}

variable "location" {
  default = "chilecentral"
}

variable "vm_size_haproxy" {
  default = "Standard_B2ats_v2"
}

variable "vm_size_micro" {
  default = "Standard_B2als_v2"
}

variable "admin_username" {
  default = "azureuser"
}

variable "ssh_public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "allowed_cidr" {
  default = "*"
}
