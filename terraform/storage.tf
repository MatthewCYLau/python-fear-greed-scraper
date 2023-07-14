resource "google_storage_bucket" "assets" {
  name          = "python-fear-greed-client-assets"
  location      = "EUROPE-WEST2"
  storage_class = "STANDARD"
}

data "google_iam_policy" "viewer" {
  binding {
    role = "roles/storage.objectViewer"
    members = [
      "allUsers",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "viewer" {
  bucket      = google_storage_bucket.assets.name
  policy_data = data.google_iam_policy.viewer.policy_data
}