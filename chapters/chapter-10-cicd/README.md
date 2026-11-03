# Chapter 10 — Run Terraform checks through GitHub Actions

**Outcome:** Validate Terraform on each push, authenticate to AWS without saved access keys, inspect an AWS-backed plan on demand and test a human deployment approval gate.

## Workflows in this repository

| Workflow | Trigger | AWS access | What it does |
|---|---|---|---|
| `terraform-validate.yml` | Push / configured validation trigger | None | Checks Terraform formatting and configuration |
| `aws-oidc-test.yml` | Manual | OIDC role | Prints the assumed AWS identity |
| `terraform-plan.yml` | Manual | OIDC planning role + S3 backend | Reads state and proposes changes; **does not apply** |
| `terraform-approval-test.yml` | Manual | None | Waits for the `terraform-apply` environment approval, then runs a harmless confirmation job |

The active workflows live in [`.github/workflows/`](../../.github/workflows/). **There is no automatic Terraform apply workflow.**

## Run validation first

On your MacBook, check the configuration without deploying:

```bash
terraform -chdir=terraform-vpc init -backend=false
terraform -chdir=terraform-vpc fmt -check -recursive
terraform -chdir=terraform-vpc validate
```

In GitHub, open **Actions → Terraform Validation** to inspect the latest run. A successful check indicates valid configuration, not a successful AWS deployment.

## Configure AWS OIDC only if you need AWS workflows

In **GitHub repository → Settings → Secrets and variables → Actions → Variables**, create:

- `AWS_OIDC_ROLE_ARN` — ARN of your *own* AWS IAM role allowed to be assumed by this repository.
- `TF_STATE_BUCKET` — name of your *own* existing S3 backend bucket (needed for the plan workflow).

These identifiers are configuration rather than passwords. The IAM trust policy must restrict the correct GitHub repository and intended branch/environment, with audience `sts.amazonaws.com`. Use a narrowly scoped role. Planning typically needs AWS read permissions plus S3 state-object and `.tflock` permissions; it should not have general infrastructure write permissions.

The example workflows use **`eu-west-2`**. Before running them, verify the backend **bucket, state key, Region, workspace and role** all match your lab. An empty state after cleanup will make `terraform plan` propose rebuilding the environment; this is not a failure and is not a reason to run apply.

With the AWS lab intentionally active, you can use **Actions → AWS OIDC Test → Run workflow** to check identity, then **Actions → Terraform Plan → Run workflow** to inspect changes. Do not trigger them against an unknown account or backend.

## Test a required reviewer without AWS writes

1. Open **Settings → Environments** and create `terraform-apply`.
2. Enable **Required reviewers** and choose a reviewer.
3. Restrict deployment branches to `main` and save the rules.
4. In **Actions**, run `terraform-approval-test.yml` manually on `main`.
5. Open the pending workflow and select **Review deployments**.
6. Select `terraform-apply`, then **Approve and deploy**.
7. Confirm the confirmation job succeeds.

For a solo lab, GitHub may allow self-review if **Prevent self-review** is disabled and your plan/repository settings support required reviewers. For real deployment workflows, use an independent authorised reviewer, protected branches and separate write permissions. The approval-test workflow itself **does not change AWS resources**.

## Trouble checks and cleanup

- **Validation failure:** Inspect the file and line reported by `fmt` or `validate`; fix locally before pushing.
- **OIDC access denied:** Check the role's trust policy, repo and branch restrictions, audience and workflow permissions.
- **Backend failure:** Check the S3 bucket, key, Region, locking permissions and whether the state still exists.
- **Approval not requested:** Check the `terraform-apply` environment name, required-reviewer setting, branch restriction and job environment.

Remove test IAM roles, unused state buckets and GitHub settings when they are no longer needed. Do not delete a shared OIDC provider or active backend without checking other users and repositories.
