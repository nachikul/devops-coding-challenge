variable "kubeconfig_path" {}
variable "name" {}
variable "namespace" {}
variable "image" {}
variable "chart" {
  default = "app-chart"
}
variable "chart_version" {
  default = "1.0.0"
}
variable "helm_repo_url" {
  default = "https://charts.bitnami.com/bitnami"
}