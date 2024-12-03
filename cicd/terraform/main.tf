resource "helm_release" "app" {
  name       = var.name
  namespace  = var.namespace
  chart      = var.chart
  repository = var.helm_repo_url
  version    = var.chart_version

  values = [
    templatefile("${path.module}/helm_values.yaml", {
      image = var.image
    })
  ]

  depends_on = [
    kubernetes_namespace.app_namespace
  ]
}

resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = var.namespace
  }
}
