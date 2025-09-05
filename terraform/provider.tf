terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.1.1"
    }
  }

  backend "gcs" {
    bucket = "python-scraper-tf-state-001"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {

  region  = var.region
  zone    = var.zone
  project = var.project

}