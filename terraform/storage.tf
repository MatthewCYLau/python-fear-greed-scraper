module "asset_storage_bucket" {
  # for_each                   = local.asset_storage_bucket_names
  for_each = {
    for index, v in local.asset_storage_bucket_name_maps :
    v.name => v
  }
  source                     = "./modules/asset-storage-bucket"
  bucket_name                = each.value.name
  application_name           = var.application_name
  cloud_run_runtime_sa_email = google_service_account.cloud_run_runtime.email
}

output "bucket_names" {
  value = values(module.asset_storage_bucket).*.storage_bucket_name
}