#!/bin/bash

domain=$1
master_hosts=$2
infra_hosts=$3
compute_hosts=$4
lb=$5

echo > /etc/ansible/hosts
echo "#Create an OSEv3 group that contains the masters, nodes, and etcd groups
[OSEv3:children]
masters
nodes
etcd
lb

# Set variables common for all OSEv3 hosts
[OSEv3:vars]
# SSH user, this user should allow ssh based auth without requiring a password
ansible_ssh_user=root

# If ansible_ssh_user is not root, ansible_become must be set to true
#ansible_become=true

openshift_deployment_type=openshift-enterprise
openshift_image_tag=v3.11.16
openshift_pkg_version=-3.11.16

openshift_master_default_subdomain=${domain}
openshift_docker_options=\"--selinux-enabled --insecure-registry 172.30.0.0/16 --log-driver json-file --log-opt max-size=50M --log-opt max-file=10 --insecure-registry core.harbor.icc --add-registry core.harbor.icc\"

oreg_url=core.harbor.icc/openshift3/ose-\${component}:\${version}
openshift_examples_modify_imagestreams=true

openshift_metrics_install_metrics=true
openshift_logging_install_logging=true
openshift_logging_es_nodeselector={\"node-role.kubernetes.io/infra\": \"true\"}

openshift_enable_service_catalog=false
ansible_service_broker_install=false

# uncomment the following to enable htpasswd authentication; defaults to DenyAllPasswordIdentityProvider
openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider'}]

openshift_disable_check=\"disk_availability,docker_image_availability,memory_availability,docker_storage,package_version\"

openshift_master_cluster_method=native
openshift_master_cluster_hostname=cluster.${domain}
openshift_master_cluster_public_hostname=cluster.${domain}

# host group for masters
[masters]" >> /etc/ansible/hosts

for hostname in ${master_hosts[@]}; do
    echo "${hostname}" >> /etc/ansible/hosts
done


echo "# host group for etcd" >> /etc/ansible/hosts
echo "[etcd]" >> /etc/ansible/hosts
for hostname in ${master_hosts[@]}; do
    echo "${hostname}" >> /etc/ansible/hosts
done

echo "# Specify load balancer host" >> /etc/ansible/hosts
echo "[lb]" >> /etc/ansible/hosts
echo "${lb_host}" >> /etc/ansible/hosts

echo "# host group for nodes, includes region info" >> /etc/ansible/hosts
echo "[nodes]" >> /etc/ansible/hosts

for hostname in ${master_hosts[@]}; do
    echo "${hostname}  openshift_node_group_name='node-config-master'" >> /etc/ansible/hosts
done

for hostname in ${infra_hosts[@]}; do
    echo "${hostname} openshift_node_group_name='node-config-infra'" >> /etc/ansible/hosts
done

for hostname in ${compute_hosts[@]}; do
    echo "${hostname}  openshift_node_group_name='node-config-compute'" >> /etc/ansible/hosts
done
