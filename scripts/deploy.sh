#!/bin/bash

cd src

# Inicializar Terraform
terraform init

# Planear los cambios
terraform plan

# Aplicar los cambios
terraform apply -auto-approve 