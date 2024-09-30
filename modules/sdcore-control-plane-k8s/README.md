# SD-Core Control Plane Terraform Module

This folder contains the [Terraform][Terraform] module to deploy the [sdcore-control-plane-k8s][sdcore-control-plane-k8s] bundle.

The module uses the [Terraform Juju provider][Terraform Juju provider] to model the charm deployment onto any Kubernetes environment managed by [Juju][Juju].

The module can be used to deploy the `sdcore-control-plane-k8s` separately as well as a part of the higher level modules depending on the deployment architecture.

## Module structure

- **main.tf** - Defines the Juju application to be deployed.
- **variables.tf** - Allows customization of the deployment including Juju model name, charm's channel and configuration.
- **output.tf** - Responsible for integrating the module with other Terraform modules, primarily by defining potential integration endpoints (charm integrations).
- **terraform.tf** - Defines the Terraform provider.

## Deploying sdcore-control-plane-k8s module separately

### Pre-requisites

The following tools need to be installed and should be running in the environment.

- A Kubernetes cluster with the `Multus` and `Metallb` addon enabled
- The Load balancer (MetalLB) has address range with at least 2 available IP addresses
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
sudo microk8s enable metallb:10.0.0.2-10.0.0.3
```

Install Juju:

```shell
sudo snap install juju --channel=3.4/stable
```

Bootstrap a Juju controller:

```shell
juju bootstrap microk8s
```

### Deploying sdcore-control-plane-k8s with Terraform

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

The `sdcore-control-plane-k8s` Terraform module offers an option to automatically deploy COS. To use it,
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
Model     Controller          Cloud/Region        Version  SLA          Timestamp
<model_name>  microk8s-localhost  microk8s/localhost  3.4.0    unsupported  17:03:06+03:00

App                       Version  Status   Scale  Charm                     Channel        Rev  Address         Exposed  Message
amf                                active       1  sdcore-amf-k8s            1.5/edge        29  10.152.183.161  no       
ausf                               active       1  sdcore-ausf-k8s           1.5/edge        24  10.152.183.55   no       
grafana-agent             0.32.1   waiting      1  grafana-agent-k8s         latest/stable   51  10.152.183.124  no       installing agent
mongodb                            active       1  mongodb-k8s               6/beta          38  10.152.183.204  no       Primary
nms                                active       1  sdcore-nms-k8s            1.5/edge        23  10.152.183.238  no       
nrf                                active       1  sdcore-nrf-k8s            1.5/edge        30  10.152.183.78   no       
nssf                               active       1  sdcore-nssf-k8s           1.5/edge        24  10.152.183.215  no       
pcf                                active       1  sdcore-pcf-k8s            1.5/edge        26  10.152.183.225  no       
self-signed-certificates           active       1  self-signed-certificates  latest/stable   72  10.152.183.146  no       
smf                                active       1  sdcore-smf-k8s            1.5/edge        25  10.152.183.29   no       
traefik                   2.10.4   active       1  traefik-k8s               latest/stable  166  10.0.0.10       no       
udm                                active       1  sdcore-udm-k8s            1.5/edge        23  10.152.183.251  no       
udr                                active       1  sdcore-udr-k8s            1.5/edge        23  10.152.183.26   no          

Unit                         Workload  Agent  Address       Ports  Message
amf/0*                       active    idle   10.1.146.71          
ausf/0*                      active    idle   10.1.146.84          
grafana-agent/0*             blocked   idle   10.1.146.73          logging-consumer: off, grafana-cloud-config: off
mongodb/0*                   active    idle   10.1.146.114         Primary
nms/0*                       active    idle   10.1.146.89          
nrf/0*                       active    idle   10.1.146.125         
nssf/0*                      active    idle   10.1.146.113         
pcf/0*                       active    idle   10.1.146.126         
self-signed-certificates/0*  active    idle   10.1.146.106         
smf/0*                       active    idle   10.1.146.76          
traefik/0*                   active    idle   10.1.146.109         
udm/0*                       active    idle   10.1.146.79          
udr/0*                       active    idle   10.1.146.124           

Integration provider                   Requirer                        Interface              Type     Message
amf:metrics-endpoint                   grafana-agent:metrics-endpoint  prometheus_scrape      regular  
ausf:metrics-endpoint                  grafana-agent:metrics-endpoint  prometheus_scrape      regular  
grafana-agent:logging-provider         mongodb:logging                 loki_push_api          regular  
grafana-agent:peers                    grafana-agent:peers             grafana_agent_replica  peer     
mongodb:database                       nms:auth_database               mongodb_client         regular  
mongodb:database                       nms:common_database             mongodb_client         regular 
mongodb:database                       nrf:database                    mongodb_client         regular  
mongodb:database                       udr:database                    mongodb_client         regular    
mongodb:database-peers                 mongodb:database-peers          mongodb-peers          peer     
mongodb:metrics-endpoint               grafana-agent:metrics-endpoint  prometheus_scrape      regular  
nrf:fiveg_nrf                          amf:fiveg_nrf                   fiveg_nrf              regular  
nrf:fiveg_nrf                          ausf:fiveg_nrf                  fiveg_nrf              regular  
nrf:fiveg_nrf                          nssf:fiveg_nrf                  fiveg_nrf              regular  
nrf:fiveg_nrf                          pcf:fiveg_nrf                   fiveg_nrf              regular  
nrf:fiveg_nrf                          smf:fiveg_nrf                   fiveg_nrf              regular  
nrf:fiveg_nrf                          udm:fiveg_nrf                   fiveg_nrf              regular  
nrf:fiveg_nrf                          udr:fiveg_nrf                   fiveg_nrf              regular  
nrf:metrics-endpoint                   grafana-agent:metrics-endpoint  prometheus_scrape      regular  
nssf:metrics-endpoint                  grafana-agent:metrics-endpoint  prometheus_scrape      regular  
pcf:metrics-endpoint                   grafana-agent:metrics-endpoint  prometheus_scrape      regular  
self-signed-certificates:certificates  amf:certificates                tls-certificates       regular  
self-signed-certificates:certificates  ausf:certificates               tls-certificates       regular  
self-signed-certificates:certificates  nrf:certificates                tls-certificates       regular  
self-signed-certificates:certificates  nssf:certificates               tls-certificates       regular  
self-signed-certificates:certificates  pcf:certificates                tls-certificates       regular  
self-signed-certificates:certificates  smf:certificates                tls-certificates       regular  
self-signed-certificates:certificates  udm:certificates                tls-certificates       regular  
self-signed-certificates:certificates  udr:certificates                tls-certificates       regular  
smf:metrics-endpoint                   grafana-agent:metrics-endpoint  prometheus_scrape      regular  
traefik:ingress                        nms:ingress                     ingress                regular  
traefik:peers                          traefik:peers                   traefik_peers          peer     
udm:metrics-endpoint                   grafana-agent:metrics-endpoint  prometheus_scrape      regular  
udr:metrics-endpoint                   grafana-agent:metrics-endpoint  prometheus_scrape      regular  
```

### Cleaning up

Destroy the deployment:

```console
terraform destroy -auto-approve
```

## Using sdcore-control-plane-k8s module in higher level modules

If you want to use `sdcore-control-plane-k8s` module as part of your Terraform module, import it like shown below:

```text
module "sdcore-control-plane" {
  source = "git::https://github.com/canonical/https://github.com/canonical/terraform-juju-sdcore-k8s//modules/sdcore-control-plane-k8s"
  
  model_name = "juju_model_name"
  (Customize configuration variables here if needed)
}
```

[Terraform]: https://www.terraform.io/
[Terraform Juju provider]: https://registry.terraform.io/providers/juju/juju/latest
[Juju]: https://juju.is
[sdcore-control-plane-k8s]: https://charmhub.io/sdcore-control-plane-k8s
