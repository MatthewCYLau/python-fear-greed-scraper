resource "null_resource" "health_checks" {

  for_each = {
    for index, v in local.health_check_endpoints :
    v.endpoint => v
  }

  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "sh ./scripts/health-check.sh '${each.value.endpoint}'"
  }
}