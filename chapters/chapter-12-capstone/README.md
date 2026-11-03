# Chapter 12 — Build, Change, Break, and Recover an AWS Environment

This capstone continues the Terraform infrastructure built in
Chapters 4–11. It does not deploy a separate environment.

The complete manuscript examples are preserved in
[BOOK-CODE.md](BOOK-CODE.md).

## Where to Run

Run Terraform and AWS CLI commands from your local MacBook
terminal or an appropriately configured AWS CloudShell session.

The Terraform root directory is `terraform-vpc/`.

Use your own AWS account, Region, IAM permissions and backend.

## 1. Verify the Starting State

Check your AWS identity and Terraform workspace:

    aws sts get-caller-identity
    terraform -chdir=terraform-vpc workspace show
    terraform -chdir=terraform-vpc validate
    terraform -chdir=terraform-vpc plan

Review the plan before applying any changes.

Readers continuing the cumulative lab should use the existing
network, EC2 configuration and Terraform state.

## 2. Make a Controlled Change

Add the `Updated` tag to `aws_instance.main` as described
in the manuscript.

Run Terraform validate, plan and apply.

Verify the tag in AWS and confirm the final plan is clean.

## 3. Break and Recover HTTP Access

Temporarily remove the
`aws_vpc_security_group_ingress_rule.http` resource block.

Review the Terraform plan. It should destroy only the
HTTP ingress rule.

After applying the reviewed change:

- Verify that HTTP access fails.
- Verify that AWS Systems Manager Session Manager still works.
- Restore the original HTTP ingress resource.
- Review and apply the recovery plan.
- Verify HTTP 200 OK and a clean Terraform plan.

Keep a backup of the original configuration.
Do not commit the temporary failure configuration.

## 4. Detect and Recover from Drift

Change the EC2 `Updated` tag manually using the AWS CLI.

Run Terraform plan to observe the difference between
AWS and the declared configuration.

Choose the appropriate recovery path:

- Restore AWS to the Terraform configuration.
- Or update the configuration if the AWS change is intended.

Verify the final AWS values and Terraform plan.

## 5. Import Existing Infrastructure

Follow the Chapter 11 S3 import exercise using a separate
test bucket, never the Terraform state backend bucket.

Verify the imported resource in Terraform state and AWS.

## 6. Clean Up

When finished, back up the state securely and review:

    terraform -chdir=terraform-vpc plan -destroy

Only after checking every proposed deletion, run:

    terraform -chdir=terraform-vpc destroy

Then verify:

    terraform -chdir=terraform-vpc state list

The Terraform-managed lab resources should be removed.

The separately created S3 backend, its state objects and
any GitHub OIDC IAM resources require separate cleanup.

## Safety

Terraform state and backup files must not be committed to Git.

Do not run Terraform apply after completing cleanup unless
you deliberately intend to recreate the AWS environment.

Do not run the GitHub AWS plan workflow against a destroyed
environment without understanding its proposed changes.
