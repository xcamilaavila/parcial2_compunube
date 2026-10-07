#!/bin/bash
cd ~/proyecto2/terraform
terraform destroy -auto-approve
az group list -o table
echo "DESTRUIDO"
