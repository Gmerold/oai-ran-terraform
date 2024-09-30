# SD-Core User Plane Terraform Module

This folder contains the [Terraform][Terraform] module to deploy the SD-Core User Plane.

The module uses the [Terraform Juju provider][Terraform Juju provider] to model the charm deployment onto any Kubernetes environment managed by [Juju][Juju].

The module can be used to deploy the `sdcore-user-plane` separately as well as a part of the higher level modules, depending on the deployment architecture.

## Module structure

- **main.tf** - Defines the Juju application to be deployed.
- **variables.tf** - Allows customization of the deployment including Juju model name, charm's channel and configuration.
- **output.tf** - Responsible for integrating the module with other Terraform modules, primarily by defining potential integration endpoints (charm integrations).
- **terraform.tf** - Defines the Terraform provider.

## Deploying sdcore-user-plane module separately

### Pre-requisites

- A UPF host which meets or exceeds below requirements:
  - Ubuntu 24.04
  - CPU supporting AVX2 and RDRAND instructions (Intel Haswell, AMD Excavator or equivalent)
- Juju host
  - Juju>=3.4
- Terraform

### Preparing deployment environment

Install Juju:

```shell
sudo snap install juju --channel=3.4/stable
```

Create `manual` cloud on Juju host: 

```shell
cat << EOF > user-plane-cloud.yaml
clouds:
  user-plane-cloud:
    type: manual
EOF
juju add-cloud user-plane-cloud -f user-plane-cloud.yaml
juju bootstrap manual/<YOUR HOST NAME> sdcore-user-plane
```

Create Juju model:

```shell
juju add-model user-plane
```

Add UPF host to the model:

```shell
juju add-machine ssh:<USERNAME>@<JUJU HOST NAME> --private-key <PATH TO THE SSH PRIVATE KEY>
```

### Deploying sdcore-user-plane with Terraform

Initialize the provider:

```console
terraform init
```

Create the `terraform.tfvars` file to specify the name of the Juju model to deploy to. Reusing already existing model is not recommended.

```console
cat << EOF | tee terraform.tfvars
model_name = "put your model-name here"

# Customize the configuration variables here if needed
EOF
```

Deploy the resources:

```console
terraform apply -var-file="terraform.tfvars" -auto-approve 
```

#### Including Canonical Observability Stack (COS)

The `sdcore-user-plane` doesn't currently support integration with COS.

### Cleaning up

Destroy the deployment:

```console
terraform destroy -auto-approve
```

## Using sdcore-user-plane module in higher level modules

If you want to use `sdcore-user-plane` module as part of your Terraform module, import it like shown below:

```text
module "sdcore-user-plane" {
  source = "git::https://github.com/canonical/https://github.com/canonical/terraform-juju-sdcore//modules/sdcore-user-plane"
  
  model_name = "juju_model_name"
  (Customize configuration variables here if needed)
}
```

[Terraform]: https://www.terraform.io/
[Terraform Juju provider]: https://registry.terraform.io/providers/juju/juju/latest
[Juju]: https://juju.is
