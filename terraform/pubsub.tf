resource "google_pubsub_topic" "analysis_jobs" {
  name = "analysis-jobs-topic"
  schema_settings {
    schema   = "projects/${var.project}/schemas/${google_pubsub_schema.analysis_job.name}"
    encoding = "JSON"
  }
  labels = local.labels
}

resource "google_pubsub_subscription" "analysis_jobs" {
  name                 = "analysis-jobs-subscription"
  topic                = google_pubsub_topic.analysis_jobs.name
  ack_deadline_seconds = 20
  push_config {
    push_endpoint = "${data.google_cloud_run_v2_service.api.uri}/api/subscription-push"
    oidc_token {
      service_account_email = google_service_account.pubsub_invoker.email
    }
    attributes = {
      x-goog-version = "v1"
    }
  }
  labels = local.labels
}

resource "google_pubsub_schema" "analysis_job" {
  name = "analysis-job"
  type = "AVRO"
  definition = jsonencode({
    "type" : "record",
    "name" : "Avro",
    "fields" : [
      {
        "name" : "StockSymbol",
        "type" : "string",
        "default" : ""
      },
      {
        "name" : "JobId",
        "type" : "string",
        "default" : ""
      }
    ]
    }
  )
}