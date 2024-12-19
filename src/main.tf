terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  credentials = jsonencode({
    "type": "service_account",
    "project_id": var.project_id,
    "private_key_id": "mock",
    "private_key": "mock",
    "client_email": "mock@mock.iam.gserviceaccount.com",
    "client_id": "123",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/mock"
  })
}

# Leer configuración del YAML
locals {
  config = yamldecode(file("infrastructure.yaml"))
}

# Crear VMs dinámicamente basadas en la configuración
resource "google_compute_instance" "vm_instances" {
  for_each = {
    for vm in local.config.infrastructure.virtual_machines : vm.name => vm
  }

  name         = each.value.name
  machine_type = each.value.machine_type
  zone         = each.value.zone

  boot_disk {
    initialize_params {
      image = each.value.boot_disk.image
      size  = each.value.boot_disk.size_gb
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral public IP
    }
  }

  tags = each.value.network_tags

  metadata_startup_script = lookup(each.value, "startup_script", null)
}

# Firewall rules para los tags definidos
resource "google_compute_firewall" "http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "https-server"]
}

resource "google_compute_firewall" "postgresql" {
  name    = "allow-postgresql"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["postgresql"]
} 