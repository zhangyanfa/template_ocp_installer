

variable "vm_clone_timeout" {
  description = "The timeout, in minutes, to wait for the virtual machine clone to complete."
  default = "300"
}



# VM Generic Items
variable "vm_domain" {
  type = "string"
}

variable "vm_network_interface_label" {
  type = "string"
}

variable "vm_adapter_type" {
  type    = "string"
  default = "vmxnet3"
}

variable "vm_folder" {
  type = "string"
}

variable "vm_dns_servers" {
  type = "list"
}

variable "vsphere_datacenter" {
  type = "string"
}

variable "vsphere_resource_pool" {
  type = "string"
}

variable "vm_template" {
  type = "string"
}

variable "vm_os_user" {
  type = "string"
}

variable "vm_os_password" {
  type = "string"
}

variable "vm_disk1_datastore" {
  type = "string"
}

# SSH KEY Information
variable "icp_private_ssh_key" {
  type = "string"
  default = ""
}

variable "icp_public_ssh_key" {
  type = "string"
  default = ""
}


# ICP Settings
variable "ocp_version" { 
    type="string"
    description = "IBM Cloud Private Version"
    default = "v3.11.16"
}


variable "ocp_cluster_name" {
  type = "string"
}

variable "ocp_admin_user" {
  type = "string"
  default = "admin"
}

variable "ocp_admin_password" {
  type = "string"
  default = "admin"
}

ariable "master_default_subdomain" {
  type = "string"
  default = "admin"
}

ariable "master_cluster_method" {
  type = "string"
  default = "admin"
}

ariable "master_cluster_hostname" {
  type = "string"
  default = "admin"
}

ariable "master_cluster_public_hostname" {
  type = "string"
  default = "admin"
}
variable "enable_metrics" {
  type = "string"
  default = "true"
}

variable "enable_logging" {
  type    = "string"
  default = "true"
}

variable "enable_service_catalog" {
  type = "string"
  default = "false"
}

variable "service_broker_install" {
  type    = "string"
  default = "false"
}




# HAProxy
variable "lb_hostname_ip" {
  type = "map"
}

variable "lb_vcpu" {
  type    = "string"
  default = "2"
}

variable "lb_memory" {
  type = "string"

  default = "4096"
}

variable "lb_vm_ipv4_gateway" {
  type = "string"
}

variable "lb_vm_ipv4_prefix_length" {
  type = "string"
}

variable "lb_vm_disk1_size" {
  type = "string"

  default = "300"
}

variable "lb_vm_disk1_keep_on_remove" {
  type    = "string"
  default = "false"
}



# Master Nodes
variable "master_hostname_ip" {
  type = "map"
}

variable "master_vcpu" {
  type    = "string"
  default = "8"
}

variable "master_memory" {
  type    = "string"
  default = "16384"
}

variable "master_vm_ipv4_gateway" {
  type = "string"
}

variable "master_vm_ipv4_prefix_length" {
  type = "string"
}

variable "master_vm_disk1_size" {
  type    = "string"
  default = "200"
}

variable "master_vm_disk1_keep_on_remove" {
  type    = "string"
  default = "false"
}



#Infra Node
variable "infra_hostname_ip" {
  type = "map"
}

variable "infra_vcpu" {
  type = "string"
  default = "8"
}

variable "infra_memory" {
  type = "string"
  default = "8192"
}

variable "infra_vm_ipv4_gateway" {
  type = "string"
}

variable "infra_vm_ipv4_prefix_length" {
  type = "string"
}

variable "infra_vm_disk1_size" {
  type = "string"
  default = "300"
}

variable "infra_vm_disk1_keep_on_remove" {
  type = "string"
  default = "false"
}


# compute Nodes
variable "compute_hostname_ip" {
  type = "map"
}

variable "compute_vcpu" {
  type    = "string"
  default = "16"
}

variable "compute_memory" {
  type = "string"

  default = "32768"
}

variable "compute_vm_ipv4_gateway" {
  type = "string"
}

variable "compute_vm_ipv4_prefix_length" {
  type = "string"
}

variable "compute_vm_disk1_size" {
  type = "string"

  default = "300"
}

variable "compute_vm_disk1_keep_on_remove" {
  type    = "string"
  default = "false"
}