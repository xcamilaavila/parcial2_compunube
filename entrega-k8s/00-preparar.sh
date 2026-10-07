#!/bin/bash
kubectl create namespace microapp
kubectl create secret generic app-secretos -n microapp --from-literal=MYSQL_ROOT_PASSWORD=$(openssl rand -hex 12) --from-literal=FLASK_SECRET_KEY=$(openssl rand -hex 16)
kubectl create configmap mysql-init -n microapp --from-file=sql
