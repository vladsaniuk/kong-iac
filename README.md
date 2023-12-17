# AWS EKS IaC

This repo contain IaC to spin up EKS cluster.
It's logically structured into following modules:
1) network
2) EKS
3) EKS add-ons
4) Node group (EC2)
5) Fargate profile (serverless)
6) Karpenter (auto-scaling for Node group)

It is assumed, that vars cluster_name, region and env will be passed from the pipeline.

Init with backend config file:
`terraform init -backend-config=backend-dev.hcl`

To execute complete tf code use this snippet, but note that Karpenter module is dependent on EKS module (it use data resource to query cluster details), so it will eventually throw you and error, but it can be used for testing / troubleshooting your syntax:

`terraform plan -var-file dev.tfvars`

To execute specific module use:

`terraform plan -var-file dev.tfvars -target="module.network" -out=dev_network.tfplan`

To apply it:

`terraform apply "dev_network.tfplan"`

Get kubeconfig:
`aws eks update-kubeconfig --region us-east-1 --name dev_eks-cluster`

To destroy infra, make plan:
`terraform plan -destroy -var-file dev.tfvars -target="module.network" -out=dev_network-destroy.tfplan`

And apply:
`terraform apply "dev_network-destroy.tfplan"`

Nginx is a deployment to test Karpenter auto-scaling.

Modules creation sequence:
* backend
* network
* eks
* node_group
* add_ons
* fargate_profile
* karpenter
* karpenter_config
* secrets (will only create objects in SSM Parameters Store with dummy values)

Karpenter module deploys all required roles to aws-auth.
