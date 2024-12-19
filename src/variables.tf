variable "config_file" {
  description = "Ruta al archivo de configuración YAML"
  type        = string
  default     = "config/infrastructure.yaml"
}

variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "region" {
  description = "Región de GCP"
  type        = string
  default     = "us-central1"
} 