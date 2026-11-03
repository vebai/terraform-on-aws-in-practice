# Chapter 3 — Write Clean and Reusable Terraform — complete original code and command listings

These listings are transcribed from the uploaded manuscript, in source order. The original `us-east-1` text and illustrative placeholders are intentionally retained here. They are **reference examples**, not a file to execute as a whole.

The numbered entries include complete configurations, partial snippets, shell commands, sample output and deliberately broken examples. Only the designated `.tf` files in the working lab are intended to be executed.

### 001 — terraform (source paragraphs 588–605)

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}
```

### 002 — terraform (source paragraphs 616–621)

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "my-terraform-example-bucket"
  tags = {
    Environment = "dev"
  }
}
```

### 003 — terraform (source paragraphs 629–636)

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}
```

### 004 — terraform (source paragraphs 641–650)

```hcl
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
```

### 005 — terraform (source paragraphs 653–661)

```hcl
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
```

### 006 — terraform (source paragraphs 665–671)

```hcl
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}
```

### 007 — example (source paragraphs 677–679)

```text
environment  = "prod"
project_name = "myapp"
vpc_cidr     = "10.0.0.0/16"
```

### 008 — terraform (source paragraphs 687–689)

```hcl
locals {
  name_prefix = "${var.environment}-${var.project_name}"
}
```

### 009 — terraform (source paragraphs 692–698)

```hcl
resource "aws_s3_bucket" "example" {
  bucket = local.name_prefix

  tags = {
    Name = local.name_prefix
  }
}
```

### 010 — terraform (source paragraphs 705–713)

```hcl
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.example.bucket
}
```

### 011 — command (source paragraphs 715–717)

```bash
$ terraform output
vpc_id = "vpc-12345678"
bucket_name = "my-terraform-example-bucket"
```

### 012 — command (source paragraphs 719–720)

```bash
$ terraform output bucket_name
"my-terraform-example-bucket"
```

### 013 — terraform (source paragraphs 729–738)

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

### 014 — terraform (source paragraphs 741–743)

```hcl
provider "aws" {
  region = var.aws_region
}
```

### 015 — terraform (source paragraphs 745–757)

```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "environment" {
  description = "Environment name"
  type        = string
}
variable "project_name" {
  description = "Project name"
  type        = string
}
```

### 016 — terraform (source paragraphs 761–770)

```hcl
variable "create_instance" {
  description = "Whether to create the EC2 instance"
  type        = bool
  default     = false
}
resource "aws_subnet" "public" {
  count      = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, count.index)
}
```

### 017 — example (source paragraphs 776–777)

```text
aws_subnet.public[0].id
aws_subnet.public[1].id
```

### 018 — terraform (source paragraphs 780–783)

```hcl
resource "aws_instance" "example" {
  count = var.create_instance ? 1 : 0
  # ... instance configuration
}
```

### 019 — terraform (source paragraphs 788–803)

```hcl
variable "subnet_cidrs" {
  description = "Subnet CIDRs keyed by Availability Zone"
  type        = map(string)

  default = {
    "us-east-1a" = "10.0.1.0/24"
    "us-east-1b" = "10.0.2.0/24"
  }
}

resource "aws_subnet" "public" {
  for_each = var.subnet_cidrs
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key
}
```

### 020 — example (source paragraphs 808–809)

```text
aws_subnet.public["us-east-1a"].id
aws_subnet.public["us-east-1b"].id
```

### 021 — terraform (source paragraphs 814–820)

```hcl
provider "registry.terraform.io/hashicorp/aws" {
  version     = "6.62.0"
  constraints = "~> 6.0"
  hashes = [
    "h1:abcdef123456...",
  ]
}
```

### 022 — sample output (source paragraphs 832–844)

```text
# Terraform
.terraform/
*.tfstate
*.tfstate.*
.terraform.tfstate.lock.info
*.tfplan

# Sensitive variable files
secrets.tfvars
secrets.auto.tfvars

# AWS credentials
.aws/
```

### 023 — example (source paragraphs 853–853)

```text
.terraform.lock.hcl
```
