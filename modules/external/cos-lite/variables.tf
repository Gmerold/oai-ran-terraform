# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_name" {
  description = "Name of the Juju model to deploy applications to."
  type        = string
  default     = "cos"
}

# Alertmanager
variable "alertmanager_app_name" {
  description = "Name of the Alertmanager application."
  type        = string
  default     = "alertmanager"
}
variable "alertmanager_channel" {
  description = "The channel to use when deploying Alertmanager charm."
  type        = string
  default     = "latest/stable"
}
variable "alertmanager_config" {
  description = "Application config. Details about available options can be found at https://charmhub.io/alertmanager-k8s/configure."
  type        = map(string)
  default     = {}
}

# Catalogue
variable "catalogue_app_name" {
  description = "Name of the Catalogue application."
  type        = string
  default     = "catalogue"
}
variable "catalogue_channel" {
  description = "The channel to use when deploying Catalogue charm."
  type        = string
  default     = "latest/stable"
}
variable "catalogue_config" {
  description = "Catalogue config. Details about available options can be found at https://charmhub.io/catalogue-k8s/configure."
  type        = map(string)
  default     = {}
}

# COS Configuration
variable "deploy_cos_configuration" {
  description = "Controls whether the cos-configuration-k8s charm will be deployed as part of the stack or not."
  type        = bool
  default     = false
}
variable "cos_configuration_app_name" {
  description = "Name of the cos-configuration application."
  type        = string
  default     = "cos-configuration"
}
variable "cos_configuration_channel" {
  description = "The channel to use when deploying cos-configuration-k8s charm."
  type        = string
  default     = "latest/stable"
}
variable "cos_configuration_config" {
  description = "COS Configuration application config. Details about available options can be found at https://charmhub.io/cos-configuration-k8s/configure."
  type        = map(string)
  default     = {}
}

# Grafana
variable "grafana_app_name" {
  description = "Name of the Grafana application."
  type        = string
  default     = "grafana"
}
variable "grafana_channel" {
  description = "The channel to use when deploying Grafana charm."
  type        = string
  default     = "latest/stable"
}
variable "grafana_config" {
  description = "Grafana config. Details about available options can be found at https://charmhub.io/grafana-k8s/configure."
  type        = map(string)
  default     = {}
}

# Loki
variable "loki_app_name" {
  description = "Name of the Loki application."
  type        = string
  default     = "loki"
}
variable "loki_channel" {
  description = "The channel to use when deploying Loki charm."
  type        = string
  default     = "latest/stable"
}
variable "loki_config" {
  description = "Loki config. Details about available options can be found at https://charmhub.io/loki-k8s/configure."
  type        = map(string)
  default     = {}
}

# Prometheus
variable "prometheus_app_name" {
  description = "Name of the Prometheus application."
  type        = string
  default     = "prometheus"
}
variable "prometheus_channel" {
  description = "The channel to use when deploying Prometheus charm."
  type        = string
  default     = "latest/stable"
}
variable "prometheus_config" {
  description = "Application config. Details about available options can be found at https://charmhub.io/prometheus-k8s/configure."
  type        = map(string)
  default     = {}
}

# Traefik
variable "traefik_app_name" {
  description = "Name of the Traefik application."
  type        = string
  default     = "traefik"
}
variable "traefik_channel" {
  description = "The channel to use when deploying Traefik charm."
  type        = string
  default     = "latest/stable"
}
variable "traefik_config" {
  description = "Traefik config. Details about available options can be found at https://charmhub.io/traefik-k8s/configure."
  type        = map(string)
  default     = {}
}
