resource "google_pubsub_topic" "analysis_jobs" {
  name = "analysis-jobs-topic"
  schema_settings {
    schema   = "projects/${var.project}/schemas/${google_pubsub_schema.analysis_job.name}"
    encoding = "JSON"
  }
  labels = local.labels
}

resource "google_pubsub_subscription" "analysis_jobs" {
  name                       = "analysis-jobs-subscription"
  topic                      = google_pubsub_topic.analysis_jobs.name
  ack_deadline_seconds       = 20
  message_retention_duration = "1200s" # 20 minutes
  retain_acked_messages      = true

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
        "name" : "TargetFearGreedIndex",
        "type" : "int",
        "default" : 0
      },
      {
        "name" : "TargetPeRatio",
        "type" : "float",
        "default" : 0
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

resource "google_pubsub_topic" "orders" {
  name = "orders-topic"
  schema_settings {
    schema   = "projects/${var.project}/schemas/${google_pubsub_schema.order.name}"
    encoding = "JSON"
  }
  labels = local.labels
}

resource "google_pubsub_subscription" "order" {
  name                       = "orders-subscription"
  topic                      = google_pubsub_topic.orders.name
  ack_deadline_seconds       = 20
  message_retention_duration = "1200s" # 20 minutes
  retain_acked_messages      = true

  push_config {
    push_endpoint = "${data.google_cloud_run_v2_service.api.uri}/api/orders-subscription-push"
    oidc_token {
      service_account_email = google_service_account.pubsub_invoker.email
    }
    attributes = {
      x-goog-version = "v1"
    }
  }
  labels = local.labels
}

resource "google_pubsub_schema" "order" {
  name = "order"
  type = "AVRO"
  definition = jsonencode({
    "type" : "record",
    "name" : "Avro",
    "fields" : [
      {
        "name" : "user_id",
        "type" : "string",
        "default" : ""
      },
      {
        "name" : "stock_symbol",
        "type" : "string",
        "default" : ""
      },
      {
        "name" : "order_type",
        "type" : "string",
        "default" : ""
      },
      {
        "name" : "quantity",
        "type" : "int",
        "default" : 0
      },
      {
        "name" : "price",
        "type" : "float",
        "default" : 0
      }
    ]
    }
  )
}

resource "google_pubsub_topic" "transactions" {
  name = "transactions-topic"
  schema_settings {
    schema   = "projects/${var.project}/schemas/${google_pubsub_schema.transaction.name}"
    encoding = "JSON"
  }
  labels = local.labels
}

resource "google_pubsub_subscription" "transaction" {
  name                       = "transactions-subscription"
  topic                      = google_pubsub_topic.transactions.name
  ack_deadline_seconds       = 20
  message_retention_duration = "1200s" # 20 minutes
  retain_acked_messages      = true

  push_config {
    push_endpoint = "${data.google_cloud_run_v2_service.api.uri}/api/transactions-subscription-push"
    oidc_token {
      service_account_email = google_service_account.pubsub_invoker.email
    }
    attributes = {
      x-goog-version = "v1"
    }
  }
  labels = local.labels
}

resource "google_pubsub_schema" "transaction" {
  name = "transaction"
  type = "AVRO"
  definition = jsonencode({
    "type" : "record",
    "name" : "Avro",
    "fields" : [
      {
        "name" : "sell_order_user_id",
        "type" : "string",
        "default" : ""
      },
      {
        "name" : "buy_order_user_id",
        "type" : "string",
        "default" : ""
      },
      {
        "name" : "stock_symbol",
        "type" : "string",
        "default" : ""
      },
      {
        "name" : "quantity",
        "type" : "int",
        "default" : 0
      },
      {
        "name" : "price",
        "type" : "float",
        "default" : 0
      }
    ]
    }
  )
}