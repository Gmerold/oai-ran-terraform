# SD-Core User Plane Terraform Module

This folder contains the [Terraform][Terraform] module to deploy the [sdcore-user-plane-k8s][sdcore-user-plane-k8s] bundle.

The module uses the [Terraform Juju provider][Terraform Juju provider] to model the charm deployment onto any Kubernetes environment managed by [Juju][Juju].

The module can be used to deploy the `sdcore-user-plane-k8s` separately as well as a part of the higher level modules, depending on the deployment architecture.

## Module structure

- **main.tf** - Defines the Juju application to be deployed.
- **variables.tf** - Allows customization of the deployment including Juju model name, charm's channel and configuration.
- **output.tf** - Responsible for integrating the module with other Terraform modules, primarily by defining potential integration endpoints (charm integrations).
- **terraform.tf** - Defines the Terraform provider.

## Deploying sdcore-user-plane-k8s module separately

### Pre-requisites

The following tools need to be installed and should be running in the environment.

- A Kubernetes host with a CPU supporting AVX2 and RDRAND instructions (Intel Haswell, AMD Excavator or equivalent)
- A Kubernetes cluster with the `Multus` and `Metallb` addon enabled.
- The Load balancer (MetalLB) has address range with at least 1 available IP address
- Juju>=3.4
- Juju controller bootstrapped onto the K8s cluster
- Terraform

### Preparing deployment environment

Install MicroK8s and add your user to the snap_microk8s group:

```shell
sudo snap install microk8s --channel=1.29-strict/stable
sudo usermod -a -G snap_microk8s $USER
newgrp snap_microk8s
```

Add the community repository for Multus MicroK8s addon:

```shell
sudo microk8s addons repo add community https://github.com/canonical/microk8s-community-addons --reference feat/strict-fix-multus
```

Enable the `hostpath-storage`, `multus` and `metallb` MicroK8s addons.

```shell
sudo microk8s enable hostpath-storage
sudo microk8s enable multus
sudo microk8s enable metallb:10.0.0.2/32
```

Install Juju:

```shell
sudo snap install juju --channel=3.4/stable
```

Bootstrap a Juju controller:

```shell
juju bootstrap microk8s
```

### Deploying sdcore-user-plane-k8s with Terraform

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

The `sdcore-user-plane-k8s` Terraform module offers an option to automatically deploy COS. To use it,
add following variable to your `terraform.tfvars`:

```text
deploy_cos = true
```

Please inspect the `variables.tf` file to see all available config options.

### Checking the result

Run `juju switch <juju model>` to switch to the target Juju model and observe the status of the applications.

```console
juju status --relations
```

This will show an output similar to the following:

```console
Model  Controller          Cloud/Region        Version  SLA          Timestamp
<model_name>   microk8s-localhost  microk8s/localhost  3.4.0    unsupported  17:04:33+03:00

App            Version  Status   Scale  Charm              Channel        Rev  Address         Exposed  Message
grafana-agent  0.32.1   waiting      1  grafana-agent-k8s  latest/stable   51  10.152.183.231  no       installing agent
upf                     active       1  sdcore-upf-k8s     1.5/edge        31  10.152.183.100  no       

Unit              Workload  Agent  Address      Ports  Message
grafana-agent/0*  blocked   idle   10.1.146.98         send-remote-write: off, grafana-cloud-config: off
upf/0*            active    idle   10.1.146.87         

Integration provider  Requirer                        Interface              Type     Message
upf:metrics-endpoint  grafana-agent:metrics-endpoint  prometheus_scrape      regular  
grafana-agent:peers   grafana-agent:peers             grafana_agent_replica  peer   
```

### Cleaning up

Destroy the deployment:

```console
terraform destroy -auto-approve
```

## Using sdcore-user-plane-k8s module in higher level modules

If you want to use `sdcore-user-plane-k8s` module as part of your Terraform module, import it like shown below:

```text
module "sdcore-user-plane" {
  source = "git::https://github.com/canonical/https://github.com/canonical/terraform-juju-sdcore-k8s//modules/sdcore-user-plane-k8s"
  
  model_name = "juju_model_name"
  (Customize configuration variables here if needed)
}
```

[Terraform]: https://www.terraform.io/
[Terraform Juju provider]: https://registry.terraform.io/providers/juju/juju/latest
[Juju]: https://juju.is
[sdcore-user-plane-k8s]: https://charmhub.io/sdcore-user-plane-k8s
