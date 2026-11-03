# Chapter 10 — Run Terraform Safely in CI/CD — complete original code and command listings

These listings are transcribed from the uploaded manuscript, in source order. The original `us-east-1` text and illustrative placeholders are intentionally retained here. They are **reference examples**, not a file to execute as a whole.

The numbered entries include complete configurations, partial snippets, shell commands, sample output and deliberately broken examples. Only the designated `.tf` files in the working lab are intended to be executed.

### 001 — command (source paragraphs 2332–2332)

```bash
$ terraform fmt -check -recursive
```

### 002 — command (source paragraphs 2342–2343)

```bash
$ terraform init -backend=false -lockfile=readonly
$ terraform validate
```

### 003 — sample output (source paragraphs 2348–2348)

```text
Success! The configuration is valid.
```

### 004 — command (source paragraphs 2355–2355)

```bash
$ terraform plan
```

### 005 — command (source paragraphs 2357–2357)

```bash
$ terraform plan -out=reviewed.tfplan
```

### 006 — command (source paragraphs 2361–2361)

```bash
$ terraform plan -detailed-exitcode -out=reviewed.tfplan
```

### 007 — command (source paragraphs 2372–2372)

```bash
$ terraform plan -no-color
```

### 008 — command (source paragraphs 2389–2389)

```bash
$ terraform apply reviewed.tfplan
```

### 009 — terraform (source paragraphs 2411–2431)

```hcl
data "aws_iam_policy_document" "github_oidc_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
# Illustrative only — match the exact sub format used by your repository.
      values   = ["repo:your-org/your-repo:*"]
    }
  }
}
```

### 010 — command (source paragraphs 2440–2440)

```bash
$ terraform plan -lock-timeout=5m -out=reviewed.tfplan
```

### 011 — example (source paragraphs 2451–2451)

```text
Check: CKV_AWS_24: Ensure no security groups allow ingress from 0.0.0.0/0 to port 22
```

### 012 — command (source paragraphs 2457–2458)

```bash
$ tflint --init
$ tflint --recursive
```

### 013 — workflow (source paragraphs 2477–2630)

```yaml
name: Terraform

on:
  pull_request:
    types: [opened, synchronize, reopened]
  push:
    branches:
      - main

env:
  TF_VERSION: "1.16.3"
  TF_VAR_environment: dev

permissions:
  contents: read

jobs:
  fmt:
    name: Format Check
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v7

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v4
        with:
          terraform_version: ${{ env.TF_VERSION }}

      - name: Format Check
        run: terraform fmt -check -recursive

  validate:
    name: Validate
    runs-on: ubuntu-latest
    needs: fmt
    steps:
      - name: Checkout
        uses: actions/checkout@v7

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v4
        with:
          terraform_version: ${{ env.TF_VERSION }}

      - name: Validate
        run: |
          terraform init -backend=false -lockfile=readonly
          terraform validate

  pr_plan:
    name: PR Plan
    runs-on: ubuntu-latest
    needs: validate
    if: >
      github.event_name == 'pull_request' &&
      github.event.pull_request.head.repo.full_name == github.repository
    permissions:
      id-token: write
      contents: read
    steps:
      - name: Checkout
        uses: actions/checkout@v7

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v4
        with:
          terraform_version: ${{ env.TF_VERSION }}

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v6
        with:
          role-to-assume: arn:aws:iam::123456789012:role/github-actions-terraform-plan
          aws-region: us-east-1

      - name: Initialise Terraform
        run: terraform init -lockfile=readonly

      - name: Plan
        id: plan
        run: terraform plan -lock-timeout=5m -no-color

  post_merge_plan:
    name: Post-Merge Plan
    runs-on: ubuntu-latest
    needs: validate
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    permissions:
      id-token: write
      contents: read
    steps:
      - name: Checkout
        uses: actions/checkout@v7

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v4
        with:
          terraform_version: ${{ env.TF_VERSION }}

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v6
        with:
          role-to-assume: arn:aws:iam::123456789012:role/github-actions-terraform-plan
          aws-region: us-east-1

      - name: Initialise Terraform
        run: terraform init -lockfile=readonly

      - name: Plan
        id: post_merge_plan
        run: terraform plan -lock-timeout=5m -out=reviewed.tfplan -no-color

      - name: Upload Plan Artifact
        uses: actions/upload-artifact@v7
        with:
          name: reviewed-plan
          path: reviewed.tfplan
          retention-days: 1

  apply:
    name: Apply
    runs-on: ubuntu-latest
    needs: post_merge_plan
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    environment:
      name: terraform-apply
    permissions:
      id-token: write
      contents: read
    steps:
      - name: Checkout
        uses: actions/checkout@v7

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v4
        with:
          terraform_version: ${{ env.TF_VERSION }}

      - name: Configure AWS Credentials
        uses: aws-actions/configure-aws-credentials@v6
        with:
          role-to-assume: arn:aws:iam::123456789012:role/github-actions-terraform-apply
          aws-region: us-east-1

      - name: Initialise Terraform
        run: terraform init -lockfile=readonly

      - name: Download Plan Artifact
        uses: actions/download-artifact@v8
        with:
          name: reviewed-plan

      - name: Apply
        run: terraform apply reviewed.tfplan
```
