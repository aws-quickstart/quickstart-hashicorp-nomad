## HashiCorp Nomad on the AWS Cloud
### Versions:
* `NOMAD VERSION`='1.1.3'
* `CONSUL CLIENT VERSION`='1.10.1'
* `CONSUL SERVER VERSION`='1.10.1'
* `CONSUL_TEMPLATE_VERSION`='0.26.0'

This Quick Start deploys HashiCorp Nomad automatically into a flexible, scalable, configurable environment in your AWS account in about 35 minutes.

Nomad is a distributed, highly available, data center-aware cluster manager and scheduler that helps deploy applications on any infrastructure, at any scale, on premises or in the cloud. It supports virtualized, containerized, or standalone applications running on all major operating systems, and handles a broad range of workloads.

The Quick Start offers two deployment options:

- Deploying HashiCorp Nomad into a new virtual private cloud (VPC) on AWS. This end-to-end deployment builds a new VPC with public and private subnets, and then deploys HashiCorp Nomad into that infrastructure.
- Deploying HashiCorp Nomad into an existing VPC provisions Nomad in your existing AWS infrastructure.

You can also use the AWS CloudFormation templates as a starting point for your own implementation.

![Quick Start architecture for HashiCorp Nomad on AWS](https://d1.awsstatic.com/partner-network/QuickStart/datasheets/hashicorp-nomad-on-aws-architecture.png)

For architectural details, best practices, step-by-step instructions, and customization options, see the
[deployment guide](https://fwd.aws/JPD5g).

### Submodules (updated):
* Linux Bastion https://github.com/aws-quickstart/quickstart-linux-bastion
* Quick Start VPC https://github.com/aws-quickstart/quickstart-aws-vpc

To post feedback, submit feature ideas, or report bugs, use the **Issues** section of this GitHub repo.
If you'd like to submit code for this Quick Start, please review the [AWS Quick Start Contributor's Kit](https://aws-quickstart.github.io/).

