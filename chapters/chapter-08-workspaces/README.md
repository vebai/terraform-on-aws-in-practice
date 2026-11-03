# Chapter 8 — See how workspaces isolate state

**Outcome:** Create a second Terraform workspace, observe its empty state and return safely to the existing environment **without deploying duplicate infrastructure**.

## Prerequisites

The VPC/EC2 configuration is already initialised in `terraform-vpc/`. Confirm the intended AWS account and the workspace that owns your existing resources:

```bash
aws sts get-caller-identity
terraform -chdir=terraform-vpc workspace list
terraform -chdir=terraform-vpc workspace show
terraform -chdir=terraform-vpc state list
```

An ordinary workspace is a **separate Terraform state**, not a separate AWS account or a security boundary.

## Explore a new workspace

If `dev` does not already exist:

```bash
terraform -chdir=terraform-vpc workspace new dev
terraform -chdir=terraform-vpc workspace show
terraform -chdir=terraform-vpc state list
terraform -chdir=terraform-vpc plan
```

If `dev` already exists, **inspect its state before selecting or changing it**. In a genuinely new workspace, `state list` should be empty and the plan will propose creating resources from the configuration. **Do not apply this exploratory plan.**

Return to the original workspace:

```bash
terraform -chdir=terraform-vpc workspace select default
terraform -chdir=terraform-vpc workspace show
terraform -chdir=terraform-vpc state list
```

The original managed resources should reappear in state. If the new `dev` workspace is unused and empty, you may remove it from `default` with `terraform -chdir=terraform-vpc workspace delete dev` after checking that it contains no resources.

## What to verify

Observe how the same `.tf` files produce different proposed actions because the selected state changed. Record the account, Region, workspace and backend together whenever troubleshooting a missing resource. Never apply to an unexpected or empty workspace just to “fix” an empty state.
