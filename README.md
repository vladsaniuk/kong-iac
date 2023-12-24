# Kong CE infrastructure               
This repo contains code to deploy and manage infrastracture for my Kong CE project.           
I plan for multi-environment and multi-region, so I use Makefile as a wrapper to manage different aspects of infrastructure as separate Terraform projects, meaning each folder, i.e. cluster, karpenter etc, is Terraform root, that is called by Makefile with variables and backend config distributed by subfolders that corresponds to environment and region.            

## New environment / region bootstrap
Backend has a special treatment, as it has to be initialized for each new env / region with local tfstate to create required resources to used by all other backends going forward, this is one-off effort:
```
cp versions.tf backend/
terraform init -backend-config=envs/${ENV}/${ENV}.s3.tfbackend -backend-config=envs/${ENV}/regions/${REGION}/child.s3.tfbackend
terraform plan -var-file envs/${ENV}/${ENV}.tfvars -var-file envs/${ENV}/regions/${REGION}/child.tfvars -out=backend.tfplan
terraform apply "backend.tfplan"
```
At this point you will have tfstate locally and resources created in AWS, now we need to migrate state from local machine to S3:
`ENV=dev ELEMENT=backend REGION=us-east-1 make init`

## Deployment order 
1) cluster
2) karpenter
3) lb_controller
4) kong

## Makefile
Init: `ENV=dev ELEMENT=cluster REGION=us-east-1 make init`
Plan: `ENV=dev ELEMENT=cluster REGION=us-east-1 make plan`
Apply: `ENV=dev ELEMENT=cluster REGION=us-east-1 make apply`
Destroy-plan: `ENV=dev ELEMENT=cluster REGION=us-east-1 make destroy-plan`
Destroy: `ENV=dev ELEMENT=cluster REGION=us-east-1 make destroy`
Import: `ENV=dev ELEMENT=cluster REGION=us-east-1 make import aws_instance.example i-12345678`
