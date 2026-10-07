#!/bin/bash
cd ~/proyecto2/terraform || exit 1
HAPROXY_IP=$(terraform output -raw haproxy_public_ip)
MICRO_IP=$(terraform output -raw microservices_public_ip)
cat > ~/proyecto2/ansible/inventory.ini <<INV
[haproxy]
vm-haproxy ansible_host=$HAPROXY_IP

[microservices]
vm-microservices ansible_host=$MICRO_IP
INV
echo "inventory.ini generado"
