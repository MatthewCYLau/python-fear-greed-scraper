resource "google_storage_bucket" "this" {
  name          = var.bucket_name
  location      = "EUROPE-WEST2"
  storage_class = "STANDARD"
  force_destroy = true
  labels = {
    app = var.application_name
  }
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}

data "google_iam_policy" "this" {
  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers",
    ]
  }

  binding {
    role = "roles/storage.legacyBucketReader"
    members = [
      "serviceAccount:${var.cloud_run_runtime_sa_email}"
    ]
  }

  binding {
    role = "roles/storage.legacyBucketWriter"
    members = [
      "serviceAccount:${var.cloud_run_runtime_sa_email}"
    ]
  }
}

resource "google_storage_bucket_iam_policy" "this" {
  bucket      = google_storage_bucket.this.name
  policy_data = data.google_iam_policy.this.policy_data
}

output storage_bucket_name {
  value       = google_storage_bucket.this.name
  description = "Storage bucket name"
}
