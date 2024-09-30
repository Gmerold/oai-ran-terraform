# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_name" {
  description = "Name of Juju model to deploy application to."
  type        = string
  default     = ""
}

variable "create_model" {
  description = "Allows to skip Juju model creation and re-use a model created in a higher level module."
  type        = bool
  default     = true
}

variable "upf_channel" {
  description = "The channel to use when deploying `sdcore-upf` charm."
  type        = string
  default     = "1.4/edge"
}

variable "machine_number" {
  description = "The machine unit number to use for placement."
  type        = number
  default     = 0
}

variable "upf_config" {
  description = "Application config for the UPF. Details about available options can be found at https://charmhub.io/sdcore-upf-operator/configure."
  type        = map(string)
  default     = {}
}
