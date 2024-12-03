variable "name" {
  description = "Release name for Helm chart"
}

variable "chart_version" {
  description = "Version of the Helm chart"
  default     = "" # Leave empty for local charts
}

variable "image" {
  description = "Docker image for the application"
}

variable "kubeconfig_path" {
  description = "Kubeconfig Path"
}