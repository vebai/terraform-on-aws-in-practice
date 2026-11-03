# Terraform on AWS in Practice

This is the companion repository for *Terraform on AWS in Practice: Build, Change, and Troubleshoot AWS Infrastructure Safely* by **Victor Ebai**. It provides the Terraform configurations and supporting files used by the book’s hands-on exercises.

**The book is fully self-contained.** You do not need this repository to understand or complete its learning path. The repository provides convenient, testable copies of the configurations and practical lab guides for readers who prefer to clone and run them.

Build an AWS network, run an EC2 web server, manage Terraform state, **validate changes with GitHub Actions**, and practise recovering from infrastructure changes.

The practical workflow is **Build → Inspect → Change → Diagnose → Recover → Verify**. Use the book for the explanations and engineering judgement; use this repository to find the relevant files, run exercises safely and verify results.

## What you will build and practise

By working through the labs, you will learn to:

- Create and manage AWS resources using Terraform's `init`, `plan`, `apply` and `destroy` workflow.
- Build a VPC with public and private subnets, routing and an internet gateway.
- Deploy an EC2 instance running Nginx and access it with AWS Systems Manager Session Manager.
- Configure remote state in Amazon S3 and understand state locking.
- Use variables, outputs, data sources, workspaces and reusable modules.
- Validate Terraform and review changes through GitHub Actions and AWS OIDC authentication.
- Detect configuration drift, import existing resources, diagnose failures and verify recovery.

## Before you begin

You need:

- **Terraform 1.10 or later, below 2.0** (the configuration uses the AWS provider 6.x).
- **AWS CLI v2**, **Git**, and an AWS account with permissions for the exercises you choose.
- For local authentication, prefer an AWS CLI profile or IAM Identity Center session rather than long-lived static access keys. Never store AWS credentials in this repository.
- A terminal on macOS or Linux, or an appropriately configured AWS CloudShell session.
- The AWS Session Manager plugin if you intend to open EC2 sessions using the CLI.

The labs use **AWS London (`eu-west-2`)**. If you use another Region, adjust the configuration and check instance availability, quotas and Region-specific steps.

**Cost and security:** AWS resources can incur charges. Use a dedicated learning account or carefully scoped environment, and clean up after each exercise. The short-lived HTTP example allows inbound port 80 from the internet; it is not a production security baseline.

## Getting started

**1. Clone the repository and check your tools.** Run these commands in your local terminal:

```bash
git clone https://github.com/vebai/terraform-on-aws-in-practice.git
cd terraform-on-aws-in-practice
terraform version
aws --version
aws sts get-caller-identity
```

Confirm that `aws sts get-caller-identity` shows the AWS account you intend to use **before creating resources**.

**2. Choose your first exercise.** If you are new to Terraform, begin with the [Chapter 1 S3 lab](chapters/chapter-01-understand-terraform/README.md). It is a small, separate exercise that can be created and destroyed independently.

**3. Follow the chapter instructions.** Read the matching chapter in the book, then open that chapter's README below. Follow its prerequisites, run the commands from the stated directory, inspect the results and complete the cleanup instructions. You can also use the chapter READMEs as practical references when working independently.

**4. Verify before making changes.** Each lab uses `terraform validate` and `terraform plan` to check what Terraform intends to do. Review the proposed resource changes before you run `apply` or `destroy`.

## Choose your starting point

| Chapter | Lab or skill | Instructions |
|---|---|---|
| 1 | Create your first Terraform-managed S3 bucket | [Start Chapter 1](chapters/chapter-01-understand-terraform/README.md) |
| 2 | Review plans and understand changes | [Start Chapter 2](chapters/chapter-02-plan-and-apply/README.md) |
| 3 | Work with variables, outputs and reusable configuration | [Start Chapter 3](chapters/chapter-03-reusable-terraform/README.md) |
| 4 | Build the AWS VPC and network | [Start Chapter 4](chapters/chapter-04-aws-network/README.md) |
| 5 | Deploy EC2 and verify HTTP and Session Manager access | [Start Chapter 5](chapters/chapter-05-secure-ec2/README.md) |
| 6 | Configure S3 remote state and locking | [Start Chapter 6](chapters/chapter-06-remote-state/README.md) |
| 7 | Inspect AWS using Terraform data sources | [Start Chapter 7](chapters/chapter-07-data-sources/README.md) |
| 8 | Explore Terraform workspaces and state isolation | [Start Chapter 8](chapters/chapter-08-workspaces/README.md) |
| 9 | Refactor the network into a reusable module | [Start Chapter 9](chapters/chapter-09-modules/README.md) |
| 10 | Validate, plan and test approval in GitHub Actions | [Start Chapter 10](chapters/chapter-10-cicd/README.md) |
| 11 | Investigate drift and import existing AWS resources | [Start Chapter 11](chapters/chapter-11-troubleshooting/README.md) |
| 12 | Break, diagnose, repair and verify an AWS environment | [Start Chapter 12](chapters/chapter-12-capstone/README.md) |

## How the repository is organised

| Location | What you will find |
|---|---|
| [`chapters/`](chapters/) | Chapter-specific guides, examples and lab instructions |
| [`chapters/chapter-01-understand-terraform/first-s3-bucket/`](chapters/chapter-01-understand-terraform/first-s3-bucket/) | Independent starter Terraform project |
| [`terraform-vpc/`](terraform-vpc/) | The **shared Terraform root** for the continuing VPC/EC2 lab |
| [`.github/workflows/`](.github/workflows/) | Terraform validation, AWS OIDC test, plan and approval-test workflows |

## Two ways to work

**Standalone starter lab (Chapter 1).** Run the first S3 bucket example from its own directory, then destroy its resources. Its state is separate from the VPC/EC2 lab.

**Continuing AWS lab (Chapters 4–12).** Work from `terraform-vpc/` and **use the same Terraform state throughout**. Keep the same workspace and backend as you progress. The checked-in configuration represents the cumulative lab, including subsequent refinements; earlier chapters explain the individual components. **Do not copy an earlier chapter snapshot over a deployed environment or create a second state file for the same resources.**

## Safe validation before deploying

For a **fresh checkout** where you only want to validate the configuration, run these commands from the repository root:

```bash
terraform -chdir=terraform-vpc init -backend=false
terraform -chdir=terraform-vpc fmt -check -recursive
terraform -chdir=terraform-vpc validate
```

These commands prepare and check the configuration; they do not create AWS resources. If you already use a remote backend for a live lab, **do not reinitialise it with a different backend merely to validate**. Keep your existing backend and workspace.

When you are ready to work with live infrastructure, initialise the intended backend, check your AWS account and workspace, and review `terraform plan` before proceeding. See [Chapter 6](chapters/chapter-06-remote-state/README.md) for state migration and locking. **If you are starting without existing state, the plan may propose creating the entire cumulative lab. That is expected; it is not permission to apply changes automatically.**

## GitHub Actions

The repository includes workflows for Terraform validation, AWS identity verification with OIDC, a manually triggered Terraform plan and a manual deployment-approval test. **There is no automatic Terraform apply workflow.** AWS workflows require your own IAM role and state bucket configuration; they should not be run against an unknown account or backend.

See the [Chapter 10 CI/CD guide](chapters/chapter-10-cicd/README.md) for setup, permissions, manual approval steps and safety checks.

## Where to look when something fails

Read the error text, then check the working directory, AWS identity and Region, Terraform workspace and state backend, tool versions, AWS permissions and service quotas. Apply the smallest justified correction and verify again. **Never delete a state file or use `force-unlock` as a general troubleshooting shortcut.**

## Cleaning up

For the continuing lab, use the **same Terraform root, workspace and backend that created the resources**. Review the proposed deletions before confirming them:

```bash
terraform -chdir=terraform-vpc workspace show
terraform -chdir=terraform-vpc plan -destroy
# Only after reviewing every proposed deletion:
terraform -chdir=terraform-vpc destroy
terraform -chdir=terraform-vpc state list
```

A separately created S3 state bucket, retained object versions and GitHub OIDC IAM test resources may require additional cleanup. **Do not delete the state backend before removing the infrastructure it manages.** Follow the relevant chapter README for any exercise-specific checks.

---

**Start here:** [Chapter 1 — Your first Terraform-managed AWS resource](chapters/chapter-01-understand-terraform/README.md)
