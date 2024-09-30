# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

resource "juju_model" "sdcore" {
  count = var.create_model == true ? 1 : 0
  name  = var.model_name
}

module "upf" {
  source     = "git::https://github.com/canonical/sdcore-upf-k8s-operator//terraform"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
  channel    = var.upf_channel
  config     = var.upf_config
}

module "grafana-agent" {
  source     = "../external/grafana-agent-k8s"
  model_name = var.create_model == true ? juju_model.sdcore[0].name : var.model_name
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

# Integrations for `metrics` endpoint

resource "juju_integration" "upf-metrics" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.upf.app_name
    endpoint = module.upf.metrics_endpoint
  }

  application {
    name     = module.grafana-agent.app_name
    endpoint = module.grafana-agent.metrics_endpoint
  }
}

# Integrations for `logging` endpoint

resource "juju_integration" "upf-logging" {
  model = var.create_model == true ? juju_model.sdcore[0].name : var.model_name

  application {
    name     = module.upf.app_name
    endpoint = module.upf.logging_endpoint
  }

  application {
    name     = module.grafana-agent.app_name
    endpoint = module.grafana-agent.logging_provider_endpoint
  }
}

# Cross-model integrations

resource "juju_integration" "prometheus" {
  count = var.deploy_cos ? 1 : 0
  model = var.model_name

  application {
    name     = module.grafana-agent.app_name
    endpoint = module.grafana-agent.send_remote_write_endpoint
  }

  application {
    offer_url = module.cos-lite[0].prometheus_remote_write_offer_url
  }
}

resource "juju_integration" "loki" {
  count = var.deploy_cos ? 1 : 0
  model = var.model_name

  application {
    name     = module.grafana-agent.app_name
    endpoint = module.grafana-agent.logging_consumer_endpoint
  }

  application {
    offer_url = module.cos-lite[0].loki_logging_offer_url
  }
}
