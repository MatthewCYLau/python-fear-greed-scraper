
resource "google_pubsub_topic" "this" {
  name = var.name
  schema_settings {
    schema   = "projects/${var.project}/schemas/${google_pubsub_schema.this.name}"
    encoding = "JSON"
  }
  labels = var.labels
}

resource "google_pubsub_subscription" "this" {
  name                       = var.name
  topic                      = google_pubsub_topic.this.name
  ack_deadline_seconds       = 20
  message_retention_duration = "1200s" # 20 minutes
  retain_acked_messages      = true

  push_config {
    push_endpoint = var.subscription_push_endpoint
    oidc_token {
      service_account_email = var.pubsub_invoker_sa_email
    }
    attributes = {
      x-goog-version = "v1"
    }
  }
  labels = var.labels
}

resource "google_pubsub_schema" "this" {
  name = trimsuffix(var.name, "s")
  type = "AVRO"
  definition = jsonencode(
    var.schema
  )
}

resource "google_project_iam_member" "this" {
  project = var.project
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${var.cloud_run_runtime_sa_email}"
  condition {
    title       = "resource_name_equals_${var.name}_subscription"
    description = "Resource name equals ${google_pubsub_subscription.this.name}"
    expression  = "resource.name == 'projects/${var.project}/subscriptions/${google_pubsub_subscription.this.name}'"
  }
}