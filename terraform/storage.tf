module "asset_storage_bucket" {
  for_each                   = local.asset_storage_bucket_names
  source                     = "./modules/asset-storage-bucket"
  bucket_name                = each.key
  application_name           = var.application_name
  cloud_run_runtime_sa_email = google_service_account.cloud_run_runtime.email
}
