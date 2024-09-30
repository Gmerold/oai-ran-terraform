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
