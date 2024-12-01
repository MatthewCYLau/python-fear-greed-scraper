resource "google_storage_bucket" "assets_uploads" {
  name          = "python-fear-greed-assets-uploads"
  location      = "EUROPE-WEST2"
  storage_class = "STANDARD"
  labels = {
    app = var.application_name
  }
}

data "google_iam_policy" "viewer" {
  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers",
    ]
  }

  binding {
    role = "roles/storage.legacyBucketReader"
    members = [
      "serviceAccount:${google_service_account.cloud_run_runtime.email}"
    ]
  }

  binding {
    role = "roles/storage.legacyBucketWriter"
    members = [
      "serviceAccount:${google_service_account.cloud_run_runtime.email}"
    ]
  }
}

resource "google_storage_bucket_iam_policy" "viewer" {
  bucket      = google_storage_bucket.assets_uploads.name
  policy_data = data.google_iam_policy.viewer.policy_data
}

resource "google_storage_bucket" "assets_plots" {
  name          = "python-fear-greed-assets-plots"
  location      = "EUROPE-WEST2"
  storage_class = "STANDARD"
  labels = {
    app = var.application_name
  }
}

data "google_iam_policy" "plots_viewer" {
  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers",
    ]
  }

  binding {
    role = "roles/storage.legacyBucketReader"
    members = [
      "serviceAccount:${google_service_account.cloud_run_runtime.email}"
    ]
  }

  binding {
    role = "roles/storage.legacyBucketWriter"
    members = [
      "serviceAccount:${google_service_account.cloud_run_runtime.email}"
    ]
  }
}

resource "google_storage_bucket_iam_policy" "plots_viewer" {
  bucket      = google_storage_bucket.assets_plots.name
  policy_data = data.google_iam_policy.plots_viewer.policy_data
}