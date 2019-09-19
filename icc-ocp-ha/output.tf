#
output "openshift_master_cluster_url" {
  value = "https://cluster.${var.domain}:8443"
}

output "openshift_admin_user" {
  value = "${var.ocp_admin_user}"
}

output "openshift_admin_password" {
  value = "${var.ocp_admin_password}"
}
