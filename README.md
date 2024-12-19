# Terraform Infrastructure as Code con YAML

Este proyecto permite desplegar infraestructura en Google Cloud Platform (GCP) utilizando Terraform y archivos de configuración YAML. El proyecto está dockerizado para facilitar su ejecución sin necesidad de instalar Terraform localmente.

## Estructura del Proyecto

    POC_AGENTE/
    ├── config/
    │   └── infrastructure.yaml    # Configuración de infraestructura
    ├── src/
    │   ├── main.tf               # Configuración principal de Terraform
    │   ├── variables.tf          # Definición de variables
    │   ├── outputs.tf            # Outputs de Terraform
    │   └── terraform.tfvars      # Valores de variables
    ├── state/                    # Directorio para el estado de Terraform
    ├── Dockerfile                # Configuración de Docker
    └── run.ps1                   # Script de ejecución

## Funcionalidades

- Despliegue de máquinas virtuales en GCP con configuración personalizable
- Configuración de firewall rules basadas en tags
- Scripts de inicio personalizados para cada VM
- Gestión de estado de Terraform
- Ejecución containerizada

## Configuración de Infraestructura

El archivo infrastructure.yaml permite definir:

- Máquinas virtuales con:
  - Nombre y tipo de máquina
  - Zona de despliegue
  - Configuración de disco de arranque
  - Tags de red
  - Scripts de inicio

Ejemplo:

    infrastructure:
      virtual_machines:
        - name: vm-web
          machine_type: e2-medium
          zone: us-central1-a
          boot_disk:
            image: debian-cloud/debian-11
            size_gb: 20
          network_tags:
            - http-server
          startup_script: |
            #!/bin/bash
            apt-get update

## Reglas de Firewall

Se crean automáticamente reglas de firewall basadas en los tags:
- HTTP/HTTPS (puertos 80/443)
- PostgreSQL (puerto 5432)

## Uso

1. Configurar la infraestructura en config/infrastructure.yaml

2. Ejecutar los comandos:

    # Inicializar Terraform
    ./run.ps1 init
    
    # Ver plan de cambios
    ./run.ps1 plan
    
    # Aplicar cambios
    ./run.ps1 apply
    
    # Destruir infraestructura
    ./run.ps1 destroy

## Variables de Entorno

- TF_LOG: Nivel de logging (DEBUG por defecto)
- TF_VAR_project_id: ID del proyecto GCP

## Notas

- El proyecto usa credenciales mock para pruebas
- Para producción, reemplazar las credenciales mock con credenciales reales de GCP
- Los estados de Terraform se almacenan localmente en el directorio state/
