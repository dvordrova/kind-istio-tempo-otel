resource "null_resource" "build_app_image" {
  # Triggers to re-run the script on changes
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOF
      docker build -t my-go-app:v0 -f ${path.module}/../ci/Dockerfile ${path.module}/..
      kind load docker-image my-go-app:v0 -n demo-local
      kubectl apply -f ${path.module}/../ci/deployment.yaml
    EOF
  }

  depends_on = [null_resource.restart_tempo_distributed]
}
