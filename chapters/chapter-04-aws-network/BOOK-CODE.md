# Chapter 4 — Build an AWS Network with Terraform — complete original code and command listings

These listings are transcribed from the uploaded manuscript, in source order. The original `us-east-1` text and illustrative placeholders are intentionally retained here. They are **reference examples**, not a file to execute as a whole.

The numbered entries include complete configurations, partial snippets, shell commands, sample output and deliberately broken examples. Only the designated `.tf` files in the working lab are intended to be executed.

### 001 — command (source paragraphs 881–882)

```bash
$ mkdir terraform-vpc
$ cd terraform-vpc
```

### 002 — terraform (source paragraphs 885–957)

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
providers.tf
provider "aws" {
  region = var.aws_region
}

variables.tf
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
outputs.tf

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}
output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

vpc.tf

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}
```

### 003 — terraform (source paragraphs 961–968)

```hcl
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}
```

### 004 — terraform (source paragraphs 972–999)

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet"
    Environment = var.environment
    Type        = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name        = "${var.environment}-private-subnet"
    Environment = var.environment
    Type        = "private"
  }
}
```

### 005 — terraform (source paragraphs 1006–1023)

```hcl
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
```

### 006 — terraform (source paragraphs 1029–1041)

```hcl
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-private-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
```

### 007 — command (source paragraphs 1064–1065)

```bash
$ terraform init
$ terraform plan
```

### 008 — sample output (source paragraphs 1067–1067)

```text
Plan: 8 to add, 0 to change, 0 to destroy.
```

### 009 — command (source paragraphs 1078–1078)

```bash
$ terraform apply
```

### 010 — command (source paragraphs 1083–1083)

```bash
$ terraform output vpc_id
```

### 011 — command (source paragraphs 1085–1085)

```bash
$ aws ec2 describe-vpcs --vpc-ids <vpc-id>
```

### 012 — command (source paragraphs 1090–1091)

```bash
$ terraform plan -destroy
$ terraform destroy
```
