resource "null_resource" "namespace_monitoring" {
  triggers = {
    kind_cluster = "${kind_cluster.new.id}"
  }

  provisioner "local-exec" {
    command = <<EOF
      kubectl get namespace monitoring || kubectl create namespace monitoring
      kubectl label namespace monitoring istio-injection=enabled --overwrite
    EOF
  }

  depends_on = [kind_cluster.new]
}

resource "null_resource" "namespace_app" {
  triggers = {
    kind_cluster = "${kind_cluster.new.id}"
  }

  provisioner "local-exec" {
    command = <<EOF
      kubectl get namespace app || kubectl create namespace app
      kubectl label namespace app istio-injection=enabled --overwrite
    EOF
  }

  depends_on = [kind_cluster.new]
}

resource "null_resource" "namespace_istio-system" {
  triggers = {
    kind_cluster = "${kind_cluster.new.id}"
  }

  provisioner "local-exec" {
    command = <<EOF
      kubectl get namespace istio-system || kubectl create namespace istio-system
    EOF
  }

  depends_on = [kind_cluster.new]
}

resource "null_resource" "namespace_istio-ingress" {
  triggers = {
    kind_cluster = "${kind_cluster.new.id}"
  }

  provisioner "local-exec" {
    command = <<EOF
      kubectl get namespace istio-ingress || kubectl create namespace istio-ingress
    EOF
  }

  depends_on = [kind_cluster.new]
}
