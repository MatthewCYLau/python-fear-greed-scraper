resource "google_cloud_scheduler_job" "python-scraper" {
  provider         = google-beta
  name             = "${var.cloud-run-job-name}-schedule-job"
  description      = "Python scraper scheduled job"
  schedule         = "0 0 * * *"
  attempt_deadline = "320s"
  region           = var.region
  project          = var.project

  retry_config {
    retry_count = 3
  }

  http_target {
    http_method = "POST"
    uri         = "https://${var.region}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${data.google_project.this.number}/jobs/${var.cloud-run-job-name}:run"

    oauth_token {
      service_account_email = google_service_account.cloud_run_invoker.email
    }
  }
}