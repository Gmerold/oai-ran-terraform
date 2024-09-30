# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

output "upf_app_name" {
  description = "Name of the deployed UPF application."
  value       = module.upf.app_name
}

output "fiveg_n3_endpoint" {
  description = "Name of the endpoint used to provide information on connectivity to the N3 plane."
  value       = module.upf.fiveg_n3_endpoint
}

output "fiveg_n4_endpoint" {
  description = "Name of the endpoint used to provide information on connectivity to the N4 plane."
  value       = module.upf.fiveg_n4_endpoint
}

output "grafana_agent_app_name" {
  description = "Name of the deployed Grafana-agent application."
  value       = module.grafana-agent.app_name
}

output "send_remote_write_endpoint" {
  description = "Name of the endpoint to forward client charms metrics and associated alert rules to Prometheus using prometheus_remote_write interface."
  value       = module.grafana-agent.send_remote_write_endpoint
}

output "logging_consumer_endpoint" {
  description = "Name of the endpoint to send the logs to Loki using loki_push_api interface."
  value       = module.grafana-agent.logging_consumer_endpoint
}