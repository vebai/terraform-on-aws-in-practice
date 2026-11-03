# Chapter 2 — Plan and Apply Infrastructure Changes Safely — complete original code and command listings

These listings are transcribed from the uploaded manuscript, in source order. The original `us-east-1` text and illustrative placeholders are intentionally retained here. They are **reference examples**, not a file to execute as a whole.

The numbered entries include complete configurations, partial snippets, shell commands, sample output and deliberately broken examples. Only the designated `.tf` files in the working lab are intended to be executed.

### 001 — command (source paragraphs 348–348)

```bash
$ terraform init
```

### 002 — sample output (source paragraphs 355–360)

```text
Initializing provider plugins...
- Finding hashicorp/aws versions matching “~> 6.0”...
- Installing hashicorp/aws v...
- Installed hashicorp/aws v...

Terraform has been successfully initialized!
```

### 003 — command (source paragraphs 362–362)

```bash
$ terraform init -upgrade
```

### 004 — command (source paragraphs 366–366)

```bash
$ terraform fmt
```

### 005 — command (source paragraphs 369–369)

```bash
$ terraform fmt -check
```

### 006 — command (source paragraphs 374–374)

```bash
$ terraform validate
```

### 007 — sample output (source paragraphs 382–382)

```text
Success! The configuration is valid.
```

### 008 — sample output (source paragraphs 384–389)

```text
Error: Missing required argument

  on main.tf line 10, in resource "aws_vpc" "main":
  10: resource "aws_vpc" "main" {}

The argument "cidr_block" is required, but no definition was found.
```

### 009 — command (source paragraphs 393–393)

```bash
$ terraform plan
```

### 010 — sample output (source paragraphs 401–411)

```text
Terraform will perform the following actions:

  # aws_s3_bucket.example will be created
  + resource "aws_s3_bucket" "example" {
      + bucket = "my-terraform-example-bucket"
      + tags   = {
          + "Environment" = "dev"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

### 011 — command (source paragraphs 418–418)

```bash
$ terraform plan -out=reviewed.tfplan
```

### 012 — command (source paragraphs 420–420)

```bash
$ terraform apply reviewed.tfplan
```

### 013 — command (source paragraphs 423–423)

```bash
$ terraform show reviewed.tfplan
```

### 014 — sample output (source paragraphs 436–439)

```text
  # aws_instance.example must be replaced
-/+ resource "aws_instance" "example" {
      ~ ami = "ami-old" -> "ami-new" # forces replacement
    }
```

### 015 — example (source paragraphs 444–446)

```text
~ tags = {
    "Name" = "old" -> "new"
  }
```

### 016 — example (source paragraphs 449–449)

```text
~ ami = "ami-old" -> "ami-new" # forces replacement
```

### 017 — terraform (source paragraphs 459–461)

```hcl
lifecycle {
  prevent_destroy = true
}
```

### 018 — terraform (source paragraphs 466–468)

```hcl
lifecycle {
  create_before_destroy = true
}
```

### 019 — terraform (source paragraphs 472–474)

```hcl
lifecycle {
  ignore_changes = [tags["LastUpdated"]]
}
```

### 020 — command (source paragraphs 487–487)

```bash
$ terraform apply
```

### 021 — sample output (source paragraphs 489–495)

```text
Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```

### 022 — command (source paragraphs 500–500)

```bash
$ terraform apply -auto-approve
```

### 023 — command (source paragraphs 504–504)

```bash
$ terraform apply reviewed.tfplan
```

### 024 — command (source paragraphs 511–511)

```bash
$ terraform output
```

### 025 — command (source paragraphs 517–517)

```bash
$ aws s3api head-bucket --bucket my-terraform-example-bucket
```

### 026 — command (source paragraphs 521–521)

```bash
$ terraform state list
```

### 027 — command (source paragraphs 526–526)

```bash
$ terraform show
```

### 028 — command (source paragraphs 535–535)

```bash
$ terraform destroy
```

### 029 — command (source paragraphs 539–539)

```bash
$ terraform plan -destroy
```

### 030 — sample output (source paragraphs 541–548)

```text
Terraform will perform the following actions:

  # aws_s3_bucket.example will be destroyed
  - resource "aws_s3_bucket" "example" {
      - bucket = "my-terraform-example-bucket"
    }

Plan: 0 to add, 0 to change, 1 to destroy.
```
