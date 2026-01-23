resource "google_bigquery_dataset" "this" {
  dataset_id    = "fear_greed_dataset"
  friendly_name = "${var.application_name} dataset"
  location      = var.region

  default_table_expiration_ms = 2592000000 # 30 days

  labels = local.labels
}

resource "google_bigquery_table" "records" {
  dataset_id          = google_bigquery_dataset.this.dataset_id
  table_id            = "fear_greed_records"
  deletion_protection = false

  schema = <<EOF
[
  {"name": "created", "type": "TIMESTAMP", "mode": "NULLABLE"},
  {"name": "fear_greed_index", "type": "INTEGER", "mode": "NULLABLE"}
]
EOF
}

resource "google_bigquery_table" "orders" {
  dataset_id          = google_bigquery_dataset.this.dataset_id
  table_id            = "stock_trade_orders"
  deletion_protection = false
  schema              = <<EOF
[
  {"name": "created", "type": "TIMESTAMP", "mode": "NULLABLE"},
  {"name": "stock_symbol", "type": "STRING", "mode": "NULLABLE"},
  {"name": "order_type", "type": "STRING", "mode": "NULLABLE"},
  {"name": "quantity", "type": "INT64", "mode": "NULLABLE"},
  {"name": "price", "type": "FLOAT64", "mode": "NULLABLE"},
  {"name": "status", "type": "STRING", "mode": "NULLABLE"},
  {"name": "created_date", "type": "DATE", "mode": "NULLABLE"},
  {"name": "total_value", "type": "FLOAT64", "mode": "NULLABLE"}
]
EOF
}

resource "google_bigquery_table" "orders_request" {
  dataset_id          = google_bigquery_dataset.this.dataset_id
  table_id            = "stock_trade_orders_request"
  deletion_protection = false
  schema              = <<EOF
[
  {"name": "user_id", "type": "STRING", "mode": "NULLABLE"},
  {"name": "stock_symbol", "type": "STRING", "mode": "NULLABLE"},
  {"name": "order_type", "type": "STRING", "mode": "NULLABLE"},
  {"name": "quantity", "type": "INT64", "mode": "NULLABLE"},
  {"name": "price", "type": "FLOAT64", "mode": "NULLABLE"}
]
EOF
}