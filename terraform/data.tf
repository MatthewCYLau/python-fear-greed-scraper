data "google_project" "this" {
}

data "google_cloud_run_v2_service" "api" {
  name     = "python-fear-greed-api"
  location = var.region
}