# Chapter 9 — Build Simple Terraform Modules — complete original code and command listings

These listings are transcribed from the uploaded manuscript, in source order. The original `us-east-1` text and illustrative placeholders are intentionally retained here. They are **reference examples**, not a file to execute as a whole.

The numbered entries include complete configurations, partial snippets, shell commands, sample output and deliberately broken examples. Only the designated `.tf` files in the working lab are intended to be executed.

### 001 — terraform (source paragraphs 1970–1977)

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}
```

### 002 — terraform (source paragraphs 1981–2004)

```hcl
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability Zone for the subnets"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
```

### 003 — terraform (source paragraphs 2010–2086)

```hcl
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
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
  availability_zone = var.availability_zone

  tags = {
    Name        = "${var.environment}-private-subnet"
    Environment = var.environment
    Type        = "private"
  }
}

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

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-private-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
```

### 004 — terraform (source paragraphs 2093–2106)

```hcl
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
```

### 005 — terraform (source paragraphs 2111–2119)

```hcl
module "network" {
  source = "./modules/network"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = data.aws_availability_zones.available.names[0]
  environment         = var.environment
}
```

### 006 — sample output (source paragraphs 2124–2134)

```text
# Before
vpc_id = aws_vpc.main.id

# After
vpc_id = module.network.vpc_id

# Before
subnet_id = aws_subnet.public.id

# After
subnet_id = module.network.public_subnet_id
```

### 007 — terraform (source paragraphs 2137–2147)

```hcl
output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_id" {
  value = module.network.public_subnet_id
}

output "private_subnet_id" {
  value = module.network.private_subnet_id
}
```

### 008 — terraform (source paragraphs 2155–2193)

```hcl
moved {
  from = aws_vpc.main
  to   = module.network.aws_vpc.main
}

moved {
  from = aws_internet_gateway.main
  to   = module.network.aws_internet_gateway.main
}

moved {
  from = aws_subnet.public
  to   = module.network.aws_subnet.public
}

moved {
  from = aws_subnet.private
  to   = module.network.aws_subnet.private
}

moved {
  from = aws_route_table.public
  to   = module.network.aws_route_table.public
}

moved {
  from = aws_route_table.private
  to   = module.network.aws_route_table.private
}

moved {
  from = aws_route_table_association.public
  to   = module.network.aws_route_table_association.public
}

moved {
  from = aws_route_table_association.private
  to   = module.network.aws_route_table_association.private
}
```

### 009 — command (source paragraphs 2197–2200)

```bash
$ terraform fmt
$ terraform init
$ terraform validate
$ terraform plan
```

### 010 — sample output (source paragraphs 2203–2205)

```text
# aws_vpc.main has moved to module.network.aws_vpc.main
# aws_subnet.public has moved to module.network.aws_subnet.public
# ... and so on
```

### 011 — command (source paragraphs 2208–2208)

```bash
$ terraform apply
```

### 012 — fragment (source paragraphs 2211–2215)

```hcl
MODULE CALL
    ↓
SOURCE      → where the module code lives
INPUTS      → values passed to the module
OUTPUTS     → values returned by the module
```

### 013 — fragment (source paragraphs 2219–2220)

```hcl
source = "./modules/network"          # Local path
source = "terraform-aws-modules/vpc/aws" # Terraform Registry
```

### 014 — terraform (source paragraphs 2225–2233)

```hcl
module "network" {
  source = "./modules/network"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = data.aws_availability_zones.available.names[0]
  environment         = var.environment
}
```

### 015 — example (source paragraphs 2236–2238)

```text
module.network.vpc_id
module.network.public_subnet_id
module.network.private_subnet_id
```

### 016 — terraform (source paragraphs 2242–2248)

```hcl
module "network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = var.environment
  # ... other inputs
}
```

### 017 — terraform (source paragraphs 2269–2271)

```hcl
module "network" {
  source = "git::https://github.com/example/network-module.git?ref=v1.2.0"
}
```

### 018 — example (source paragraphs 2279–2279)

```text
A module should have one clear purpose.
```

### 019 — terraform (source paragraphs 2288–2291)

```hcl
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
```
