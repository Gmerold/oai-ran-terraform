# Copyright 2024 Canonical Ltd.
# See LICENSE file for licensing details.

output "cu_fiveg_gnb_identity_offer_url" {
  description = ""
  value       = juju_offer.cu-fiveg-gnb-identity.url
}

output "cu_app_name" {
  description = "Name of the deployed CU application."
  value       = module.cu.app_name
}

output "fiveg_n2_endpoint" {
  description = "Name of the endpoint to integrate with fiveg_n2 interface."
  value       = module.cu.fiveg_n2_endpoint
}