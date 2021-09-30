## 1. Preparing the app
- Create Dockerfile
- Tested with docker build . && docker run -it <image_id>
- .dockerignore file
- .gitignore file

[at this point, I would also create a dedicated tooling image for troubleshooting and CI/CD]

## 2. Adding some tooling for CI/CD
```
pipenv install
pipenv install invoke
```
Created files for build/run/tests (tasks folder)

[Tests task are no-op, just showing where I'd place entrypoints]

## 3. Install git pre-hooks
```
pipenv install pre-commit
Added pre-commit config file
pre-commit install (Python opinionated version for sake of time)
```

## 4. Created AWS account
- Logged into root AWS account
- Used AWS Organizations to spin a new account

```
Name Rearc Sandbox
ID 749738151927
ARN arn:aws:organizations::xxxxxxxxxx:account/o-uq5p18h7p2/749738151927
Email laouichi.mehdi+rearc@gmail.com
Status Created on 2021/09/29
```

- Assigned own user to account through AWS SSO
- Logged out of root account
- Logged into new sub-account
- Validate account is working

## 5. Setup AWS environment to work with new account
`~/.aws/config`

```
[profile Rearc-AdministratorAccess]
sso_start_url = https://cloudegis.awsapps.com/start/
sso_region = us-west-2
sso_account_id = 749738151927
sso_role_name = AdministratorAccess
region = us-west-2
output = json
```

Switched shell to new config
```
asp Rearc-AdministratorAccess
aws sso login
<Perform AWS SSO dance>
aws sts get-caller-identity
{
    "UserId": "AROA25D7AJ73QIB7HQ3EH:mehdi@cloudegis.com",
    "Account": "749738151927",
    "Arn": "arn:aws:sts::749738151927:assumed-role/AWSReservedSSO_AdministratorAccess_d50954b9215d2f0d/mehdi@cloudegis.com"
}
```

## 6. Build infrastructure
Given the requirements, the MVP requires:
- Basic AWS setup
  - CIS
  - VPC/subnets/rtb/igw
- Container image registry
  - ECR
  - Gitlab Registry
  - Github Packages
- Container runtime
  - Simple EC2 with docker
  - ECS [Fargate or EC2 backed]
  - EKS
- Load balancer
  - ELB
  - ALB (primary or handing over to IngressController on EKS)
- TLS
  - ACM with self signed certificate
  - cert-manager w/ CA provider such as LE

Chosen:
- VPC
  - And associated constructs
  - 3 public/3 private subnets
- ECS cluster
- ECS worker nodes w/ ASG using ECS optimized images
  - 5 counts over 3 AZs, in private subnets
  - Accepting traffic from ALB
- ALB living in public subnet
  - Opened to 443 publicly
  - Target group pointing to ECS tasks
- ACM certificate
  - Self signed, associated with ALB
- ECR repository

## 7. Retrieving the secret word ahead of time
`strace` tells me bin/001 is requesting `169.254.169.254` (metadata)
-- looks like it's not even reading the metadata? simple HTTP server would work

```
sudo ip addr add 169.254.169.254/16 dev lo
docker run -it --rm -p 80:1338 amazon/amazon-ec2-metadata-mock:v1.9.2
```
http://localhost:3000/

Congratulations. Secret page you did find! TwelveFactor the secret word is.

## 8. Provisioning bare minimum
- S3 bucket
- [skipping DynamoDB table for locking]
- [skipping CIS controls]

Creating a simple hierarchy
- ./infrastructure/$ENV/$REGION
- ./infrastructure/modules

For sake of time, created S3 bucket in `us-east-2` through Console

Create infra with VPC [and associated constructs], and ECR.
- VPC will be upstream module for sake of time
- ECR is a custom module with bare minimum input/output
```
tf init
tf plan
tf apply
Apply complete! Resources: 29 added, 0 changed, 0 destroyed.
```
749738151927.dkr.ecr.us-east-2.amazonaws.com/rearc-prd

## 9. Change tooling to build image with right name and push it
[This would normally be done by the CI/CD pipeline]
```
inv build
inv build.push

607d71c12b77: Pushed
master: digest: sha256:8540af50ca871826da6b7e70752574c63006056432ade1637cc48907328ef849 size: 2845
```

## 10. Build the rest of the infra
- ECS [customized upstream module]
- ALB [custom]
- ACM [custom]
- ASG [upstream, part of ECS module]

```
tf init
tf plan
tf apply

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```
https://rearc-prd-258628633.us-east-2.elb.amazonaws.com (only responds over HTTPS)

## Missing
- Better SG between LB and targets
- Proper CI/CD building and invoking tools
- Missing NACLs
- AWS IAM roles for ECS tasks
- Cloudwatch and associated metrics collection
- Autoscaling criterias on ASG and ECS task
- CIS hardened AMIs / Containers
- Cloudfront distribution
- Basic AWS hardening
  - IAM enforcement, creds rotation, password policy
  - Cloudtrail
- KMS
- Tagging docker images with hash
- TF cleanup
  - Variables with description
  - Proper outputs
  - Refactor with Terragrunt/CDK to keep DRY
  - Better tags
- Arch and SLA diagrams
- Secret should be living in SSM or Vault
