## HashiCorp Nomad on the AWS Cloud
> Nomad version 0.5.5
> Consul version 0.8.0

### Deployment options:
* Deployment of HashiCorp Consul into a new VPC (end-to-end deployment) builds a new VPC with public and private subnets, and then deploys HashiCorp Vault into that infrastructure.
* Deployment of HashiCorp Vault into an existing VPC provisions HashiCorp Vault into your existing infrastructure. 

### Architecture:
![quickstart-hashicorp-consul](/images/nomad.png)

### Submodules:
* Linux Bastion https://github.com/aws-quickstart/quickstart-linux-bastion
* Consul https://github.com/aws-quickstart/quickstart-hashicorp-consul
* Quick Start VPC https://github.com/aws-quickstart/quickstart-aws-vpc
