# Chapter 4 — Deploy and inspect an AWS VPC

**Outcome:** Understand a VPC with a public subnet, private subnet, internet gateway and route tables; verify each resource in AWS.

The working configuration lives in **`terraform-vpc/`** at the repository root. Later chapters extend and refactor this same configuration, so the current files may contain the EC2 instance and the `network` module as well as the VPC.

## Prerequisites

You need Terraform, the AWS CLI, an AWS identity authorised for VPC/EC2 operations and a deliberate choice of Region and Terraform backend. The default Region is `eu-west-2`. Check AWS quotas and your active account before incurring charges.

```bash
aws sts get-caller-identity
terraform -chdir=terraform-vpc workspace show
terraform -chdir=terraform-vpc validate
```

If Terraform has not been initialised, configure your intended backend first and run `terraform -chdir=terraform-vpc init`. For checks that do not access live state, `init -backend=false` is sufficient.

## Inspect the network

Read `terraform-vpc/variables.tf` to locate the planned CIDRs:

- VPC: `10.0.0.0/16`
- Public subnet: `10.0.1.0/24`
- Private subnet: `10.0.2.0/24`

Find the network resource definitions in `terraform-vpc/` and, if present, `terraform-vpc/modules/network/`. Notice that the **public** route table has a `0.0.0.0/0` route to the internet gateway; the **private** route table has no internet-gateway default route.

## Plan and deploy only when intended

```bash
terraform -chdir=terraform-vpc plan
```

Review the *entire* plan. On a new state, the cumulative configuration may propose more than the original eight networking resources. Do not proceed unless you intend to deploy all of them and have the right permissions.

```bash
# Only after inspecting and accepting the full plan:
terraform -chdir=terraform-vpc apply
```

## Verify the result

```bash
terraform -chdir=terraform-vpc output vpc_id
terraform -chdir=terraform-vpc output public_subnet_id
terraform -chdir=terraform-vpc output private_subnet_id
```

If the VPC has been deployed:

```bash
VPC_ID="$(terraform -chdir=terraform-vpc output -raw vpc_id)"
aws ec2 describe-vpcs --vpc-ids "$VPC_ID" --region eu-west-2
```

Expect the CIDR and VPC ID to match Terraform's outputs. Check the two subnets and route tables in **AWS Console → VPC**, with the correct Region selected.

**Keep the lab for Chapter 5.** If ending here, inspect `terraform -chdir=terraform-vpc plan -destroy` before destroying the environment.
