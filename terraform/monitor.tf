resource "google_logging_project_bucket_config" "default" {
  project        = var.project
  location       = "global"
  retention_days = 14
  bucket_id      = "_Default"
}

resource "google_logging_metric" "pub_sub_message_received" {
  name   = "python-fear-greed-api/pub-sub-message-received"
  filter = <<EOT
resource.type = "cloud_run_revision"
resource.labels.service_name = "python-fear-greed-api"
resource.labels.location = "${var.region}"
textPayload: "Received Pub Sub message"
EOT
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

resource "google_monitoring_dashboard" "dashboard" {
  dashboard_json = <<EOF
{
  "category": "CUSTOM",
  "displayName": "Python Fear and Greed API",
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      {
        "height": 4,
        "widget": {
          "title": "Cloud Pub/Sub message received",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"logging.googleapis.com/user/${google_logging_metric.pub_sub_message_received.name}\" resource.type=\"cloud_run_revision\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_RATE",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": []
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s",
                "targetAxis": "Y1",
                "legendTemplate": ""
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 6,
        "xPos": 0,
        "yPos": 0
      },
      {
        "height": 4,
        "width": 6,
        "xPos": 6,
        "yPos": 0,
        "widget": {
          "title": "Cloud Run HTTP requests",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "prometheusQuery": "sum by (\"response_code_class\")(rate({\"__name__\"=\"run.googleapis.com/request_count\",\"monitored_resource\"=\"cloud_run_revision\",\"location\"=\"europe-west1\",\"project_id\"=\"open-source-apps-001\",\"service_name\"=\"python-fear-greed-api\"}[1h]))"
                },
                "plotType": "LINE",
                "targetAxis": "Y1"
              }
            ],
            "chartOptions": {
              "mode": "COLOR",
              "displayHorizontal": false
            },
            "thresholds": [],
            "yAxis": {
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "height": 4,
        "width": 12,
        "xPos": 0,
        "yPos": 4,
        "widget": {
          "title": "Cloud Run Request Latencies (P99, P95, P50)",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"run.googleapis.com/request_latencies\" resource.type=\"cloud_run_revision\" resource.label.service_name=\"python-fear-greed-api\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_PERCENTILE_99",
                      "crossSeriesReducer": "REDUCE_MAX",
                      "groupByFields": ["resource.label.service_name"]
                    }
                  }
                },
                "plotType": "LINE",
                "targetAxis": "Y1",
                "legendTemplate": "P99 Latency"
              },
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"run.googleapis.com/request_latencies\" resource.type=\"cloud_run_revision\" resource.label.service_name=\"python-fear-greed-api\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_PERCENTILE_95",
                      "crossSeriesReducer": "REDUCE_MAX",
                      "groupByFields": ["resource.label.service_name"]
                    }
                  }
                },
                "plotType": "LINE",
                "targetAxis": "Y1",
                "legendTemplate": "P95 Latency"
              }
            ],
            "yAxis": {
              "label": "Latency (ms)",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "height": 4,
        "width": 6,
        "xPos": 0,
        "yPos": 8,
        "widget": {
          "title": "Container CPU & Memory Utilization",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"run.googleapis.com/container/cpu/utilizations\" resource.type=\"cloud_run_revision\" resource.label.service_name=\"python-fear-greed-api\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "groupByFields": ["resource.label.revision_name"]
                    }
                  }
                },
                "plotType": "LINE",
                "targetAxis": "Y1",
                "legendTemplate": "CPU Utilization"
              },
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"run.googleapis.com/container/memory/utilizations\" resource.type=\"cloud_run_revision\" resource.label.service_name=\"python-fear-greed-api\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_MEAN",
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "groupByFields": ["resource.label.revision_name"]
                    }
                  }
                },
                "plotType": "LINE",
                "targetAxis": "Y1",
                "legendTemplate": "Memory Utilization"
              }
            ],
            "yAxis": {
              "label": "Utilization Ratio",
              "scale": "LINEAR"
            }
          }
        }
      },
      {
        "height": 4,
        "width": 6,
        "xPos": 6,
        "yPos": 8,
        "widget": {
          "title": "Active Cloud Run Instances",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"run.googleapis.com/container/instance_count\" resource.type=\"cloud_run_revision\" resource.label.service_name=\"python-fear-greed-api\"",
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "perSeriesAligner": "ALIGN_SUM",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": ["metric.label.state"]
                    }
                  }
                },
                "plotType": "STACKED_BAR",
                "targetAxis": "Y1",
                "legendTemplate": "Instance Count"
              }
            ],
            "yAxis": {
              "label": "Instances",
              "scale": "LINEAR"
            }
          }
        }
      }
    ]
  }
}
EOF
}

resource "google_monitoring_notification_channel" "me" {
  display_name = "Email notification channel"
  type         = "email"
  labels = {
    email_address = "lau.cy.matthew@gmail.com"
  }
  force_delete = false
}

resource "google_monitoring_alert_policy" "cloud_pub_sub" {
  display_name = "Cloud Pub Sub message"
  documentation {
    content = "The $${metric.display_name} metrics of the $${resource.type} $${resource.label.service_name} triggered."
  }
  combiner = "AND"
  conditions {
    display_name = "Received Pub Sub message"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "60s"
      filter          = <<EOT
  metric.type = "logging.googleapis.com/user/${google_logging_metric.pub_sub_message_received.name}"
  resource.type = "cloud_run_revision"
  EOT
      threshold_value = "10"
      trigger {
        count = "1"
      }
      aggregations {
        alignment_period   = "300s"
        group_by_fields    = []
        per_series_aligner = "ALIGN_COUNT"
      }
    }
  }
  notification_channels = [google_monitoring_notification_channel.me.name]

  user_labels = {
    severity = "info"
  }
}