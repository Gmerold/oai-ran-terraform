# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_name" {
  description = "Name of Juju model to deploy applications to."
  type        = string
  default     = "ran"
}

variable "create_model" {
  description = "Allows to skip Juju model creation and re-use a model created in a higher level module."
  type        = bool
  default     = true
}

variable "cu_channel" {
  description = "The channel to use when deploying Charmed OAI RAN CU."
  type        = string
  default     = "2.1/edge"
}
variable "cu_config" {
  description = "Application config for the CU. Details about available options can be found at https://charmhub.io/oai-ran-cu-k8s/configurations."
  type        = map(string)
  default     = {}
}

variable "du_channel" {
  description = "The channel to use when deploying Charmed OAI RAN DU."
  type        = string
  default     = "2.1/edge"
}
variable "du_config" {
  description = "Application config for the DU. Details about available options can be found at https://charmhub.io/oai-ran-du-k8s/configurations."
  type        = map(string)
  default     = {}
}

# Grafana Agent K8s

variable "grafana_agent_channel" {
  description = "The channel to use when deploying `grafana-agent-k8s` charm."
  type        = string
  default     = "latest/stable"
}
variable "grafana_agent_config" {
  description = "Additional configuration for the Grafana Agent. Details about available options can be found at https://charmhub.io/grafana-agent-k8s/configure."
  type        = map(string)
  default     = {}
}

# Canonical Observability Stack (COS)

variable "deploy_cos" {
  description = "When set to `true`, COS will be deployed along with SD-Core. COS will use a separate model on the same Juju controller."
  type        = bool
  default     = false
}
variable "use_existing_cos" {
  description = "Allows integrating with an existing COS deployment. When set to `true`, `cos_model_name`, `prometheus_remote_write_offer_url` and `loki_logging_offer_url` are required."
  type        = bool
  default     = false
}

variable "cos_model_name" {
  description = "Name of COS Juju model. This model will be created if `deploy_cos` is set to true or used as a source when integrating with existing COS deployment."
  type        = string
  default     = "cos-lite"
}

variable "prometheus_remote_write_offer_url" {
  description = "URL of Prometheus's `remote_write` offer. This variable is used to integrate with an existing COS deployment."
  type        = string
  default     = ""

  validation {
    condition     = var.use_existing_cos && length(var.prometheus_remote_write_offer_url) == 0
    error_message = "Variable `prometheus_remote_write_offer_url` is required."
  }
}
variable "loki_logging_offer_url" {
  description = "URL of Loki's `logging` offer. This variable is used to integrate with an existing COS deployment."
  type        = string
  default     = ""

  validation {
    condition     = var.use_existing_cos && length(var.loki_logging_offer_url) == 0
    error_message = "Variable `loki_logging_offer_url` is required."
  }
}

variable "cos_configuration_config" {
  description = "COS Configuration application config. Details about available options can be found at https://charmhub.io/cos-configuration-k8s/configure."
  type        = map(string)
  default = {
    git_repo                = "https://github.com/canonical/sdcore-cos-configuration"
    git_branch              = "main"
    grafana_dashboards_path = "grafana_dashboards/sdcore/"
  }
}
