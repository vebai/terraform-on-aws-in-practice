# Chapter 11 — Troubleshoot, Import, and Recover Terraform — complete original code and command listings

These listings are transcribed from the uploaded manuscript, in source order. The original `us-east-1` text and illustrative placeholders are intentionally retained here. They are **reference examples**, not a file to execute as a whole.

The numbered entries include complete configurations, partial snippets, shell commands, sample output and deliberately broken examples. Only the designated `.tf` files in the working lab are intended to be executed.

### 001 — command (source paragraphs 2689–2689)

```bash
$ aws ec2 create-tags --resources <instance-id> --tags Key=Environment,Value=prod
```

### 002 — sample output (source paragraphs 2692–2698)

```text
Terraform will perform the following actions:
  # aws_instance.main will be updated in-place
  ~ resource "aws_instance" "main" {
      ~ tags = {
          ~ "Environment" = "prod" -> "dev"
        }
    }
```

### 003 — command (source paragraphs 2712–2712)

```bash
$ terraform plan -refresh-only
```

### 004 — command (source paragraphs 2715–2715)

```bash
$ terraform plan -refresh-only
```

### 005 — sample output (source paragraphs 2718–2723)

```text
Note: Objects have changed outside of Terraform

Terraform detected the following changes made outside of Terraform since the
last "terraform apply" which may have affected this plan:

  aws_instance.main tags.Environment changed from "dev" to "prod"
```

### 006 — command (source paragraphs 2726–2726)

```bash
$ terraform apply -refresh-only
```

### 007 — command (source paragraphs 2740–2741)

```bash
$ aws s3 ls
2026-01-01 12:00:00 my-existing-bucket
```

### 008 — terraform (source paragraphs 2745–2751)

```hcl
resource "aws_s3_bucket" "existing" {
  bucket = "my-existing-bucket"

  tags = {
    Environment = "dev"
  }
}
```

### 009 — terraform (source paragraphs 2756–2759)

```hcl
import {
  id = "my-existing-bucket"
  to = aws_s3_bucket.existing
}
```

### 010 — command (source paragraphs 2766–2766)

```bash
$ terraform plan
```

### 011 — sample output (source paragraphs 2768–2783)

```text
Terraform will perform the following actions:

  # aws_s3_bucket.existing will be imported
  import {
    to = aws_s3_bucket.existing
    id = "my-existing-bucket"
  }

  # aws_s3_bucket.existing will be updated in-place
  ~ resource "aws_s3_bucket" "existing" {
      + tags = {
          + "Environment" = "dev"
        }
    }

Plan: 1 to import, 0 to add, 1 to change, 0 to destroy.
```

### 012 — command (source paragraphs 2792–2792)

```bash
$ terraform apply
```

### 013 — command (source paragraphs 2796–2800)

```bash
$ terraform state list

aws_s3_bucket.existing

$ terraform show
```

### 014 — terraform (source paragraphs 2805–2808)

```hcl
import {
  id = "another-existing-bucket"
  to = aws_s3_bucket.generated_example
}
```

### 015 — command (source paragraphs 2811–2811)

```bash
$ terraform plan -generate-config-out=generated_resources.tf
```

### 016 — terraform (source paragraphs 2832–2835)

```hcl
moved {
  from = aws_s3_bucket.example
  to   = module.storage.aws_s3_bucket.example
}
```

### 017 — terraform (source paragraphs 2845–2851)

```hcl
removed {
  from = aws_s3_bucket.example

  lifecycle {
    destroy = false
  }
}
```

### 018 — command (source paragraphs 2854–2856)

```bash
$ terraform validate
$ terraform plan
$ terraform apply
```

### 019 — command (source paragraphs 2863–2868)

```bash
$ terraform state list

aws_s3_bucket.example
aws_vpc.main
aws_subnet.public
aws_subnet.private
```

### 020 — command (source paragraphs 2872–2878)

```bash
$ terraform state show aws_s3_bucket.example

# aws_s3_bucket.example:
resource "aws_s3_bucket" "example" {
    bucket = "my-terraform-example-bucket"
    ...
}
```

### 021 — command (source paragraphs 2895–2896)

```bash
$ terraform state list
$ terraform show
```

### 022 — command (source paragraphs 2901–2902)

```bash
$ aws s3 ls
$ aws ec2 describe-instances
```

### 023 — command (source paragraphs 2905–2905)

```bash
$ terraform plan
```

### 024 — example (source paragraphs 2925–2925)

```text
jq '{version, serial, lineage}' errored.tfstate
```

### 025 — example (source paragraphs 2929–2930)

```text
terraform state pull > remote-before-recovery.tfstate
jq '{version, serial, lineage}' remote-before-recovery.tfstate
```

### 026 — example (source paragraphs 2936–2937)

```text
bash
terraform state push errored.tfstate
```

### 027 — example (source paragraphs 2942–2943)

```text
terraform state list
terraform plan
```

### 028 — command (source paragraphs 2950–2950)

```bash
$ terraform version
```

### 029 — terraform (source paragraphs 2958–2967)

```hcl
terraform {
  required_version = ">= 1.10.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```

### 030 — command (source paragraphs 2969–2969)

```bash
$ terraform init -upgrade
```

### 031 — terraform (source paragraphs 2972–2978)

```hcl
provider "registry.terraform.io/hashicorp/aws" {
  version     = "6.62.0"
  constraints = "~> 6.0"
  hashes = [
    "h1:abcdef123456...",
  ]
}
```

### 032 — command (source paragraphs 2982–2983)

```bash
$ terraform validate
$ terraform plan
```
