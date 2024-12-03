resource "helm_release" "app" {
  name       = var.name
  namespace  = "default"
  chart      = "${path.module}/../helm/${var.name}"

  values = [
    templatefile("helm_values.yml", {
      image = var.image
    })
  ]
  recreate_pods = true
  cleanup_on_fail = true
}
