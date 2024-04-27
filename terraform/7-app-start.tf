locals {
  dkr_img_src_sha256 = sha256(join("", [for f in fileset(".", "${path.module}/../**/*.go") : file(f)]))
}

resource "null_resource" "build_app_image" {
  triggers = {
    kind_cluster      = "${kind_cluster.new.id}"
    file_dockerfile   = filesha256("${path.module}/../ci/Dockerfile")
    file_go_mod       = filesha256("${path.module}/../go.mod")
    file_go_sum       = filesha256("${path.module}/../go.sum")
    go_files_checksum = local.dkr_img_src_sha256
  }

  provisioner "local-exec" {
    command = <<EOF
      docker build -t my-go-app:v0 -f ${path.module}/../ci/Dockerfile ${path.module}/..
      kind load docker-image my-go-app:v0 -n demo-local
    EOF
  }

  depends_on = [null_resource.apply_k8s_manifests]
}

resource "null_resource" "deploy_my_go_app" {
  triggers = {
    kind_cluster = "${null_resource.build_app_image.id}"
    deployment   = filesha256("${path.module}/../ci/deployment.yaml")
  }

  provisioner "local-exec" {
    command = <<EOF
      kubectl apply -f ${path.module}/../ci/deployment.yaml
    EOF
  }

  depends_on = [null_resource.build_app_image]
}
