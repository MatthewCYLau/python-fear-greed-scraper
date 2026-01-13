resource "google_service_account" "cloud_run_invoker" {
  account_id   = "python-scraper-cr-invoker"
  display_name = "Service Account for ${var.cloud-run-job-name} Cloud Run scraper invoker"
}

resource "google_project_iam_member" "cloud_run_invoker" {
  project = var.project
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.cloud_run_invoker.email}"
}

resource "google_service_account" "cloud_run_runtime" {
  account_id   = "python-scraper-cr-runtime"
  display_name = "Service Account for ${var.cloud-run-job-name} Cloud Run API runtime"
}

resource "google_project_iam_member" "analysis_job_pubsub_subscribe" {
  project = var.project
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.cloud_run_runtime.email}"
  condition {
    title       = "resource_name_equals_analysis_jobs_subscription"
    description = "Resource name equals ${google_pubsub_subscription.analysis_jobs.name}"
    expression  = "resource.name == 'projects/${var.project}/subscriptions/${google_pubsub_subscription.analysis_jobs.name}'"
  }
}

resource "google_project_iam_member" "orders_pubsub_subscribe" {
  project = var.project
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.cloud_run_runtime.email}"
  condition {
    title       = "resource_name_equals_orders_subscription"
    description = "Resource name equals ${google_pubsub_subscription.order.name}"
    expression  = "resource.name == 'projects/${var.project}/subscriptions/${google_pubsub_subscription.order.name}'"
  }
}

resource "google_project_iam_member" "cloud_run_runtime_roles" {
  for_each = toset([
    "roles/pubsub.publisher",
  ])
  project = var.project
  role    = each.key
  member  = "serviceAccount:${google_service_account.cloud_run_runtime.email}"
}

resource "google_service_account" "pubsub_invoker" {
  account_id   = "python-api-pubsub-invoker"
  display_name = "Service Account for ${var.cloud-run-job-name} Cloud Run Pub/Sub Invoker"
}

resource "google_project_iam_member" "pubsub_invoker" {
  project = var.project
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.pubsub_invoker.email}"
}

resource "google_project_service_identity" "pubsub_agent" {
  provider = google-beta
  project  = var.project
  service  = "pubsub.googleapis.com"
}

resource "google_project_iam_binding" "project_token_creator" {
  project = var.project
  role    = "roles/iam.serviceAccountTokenCreator"
  members = ["serviceAccount:${google_project_service_identity.pubsub_agent.email}", "user:lau.cy.matthew@gmail.com", ]
}

/* Use google_storage_bucket_iam_policy over google_project_iam_member */

/*
resource "google_project_iam_member" "cloud_run_runtime" {
  project = var.project
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.cloud_run_runtime.email}"
  condition {
    title       = "resource_name_equals_client_assets"
    description = "Resource name equals client assets storage bucket"
    expression  = "resource.name == '${google_storage_bucket.assets.name}'"
  }
}
*/

resource "google_project_iam_member" "github_action_sa" {
  project = var.project
  role    = "roles/storage.admin"
  member  = "serviceAccount:github-actions-service-account@open-source-apps-001.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "bigquery_job_user" {
  project = var.project
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.cloud_run_runtime.email}"
}

resource "google_bigquery_dataset_iam_member" "dataset_editor" {
  dataset_id = google_bigquery_dataset.this.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.cloud_run_runtime.email}"
}
