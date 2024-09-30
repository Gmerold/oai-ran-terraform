# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_model" "oai-ran" {
  count = var.create_model == true ? 1 : 0
  name  = var.model_name
}

module "cu" {
  source     = "git::https://github.com/canonical/oai-ran-cu-k8s-operator//terraform"
  model_name = var.create_model == true ? juju_model.oai-ran[0].name : var.model_name
  channel    = var.cu_channel
  config     = var.cu_config
}

module "du" {
  source     = "git::https://github.com/canonical/oai-ran-du-k8s-operator//terraform"
  model_name = var.create_model == true ? juju_model.oai-ran[0].name : var.model_name
  channel    = var.du_channel
  config     = var.du_config
}

module "grafana-agent" {
  source     = "../external/grafana-agent-k8s"
  model_name = var.create_model == true ? juju_model.oai-ran[0].name : var.model_name
  channel    = var.grafana_agent_channel
  config     = var.grafana_agent_config
}

module "cos-lite" {
  count                    = var.deploy_cos ? 1 : 0
  source                   = "../external/cos-lite"
  model_name               = var.cos_model_name
  deploy_cos_configuration = true
  cos_configuration_config = var.cos_configuration_config
}

# Integrations for `logging` endpoint

resource "juju_integration" "cu-logging" {
  model = var.create_model == true ? juju_model.oai-ran[0].name : var.model_name

  application {
    name     = module.cu.app_name
    endpoint = module.cu.logging_endpoint
  }

  application {
    name     = module.grafana-agent.app_name
    endpoint = module.grafana-agent.logging_provider_endpoint
  }
}

resource "juju_integration" "du-logging" {
  model = var.create_model == true ? juju_model.oai-ran[0].name : var.model_name

  application {
    name     = module.du.app_name
    endpoint = module.du.logging_endpoint
  }

  application {
    name     = module.grafana-agent.app_name
    endpoint = module.grafana-agent.logging_provider_endpoint
  }
}

# Cross-model integrations

resource "juju_integration" "prometheus" {
  count = var.deploy_cos || var.use_existing_cos ? 1 : 0
  model = var.model_name

  application {
    name     = module.grafana-agent.app_name
    endpoint = module.grafana-agent.send_remote_write_endpoint
  }

  application {
    offer_url = length(module.cos-lite[0]) != 0 ? module.cos-lite[0].prometheus_remote_write_offer_url : var.prometheus_remote_write_offer_url
  }
}

resource "juju_integration" "loki" {
  count = var.deploy_cos || var.use_existing_cos ? 1 : 0
  model = var.model_name

  application {
    name     = module.grafana-agent.app_name
    endpoint = module.grafana-agent.logging_consumer_endpoint
  }

  application {
    offer_url = length(module.cos-lite[0]) != 0 ? module.cos-lite[0].loki_logging_offer_url : var.loki_logging_offer_url
  }
}
