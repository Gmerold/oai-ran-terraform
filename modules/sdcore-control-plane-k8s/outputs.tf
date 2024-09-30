# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

output "amf_app_name" {
  description = "Name of the deployed AMF application."
  value       = module.amf.app_name
}

output "fiveg_n2_endpoint" {
  description = "Name of the endpoint used to provide information on connectivity to the N2 plane."
  value       = module.amf.fiveg_n2_endpoint
}

output "nms_app_name" {
  description = "Name of the deployed NMS application."
  value       = module.nms.app_name
}

output "fiveg_n4_endpoint" {
  description = "Name of the endpoint to integrate with fiveg_n4 interface."
  value       = module.nms.fiveg_n4_endpoint
}

output "fiveg_gnb_identity_endpoint" {
  description = "Name of the endpoint to integrate with fiveg_gnb_identity interface."
  value       = module.nms.fiveg_gnb_identity_endpoint
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