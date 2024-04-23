resource "null_resource" "namespace_monitoring" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOF
      kubectl create namespace monitoring && \
      kubectl label namespace monitoring istio-injection=enabled --overwrite
    EOF
  }

  depends_on = [kind_cluster.new]
}

resource "null_resource" "namespace_app" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOF
      kubectl create namespace app && \
      kubectl label namespace app istio-injection=enabled --overwrite
    EOF
  }

  depends_on = [kind_cluster.new]
}

resource "null_resource" "namespace_istio-system" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOF
      kubectl create namespace istio-system
    EOF
  }

  depends_on = [kind_cluster.new]
}

resource "null_resource" "namespace_istio-ingress" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOF
      kubectl create namespace istio-ingress
    EOF
  }

  depends_on = [kind_cluster.new]
}
