# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

output "model_name" {
  description = "Name of the Juju model used to deploy COS stack."
  value       = juju_model.cos.name
}

output "alertmanager_app_name" {
  description = "Name of the Alertmanager application in the Juju model."
  value       = module.alertmanager.app_name
}

output "catalogue_app_name" {
  description = "Name of the Catalogue application in the Juju model."
  value       = module.catalogue.app_name
}

output "grafana_app_name" {
  description = "Name of the Grafana application in the Juju model."
  value       = module.grafana.app_name
}

output "loki_app_name" {
  description = "Name of the Loki application in the Juju model."
  value       = module.loki.app_name
}

output "prometheus_app_name" {
  description = "Name of the Prometheus application in the Juju model."
  value       = module.prometheus.app_name
}

output "traefik_app_name" {
  description = "Name of the Traefik application in the Juju model."
  value       = module.traefik.app_name
}

# Cross-model integrations

output "prometheus_remote_write_offer_url" {
  description = "The URL used to created cross-model relation to Prometheus's `remote-write` interface."
  value       = juju_offer.prometheus-remote-write.url
}

output "loki_logging_offer_url" {
  description = "The URL used to created cross-model relation to Loki's `logging` interface."
  value       = juju_offer.loki-logging.url
}
