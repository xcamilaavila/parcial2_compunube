#!/bin/bash
set -e
cd ~/proyecto2/terraform
terraform apply -auto-approve
cp terraform.tfstate /vagrant/terraform-backup/ 2>/dev/null || true
for ip in $(terraform output -raw haproxy_public_ip) $(terraform output -raw microservices_public_ip); do
  until ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=5 azureuser@$ip true 2>/dev/null; do
    echo "esperando SSH en $ip..."
    sleep 10
  done
done
~/proyecto2/ansible/gen-inventory.sh
cd ~/proyecto2/ansible
ansible-playbook site.yml
ansible-playbook balanceo.yml
echo "DESPLIEGUE COMPLETO"
