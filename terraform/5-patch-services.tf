# resource "null_resource" "prepare_patches" {
#   # Triggers to re-run the script on changes
#   triggers = {
#     always_run = "${timestamp()}"
#   }

#   provisioner "local-exec" {
#     command = "${path.module}/prepare_patch_service_ports.sh ${path.module}/patches"
#   }

#   depends_on = [helm_release.grafana]
# }

resource "null_resource" "apply_patches" {
  # Triggers to re-run the script on changes
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/apply_patches.sh ${path.module}/patches"
  }

  depends_on = [helm_release.grafana]
  # depends_on = [null_resource.prepare_patches]
}

resource "null_resource" "restart_tempo_distributed" {
  # Triggers to re-run the script on changes
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "kubectl delete pod -n monitoring -l app.kubernetes.io/part-of=memberlist"
  }

  depends_on = [null_resource.apply_patches]
}
