resource "google_bigquery_dataset" "records" {
  dataset_id    = "fear_greed_records"
  friendly_name = "${var.application_name} records dataset"
  location      = var.region

  default_table_expiration_ms = 2592000000 # 30 days

  labels = local.labels
}

resource "google_bigquery_table" "records" {
  dataset_id          = google_bigquery_dataset.records.dataset_id
  table_id            = "fear_greed_records"
  deletion_protection = false # Set to true for production

  schema = <<EOF
[
  {"name": "created", "type": "TIMESTAMP", "mode": "REQUIRED"},
  {"name": "index", "type": "INTEGER", "mode": "REQUIRED"}
]
EOF
}