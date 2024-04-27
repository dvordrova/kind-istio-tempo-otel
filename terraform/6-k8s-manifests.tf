resource "null_resource" "apply_k8s_manifests" {
  triggers = {
    kind_cluster = "${kind_cluster.new.id}"
  }

  provisioner "local-exec" {
    command = <<EOF
      for file in ${path.module}/k8s/*; do
        echo "Apply kubectl patch: $file"
        kubectl apply -f $file
      done
    EOF
  }

  depends_on = [helm_release.grafana]
}
