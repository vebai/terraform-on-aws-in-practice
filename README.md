# Terraform on AWS in Practice

Build an AWS network, run an EC2 web server, manage Terraform state, test GitHub Actions and practise recovering from infrastructure changes.

These labs follow a single engineering cycle: **build → inspect → change → diagnose → recover → verify**. You can start with the small S3 exercise or work through the continuing VPC/EC2 environment. Each chapter explains the starting state it expects.

## What you will build

- An independent S3 bucket exercise to learn Terraform's basic commands.
- A VPC with public and private subnets, routes and an internet gateway.
- An Amazon Linux EC2 instance running Nginx, with Session Manager access.
- An optional versioned S3 state backend with native Terraform state locking.
- A reusable network module, GitHub Actions validation and deployment approval checks.
- Controlled drift, import, failure and recovery exercises.

**Costs and safety:** EC2, storage, data transfer and other AWS services can incur charges. Use a lab account or a carefully scoped AWS environment. Review every `plan` before `apply` or `destroy`. The HTTP demonstration opens port 80 to the internet; it is for a short-lived learning environment, not a production security baseline.

## Prerequisites

You need Terraform **1.10 or later (below 2.0)**, AWS CLI v2, Git, an AWS account and permissions appropriate to the resources being created. An AWS CLI profile or IAM Identity Center session is preferable to static access keys. Chapter 5 also uses the AWS Session Manager plugin if you open a session from your terminal.

The examples use the **London Region (`eu-west-2`)** and the AWS provider **6.x**. Other Regions are possible, but check instance availability, quotas and region-specific commands before proceeding.

From your terminal:

```bash
git clone https://github.com/vebai/terraform-on-aws-in-practice.git
cd terraform-on-aws-in-practice
terraform version
aws --version
aws sts get-caller-identity
```

Check that the AWS account shown is the one you intend to use. Do not proceed with a privileged or production account accidentally.

## Choose your starting point

| Goal | Start here | What to expect |
|---|---|---|
| Learn `init`, `plan`, `apply`, `destroy` | [Chapter 1: first S3 bucket](chapters/chapter-01-understand-terraform/README.md) | Independent, disposable exercise |
| Understand saved plans | [Chapter 2](chapters/chapter-02-plan-and-apply/README.md) | Uses an existing lab configuration |
| Practise variables and outputs | [Chapter 3](chapters/chapter-03-reusable-terraform/README.md) | Inspect and customise configuration |
| Build the cumulative AWS environment | [Chapter 4](chapters/chapter-04-aws-network/README.md) | Uses `terraform-vpc/` |
| Verify EC2 and Session Manager | [Chapter 5](chapters/chapter-05-secure-ec2/README.md) | Extends the same environment |
| Store state remotely | [Chapter 6](chapters/chapter-06-remote-state/README.md) | Separate S3 backend setup |
| Inspect AWS account and other data | [Chapter 7](chapters/chapter-07-data-sources/README.md) | Read-only data sources |
| Experiment with state isolation | [Chapter 8](chapters/chapter-08-workspaces/README.md) | Do not apply an empty workspace blindly |
| Understand module migration | [Chapter 9](chapters/chapter-09-modules/README.md) | Keep the existing state |
| Validate and review CI/CD | [Chapter 10](chapters/chapter-10-cicd/README.md) | No automatic infrastructure apply |
| Diagnose drift and import resources | [Chapter 11](chapters/chapter-11-troubleshooting/README.md) | Live resource and state checks |
| Complete a controlled recovery exercise | [Chapter 12](chapters/chapter-12-capstone/README.md) | Change, break, repair, verify |

## Two ways to work

**Small standalone exercise:** The directory `chapters/chapter-01-understand-terraform/first-s3-bucket/` contains a complete S3 Terraform configuration. Run it independently and destroy the bucket when finished.

**Continuing infrastructure lab:** `terraform-vpc/` is the working Terraform root for the VPC, EC2 and later chapters. **Use the same Terraform state throughout.** The checked-in configuration represents the cumulative lab, including subsequent refinements; earlier chapters explain the individual components. Do not copy an earlier chapter snapshot over a deployed environment or create a second state file for the same resources.

## Safe validation before deploying

Run these commands **from the repository root**:

```bash
terraform -chdir=terraform-vpc fmt -check -recursive
terraform -chdir=terraform-vpc init -backend=false
terraform -chdir=terraform-vpc validate
```

These check formatting and configuration without applying infrastructure. For an actual AWS plan, configure the intended backend/state first, initialise it normally, verify your AWS identity and then run:

```bash
terraform -chdir=terraform-vpc workspace show
terraform -chdir=terraform-vpc plan
```

If you are starting without existing state, the plan may propose creating the entire cumulative lab. That is expected; it is not permission to apply changes automatically.

## Where to look when something fails

Check, in order: the error text; your terminal directory; AWS identity and Region; active Terraform workspace and state backend; tool and provider versions; AWS permissions and quotas; then the smallest justified correction. Re-run `terraform validate` and `terraform plan` after any fix. Never delete a state file or use `force-unlock` as a general troubleshooting shortcut.

## Cleaning up

Destroy resources using **the same Terraform root, workspace and backend that created them**. Review the destroy plan before confirming:

```bash
terraform -chdir=terraform-vpc workspace show
terraform -chdir=terraform-vpc plan -destroy
# Run only after confirming the resources to remove:
terraform -chdir=terraform-vpc destroy
terraform -chdir=terraform-vpc state list
```

The **separately provisioned state bucket**, retained object versions and any **GitHub OIDC IAM test resources** are not necessarily managed by this configuration; check and remove them separately when no longer needed. Never destroy the state backend before the managed infrastructure is safely removed.
