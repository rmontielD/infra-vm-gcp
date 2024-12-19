#!/bin/bash

# Construir la imagen
docker build -t terraform-gcp-tool .

# Ejecutar el comando de terraform pasado como argumento
docker run --rm -it terraform-gcp-tool $@ 