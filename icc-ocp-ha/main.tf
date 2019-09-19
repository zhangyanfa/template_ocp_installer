provider "vsphere" {
  version              = "~> 1.3"
  allow_unverified_ssl = "true"
}

provider "random" {
  version = "~> 1.0"
}

provider "local" {
  version = "~> 1.1"
}

provider "null" {
  version = "~> 1.0"
}

provider "tls" {
  version = "~> 1.0"
}

data "local_file" "example" {
  depends_on = ["null_resource.icp_hosts_files"]
  filename   = "${path.module}/scripts/install_ha.sh"
}

resource "random_string" "random-dir" {
  length  = 8
  special = false
}

resource "tls_private_key" "generate" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "null_resource" "create-temp-random-dir" {
  provisioner "local-exec" {
    command = "${format("mkdir -p  /tmp/%s" , "${random_string.random-dir.result}")}"
  }
}

/*resource "vsphere_folder" "folder" {
  path          = "${var.vm_folder}"
  type          = "vm"
  datacenter_id = "${data.vsphere_datacenter.vsphere_datacenter.id}"
}*/

module "deployVM_master" {
  source = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.2//vmware_provision"

  #######
  vsphere_datacenter    = "${var.vsphere_datacenter}"
  vsphere_resource_pool = "${var.vsphere_resource_pool}"

  count = "${length(keys(var.master_hostname_ip))}"

  vm_vcpu                    = "${var.master_vcpu}" 
  vm_name                    = "${keys(var.master_hostname_ip)}"
  vm_memory                  = "${var.master_memory}"
  vm_template                = "${var.vm_template}"
  vm_os_password             = "${var.vm_os_password}"
  vm_os_user                 = "${var.vm_os_user}"
  vm_domain                  = "${var.vm_domain}"
  vm_folder                  = "${var.vm_folder}"
  vm_private_ssh_key         = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${var.icp_private_ssh_key}"}"
  vm_public_ssh_key          = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_network_interface_label = "${var.vm_network_interface_label}"
  vm_ipv4_gateway            = "${var.master_vm_ipv4_gateway}"
  vm_ipv4_address         = "${values(var.master_hostname_ip)}"
  vm_ipv4_prefix_length   = "${var.master_vm_ipv4_prefix_length}"
  vm_adapter_type         = "${var.vm_adapter_type}"
  vm_disk1_size           = "${var.master_vm_disk1_size}"
  vm_disk1_datastore      = "${var.vm_disk1_datastore}"
  vm_disk1_keep_on_remove = "${var.master_vm_disk1_keep_on_remove}"
  vm_disk2_enable         = "false"
  vm_disk2_size           = ""
  vm_disk2_datastore      = ""
  vm_disk2_keep_on_remove = ""
  vm_dns_servers          = "${var.vm_dns_servers}"
  #vm_dns_suffixes         = "${var.vm_dns_suffixes}"
  vm_dns_suffixes         = ["icc"]
  vm_clone_timeout        = "${var.vm_clone_timeout}"
  random                  = "${random_string.random-dir.result}"

  bastion_host        = ""
  bastion_user        = ""
  bastion_private_key = ""
  bastion_port        = 0
  bastion_host_key    = ""
  bastion_password    = ""    
}

module "deployVM_infra" {
  source = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.2//vmware_provision"

  #######
  vsphere_datacenter    = "${var.vsphere_datacenter}"
  vsphere_resource_pool = "${var.vsphere_resource_pool}"

  count = "${length(keys(var.infra_hostname_ip))}"

  vm_vcpu                    = "${var.infra_vcpu}"
  vm_name                    = "${keys(var.infra_hostname_ip)}"
  vm_memory                  = "${var.infra_memory}"
  vm_template                = "${var.vm_template}"
  vm_os_password             = "${var.vm_os_password}"
  vm_os_user                 = "${var.vm_os_user}"
  vm_domain                  = "${var.vm_domain}"
  vm_folder                  = "${var.vm_folder}"
  vm_private_ssh_key         = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${var.icp_private_ssh_key}"}"
  vm_public_ssh_key          = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_network_interface_label = "${var.vm_network_interface_label}"
  vm_ipv4_gateway            = "${var.infra_vm_ipv4_gateway}"
  vm_ipv4_address         = "${values(var.infra_hostname_ip)}"
  vm_ipv4_prefix_length   = "${var.infra_vm_ipv4_prefix_length}"
  vm_adapter_type         = "${var.vm_adapter_type}"
  vm_disk1_size           = "${var.infra_vm_disk1_size}"
  vm_disk1_datastore      = "${var.vm_disk1_datastore}"
  vm_disk1_keep_on_remove = "${var.infra_vm_disk1_keep_on_remove}"
  vm_disk2_enable         = "false"
  vm_disk2_size           = ""
  vm_disk2_datastore      = ""
  vm_disk2_keep_on_remove = ""
  vm_dns_servers          = "${var.vm_dns_servers}"
  vm_dns_suffixes         = ["icc"]
  #vm_dns_suffixes         = "${var.vm_dns_suffixes}"
  vm_clone_timeout        = "${var.vm_clone_timeout}"
  random                  = "${random_string.random-dir.result}"
  enable_vm               = "${var.enable_vm_management}"

  #######
  bastion_host        = ""
  bastion_user        = ""
  bastion_private_key = ""
  bastion_port        = 0
  bastion_host_key    = ""
  bastion_password    = ""
}

module "deployVM_compute" {
  source = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.2//vmware_provision"

  #######
  vsphere_datacenter    = "${var.vsphere_datacenter}"
  vsphere_resource_pool = "${var.vsphere_resource_pool}"

  count = "${length(keys(var.worker_hostname_ip))}"

  vm_vcpu                    = "${var.worker_vcpu}"
  vm_name                    = "${keys(var.worker_hostname_ip)}"
  vm_memory                  = "${var.worker_memory}"
  vm_template                = "${var.vm_template}"
  vm_os_password             = "${var.vm_os_password}"
  vm_os_user                 = "${var.vm_os_user}"
  vm_domain                  = "${var.vm_domain}"
  vm_folder                  = "${var.vm_folder}"
  vm_private_ssh_key         = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${var.icp_private_ssh_key}"}"
  vm_public_ssh_key          = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_network_interface_label = "${var.vm_network_interface_label}"
  vm_ipv4_gateway            = "${var.worker_vm_ipv4_gateway}"
  vm_ipv4_address         = "${values(var.worker_hostname_ip)}"
  vm_ipv4_prefix_length   = "${var.worker_vm_ipv4_prefix_length}"
  vm_adapter_type         = "${var.vm_adapter_type}"
  vm_disk1_size           = "${var.worker_vm_disk1_size}"
  vm_disk1_datastore      = "${var.vm_disk1_datastore}"
  vm_disk1_keep_on_remove = "${var.worker_vm_disk1_keep_on_remove}"
  vm_disk2_enable         = "false"
  vm_disk2_size           = ""
  vm_disk2_datastore      = ""
  vm_disk2_keep_on_remove = ""
  vm_dns_servers          = "${var.vm_dns_servers}"
  vm_dns_suffixes         = ["icc"]
  #vm_dns_suffixes         = "${var.vm_dns_suffixes}"
  vm_clone_timeout        = "${var.vm_clone_timeout}"
  random                  = "${random_string.random-dir.result}"
  #######
  bastion_host        = ""
  bastion_user        = ""
  bastion_private_key = ""
  bastion_port        = 0
  bastion_host_key    = ""
  bastion_password    = "" 
}

module "deployVM_LB" {
  source = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.2//vmware_provision"

  #######
  vsphere_datacenter    = "${var.vsphere_datacenter}"
  vsphere_resource_pool = "${var.vsphere_resource_pool}"

  # count                 = "${length(var.nfs_server_vm_ipv4_address)}"
  #count = "${length(keys(var.nfs_server_hostname_ip))}"

  // vm_folder = "${module.createFolder.folderPath}"

  vm_vcpu                    = "${var.lb_server_vcpu}"
  vm_name                    = ["${var.icp_cluster_name}-lb"]
  vm_memory                  = "${var.lb_server_memory}"
  vm_template                = "${var.vm_template}"
  vm_os_password             = "${var.vm_os_password}"
  vm_os_user                 = "${var.vm_os_user}"
  vm_domain                  = "${var.vm_domain}"
  vm_folder                  = "${var.vm_folder}"
  vm_private_ssh_key         = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${var.icp_private_ssh_key}"}"
  vm_public_ssh_key          = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_network_interface_label = "${var.vm_network_interface_label}"
  vm_ipv4_gateway            = "${var.nfs_server_vm_ipv4_gateway}"
  vm_ipv4_address         = ["${var.nfs_server_hostname_ip}"]
  vm_ipv4_prefix_length   = "${var.nfs_server_vm_ipv4_prefix_length}"
  vm_adapter_type         = "${var.vm_adapter_type}"
  vm_disk1_size           = "${var.nfs_server_vm_disk1_size}"
  vm_disk1_datastore      = "${var.vm_disk1_datastore}"
  vm_disk1_keep_on_remove = "${var.nfs_server_vm_disk1_keep_on_remove}"
  vm_disk2_enable         = "false"
  vm_disk2_size           = ""
  vm_disk2_datastore      = ""
  vm_disk2_keep_on_remove = ""
  vm_dns_servers          = "${var.vm_dns_servers}"
  vm_dns_suffixes         = ["icc"]
  vm_clone_timeout        = "${var.vm_clone_timeout}"
  random                  = "${random_string.random-dir.result}"
  enable_vm               = "${var.enable_nfs}"
  #######
  bastion_host        = ""
  bastion_user        = ""
  bastion_private_key = ""
  bastion_port        = 0
  bastion_host_key    = ""
  bastion_password    = ""   
}

module "push_hostfile" {
  source               = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.2//config_hostfile"
  
  private_key          = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${var.icp_private_ssh_key}"}"
  vm_os_user           = "${var.vm_os_user}"
  vm_os_password       = "${var.vm_os_password}"
  vm_ipv4_address_list = "${compact(split(",", replace(join(",",concat(values(var.master_hostname_ip), values(var.infra_hostname_ip), values(var.compute_hostname_ip), values(var.lb_hostname_ip))),"/0.0.0.0/", "" )))}"
  random               = "${random_string.random-dir.result}"
  #######
  #bastion_host        = "${var.bastion_host}"
  #bastion_user        = "${var.bastion_user}"
  #bastion_private_key = "${var.bastion_private_key}"
  #bastion_port        = "${var.bastion_port}"
  #bastion_host_key    = "${var.bastion_host_key}"
  #bastion_password    = "${var.bastion_password}"
  bastion_host        = ""
  bastion_user        = ""
  bastion_private_key = ""
  bastion_port        = 0
  bastion_host_key    = ""
  bastion_password    = ""
  #dependsOn            = "${module.icp_prereqs.dependsOn}"
  dependsOn = "${module.deployVM_infra.dependsOn}+${module.deployVM_master.dependsOn}+${module.deployVM_compute.dependsOn}+${module.deployVM_LB.dependsOn}"
}

resource "local_file" "generate_install_shell" {
  depends_on = ["module.push_hostfile"]
  content    = "${data.local_file.example.content}"
  filename   = "/tmp/${var.random}/generate_icp_hosts.sh"
}

resource "null_resource" "setup_installer" {
  #depends_on = ["push_hostfile"]
  
  depends_on = ["local_file.generate_install_shell"]

  master_ips  = "${join(",", values(var.master_hostname_ip))}"
  infra_ips   = "${join(",", values(var.infra_hostname_ip))}"
  compute_ips = "${join(",", values(var.compute_hostname_ip))}"
  lb_ips      = "${join(",", values(var.lb_hostname_ip))}"

  master_keys  = "${join(" ", keys(var.master_hostname_ip))}"
  infra_keys   = "${join(" ", keys(var.infra_hostname_ip))}"
  compute_keys = "${join(" ", keys(var.compute_hostname_ip))}"
  lb_keys      = "${ element(keys(var.lb_hostname_ip), 0) }"

  master_count = "${length(keys(var.master_hostname_ip))}"
  infra_count = "${length(keys(var.infra_hostname_ip))}"
  compute_count = "${length(keys(var.compute_hostname_ip))}"
  #count = "${0}"

  connection {
    type        = "ssh"
    user        = "${var.vm_os_user}"
    password    = "${var.vm_os_password}"
    #private_key = "${var.private_key}"
    #host        = "${var.master_hostname_ip["master1"]}"
    host         = "${ element(values(var.master_hostname_ip), 0) }"
  }

  provisioner "local-exec" {
    command = "scp /${path.module}/script/install_ha.sh root@${ element(values(var.master_hostname_ip), 0) }:/opt/install_ha.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 777 /opt/install_ha.sh",
      "/opt/install_ha.sh ${domain} ${master_keys} ${infra_keys} ${compute_keys} ${lb_keys}"
    ]
  }
}

resource "null_resource" "icp_install_finished" {
  depends_on = ["null_resource.setup_installer"]

  provisioner "local-exec" {
    command = "echo 'ICP MultiNode has been installed.'"
  }
}
