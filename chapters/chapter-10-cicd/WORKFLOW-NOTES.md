# GitHub Actions — Setup and Verification

`terraform.example.yml` is an optional workflow template. Configure the Region, IAM trust, role, permissions and approvals before enabling it.

## Tested Workflows

The repository contains four GitHub Actions workflows:

- `terraform-validate.yml` — formatting and validation without AWS.
- `aws-oidc-test.yml` — manually verify AWS OIDC authentication.
- `terraform-plan.yml` — manually inspect live AWS Terraform changes.
- `terraform-approval-test.yml` — verify the manual approval gate
  without changing AWS resources.

No workflow automatically applies Terraform infrastructure.

## AWS Repository Variables

Before running AWS workflows, open:

GitHub repository → Settings → Secrets and variables
→ Actions → Variables

Create these repository variables:

- `AWS_OIDC_ROLE_ARN` — the authorised AWS IAM role ARN.
- `TF_STATE_BUCKET` — the S3 bucket holding Terraform state.

These are configuration values, not AWS access keys.

The tested workflows use `eu-west-2`. Adjust the Region,
backend key and bucket for your own environment.

Configure GitHub OIDC in AWS with a trust policy restricted
to the intended repository and branch. Grant the planning
role only the required AWS read permissions and S3 state
and lockfile permissions.

## Manual Deployment Approval

1. Open GitHub repository → Settings → Environments.
2. Create an environment named `terraform-apply`.
3. Enable Required reviewers.
4. Select an authorised reviewer.
5. Restrict deployment branches to `main`.
6. Save the protection rules.
7. Run `terraform-approval-test.yml` manually.
8. Open the pending run under GitHub Actions.
9. Select Review deployments.
10. Select `terraform-apply` and choose Approve and deploy.
11. Confirm the job completes successfully.

For a solo educational test, self-review may be permitted.
For production, enable Prevent self-review and use an
independent authorised reviewer.

The approval test does not grant AWS write permissions.
A real apply workflow also requires a separately authorised
IAM role, a reviewed plan and appropriate deployment controls.

## Safety

Never commit Terraform state, credentials or plan files.

Do not run the AWS plan workflow after destroying the lab
unless you intend to inspect a plan to recreate infrastructure.

Do not enable an automatic Terraform apply workflow merely
by publishing this repository.
