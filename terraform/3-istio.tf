resource "helm_release" "istio-base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = "istio-system"
  version          = "1.21.1"
  create_namespace = true
  wait             = true
  timeout          = 300
  values           = [file("${path.module}/values/istio-base.yaml")]
  depends_on       = [null_resource.namespace_istio-system]
}

resource "helm_release" "istio-istiod" {
  name             = "istio-istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  namespace        = "istio-system"
  version          = "1.21.1"
  create_namespace = true
  wait             = true
  timeout          = 300
  values           = [file("${path.module}/values/istio-istiod.yaml")]
  depends_on       = [helm_release.istio-base]
}

resource "helm_release" "istio-ingressgateway" {
  name             = "istio-ingressgateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  namespace        = "istio-ingress"
  version          = "1.21.1"
  create_namespace = true
  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }
  wait       = true
  timeout    = 300
  values     = [file("${path.module}/values/istio-gateway.yaml")]
  depends_on = [null_resource.namespace_istio-ingress, helm_release.istio-istiod]
}
