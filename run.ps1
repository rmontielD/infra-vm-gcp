# Construir la imagen
docker build -t terraform-gcp-tool .

# Crear directorio state si no existe
if (-not (Test-Path -Path "state")) {
    New-Item -ItemType Directory -Path "state"
}

# Ejecutar el comando de terraform pasado como argumento
docker run --rm -it `
    -e TF_LOG=DEBUG `
    -e TF_VAR_project_id=mi-proyecto-test `
    -v "${PWD}/state:/app/state" `
    -v "${PWD}/src:/app" `
    -v "${PWD}/config/infrastructure.yaml:/app/infrastructure.yaml" `
    -w /app `
    terraform-gcp-tool $args