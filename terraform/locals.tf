locals {
  labels = {
    app = var.application_name
  }
  health_check_endpoints = [{
    endpoint = "ping"
  }]
}
