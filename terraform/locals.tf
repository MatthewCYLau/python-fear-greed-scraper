locals {
  labels = {
    app = var.application_name
  }
  health_check_endpoints = [{
    endpoint = "ping"
  }]
  asset_storage_bucket_names = toset([
    "python-fear-greed-assets-uploads",
    "python-fear-greed-assets-plots"
  ])

  asset_storage_bucket_name_maps = [{
    name = "python-fear-greed-assets-uploads",
    }, {
    name = "python-fear-greed-assets-plots",
    }, {
    name = "python-fear-greed-assets-plus",
  }]
}
