# Chapter 6 — Protect Terraform State with S3 and Locking — complete original code and command listings

These listings are transcribed from the uploaded manuscript, in source order. The original `us-east-1` text and illustrative placeholders are intentionally retained here. They are **reference examples**, not a file to execute as a whole.

The numbered entries include complete configurations, partial snippets, shell commands, sample output and deliberately broken examples. Only the designated `.tf` files in the working lab are intended to be executed.

### 001 — terraform (source paragraphs 1386–1388)

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

### 002 — fragment (source paragraphs 1441–1443)

```hcl
dev/terraform.tfstate
staging/terraform.tfstate
prod/terraform.tfstate
```

### 003 — sample output (source paragraphs 1454–1454)

```text
Acquiring state lock. This may take a few moments...
```

### 004 — sample output (source paragraphs 1456–1457)

```text
Error: Error acquiring the state lock
The state was locked by another process.
```

### 005 — command (source paragraphs 1484–1486)

```bash
$ aws s3api create-bucket \
    --bucket my-terraform-state-bucket \
    --region us-east-1
```

### 006 — command (source paragraphs 1489–1491)

```bash
$ aws s3api put-bucket-versioning \
    --bucket my-terraform-state-bucket \
    --versioning-configuration Status=Enabled
```

### 007 — command (source paragraphs 1493–1503)

```bash
$ aws s3api put-bucket-encryption \
    --bucket my-terraform-state-bucket \
    --server-side-encryption-configuration '{
      "Rules": [
        {
          "ApplyServerSideEncryptionByDefault": {
            "SSEAlgorithm": "AES256"
          }
        }
      ]
    }'
```

### 008 — command (source paragraphs 1505–1508)

```bash
$ aws s3api put-public-access-block \
    --bucket my-terraform-state-bucket \
    --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

### 009 — terraform (source paragraphs 1512–1529)

```hcl
terraform {
  required_version = ">= 1.10.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "my-terraform-state-bucket"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

### 010 — command (source paragraphs 1532–1532)

```bash
$ cp terraform.tfstate terraform.tfstate.pre-migration.backup
```

### 011 — command (source paragraphs 1535–1535)

```bash
$ terraform init -migrate-state
```

### 012 — command (source paragraphs 1537–1538)

```bash
$ terraform state list
$ terraform plan
```

### 013 — command (source paragraphs 1540–1542)

```bash
$ aws s3api head-object \
    --bucket my-terraform-state-bucket \
    --key dev/terraform.tfstate
```

### 014 — sample output (source paragraphs 1548–1549)

```text
Error: Error acquiring the state lock
  State data is currently locked by another process.
```

### 015 — command (source paragraphs 1561–1561)

```bash
$ terraform force-unlock <LOCK_ID>
```

### 016 — command (source paragraphs 1592–1592)

```bash
$ terraform state list
```

### 017 — command (source paragraphs 1594–1594)

```bash
$ terraform state show <RESOURCE_ADDRESS>
```
