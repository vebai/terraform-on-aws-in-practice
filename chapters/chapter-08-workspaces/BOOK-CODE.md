# Chapter 8 — Use Terraform Workspaces Safely — complete original code and command listings

These listings are transcribed from the uploaded manuscript, in source order. The original `us-east-1` text and illustrative placeholders are intentionally retained here. They are **reference examples**, not a file to execute as a whole.

The numbered entries include complete configurations, partial snippets, shell commands, sample output and deliberately broken examples. Only the designated `.tf` files in the working lab are intended to be executed.

### 001 — command (source paragraphs 1738–1741)

```bash
$ terraform workspace list
  default
* dev
  prod
```

### 002 — command (source paragraphs 1744–1750)

```bash
$ terraform workspace new dev

Created and switched to workspace "dev"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan", Terraform will not see any existing state
for this configuration.
```

### 003 — command (source paragraphs 1753–1755)

```bash
$ terraform workspace select prod

Switched to workspace "prod".
```

### 004 — command (source paragraphs 1758–1760)

```bash
$ terraform workspace show

dev
```

### 005 — command (source paragraphs 1765–1766)

```bash
$ export TF_WORKSPACE=prod
$ terraform plan
```

### 006 — terraform (source paragraphs 1771–1779)

```hcl
locals {
  environment = terraform.workspace

  instance_type = {
    default = "t3.micro"
    dev     = "t3.micro"
    prod    = "t3.medium"
  }
}
```

### 007 — fragment (source paragraphs 1782–1786)

```hcl
instance_type = local.instance_type[terraform.workspace]

tags = {
  Workspace = terraform.workspace
}
```

### 008 — terraform (source paragraphs 1809–1817)

```hcl
terraform {
  backend "s3" {
    bucket       = "my-terraform-state-bucket"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

### 009 — fragment (source paragraphs 1819–1821)

```hcl
default workspace → terraform.tfstate
dev workspace     → env:/dev/terraform.tfstate
prod workspace    → env:/prod/terraform.tfstate
```

### 010 — command (source paragraphs 1836–1837)

```bash
$ aws sts get-caller-identity
$ terraform workspace show
```

### 011 — example (source paragraphs 1839–1841)

```text
Which AWS account am I targeting?
Which Terraform workspace is active?
What does the plan say will change?
```

### 012 — terraform (source paragraphs 1843–1846)

```hcl
provider "aws" {
  region              = var.aws_region
  allowed_account_ids = ["123456789012"]
}
```

### 013 — command (source paragraphs 1851–1853)

```bash
$ terraform workspace new dev
$ terraform plan
$ terraform apply
```

### 014 — command (source paragraphs 1855–1857)

```bash
$ terraform workspace new prod
$ terraform plan
$ terraform apply
```

### 015 — command (source paragraphs 1859–1862)

```bash
$ terraform workspace select dev
# Edit configuration
$ terraform plan
$ terraform apply
```

### 016 — command (source paragraphs 1867–1871)

```bash
$ terraform workspace select prod
$ aws sts get-caller-identity
$ terraform workspace show
$ terraform plan
$ terraform apply
```

### 017 — command (source paragraphs 1894–1895)

```bash
$ aws sts get-caller-identity
$ terraform workspace show
```

### 018 — fragment (source paragraphs 1899–1901)

```hcl
tags = {
  Workspace = terraform.workspace
}
```
