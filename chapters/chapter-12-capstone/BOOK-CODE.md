# Chapter 12 — Build, Change, Break, and Recover an AWS Environment — complete original code and command listings

These listings are transcribed from the uploaded manuscript, in source order. The original `us-east-1` text and illustrative placeholders are intentionally retained here. They are **reference examples**, not a file to execute as a whole.

The numbered entries include complete configurations, partial snippets, shell commands, sample output and deliberately broken examples. Only the designated `.tf` files in the working lab are intended to be executed.

### 001 — command (source paragraphs 3024–3030)

```bash
$ aws sts get-caller-identity

{
    "UserId": "ARO...:terraform-session",
    "Account": "123456789012",
    "Arn": "arn:aws:sts::123456789012:assumed-role/terraform-role/terraform-session"
}
```

### 002 — terraform (source paragraphs 3035–3052)

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

### 003 — terraform (source paragraphs 3057–3085)

```hcl
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
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

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
```

### 004 — terraform (source paragraphs 3089–3101)

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}

module "network" {
  source = "./modules/network"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = data.aws_availability_zones.available.names[0]
  environment         = var.environment
}
```

### 005 — terraform (source paragraphs 3104–3117)

```hcl
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
```

### 006 — terraform (source paragraphs 3121–3217)

```hcl
resource "aws_security_group" "ec2" {
  name_prefix = "${var.environment}-ec2-sg-"
  description = "Security group for EC2 instance"
  vpc_id      = module.network.vpc_id

  tags = {
    Name        = "${var.environment}-ec2-sg"
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  description = "HTTP from anywhere"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
  description = "All outbound traffic"
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2" {
  name_prefix        = "${var.environment}-ec2-role-"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name        = "${var.environment}-ec2-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name_prefix = "${var.environment}-ec2-profile-"
  role        = aws_iam_role.ec2.name
}

resource "aws_instance" "main" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = module.network.public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2.name

  user_data = <<-EOF
    #!/bin/bash
    dnf install -y nginx
    systemctl enable nginx
    systemctl start nginx
    echo "User data script completed."
  EOF

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    encrypted   = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.ssm
  ]

  tags = {
    Name        = "${var.environment}-ec2-instance"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

### 007 — command (source paragraphs 3221–3221)

```bash
$ terraform plan
```

### 008 — command (source paragraphs 3229–3229)

```bash
$ terraform apply
```

### 009 — command (source paragraphs 3233–3234)

```bash
$ terraform output instance_id
$ terraform output instance_public_ip
```

### 010 — command (source paragraphs 3237–3237)

```bash
$ curl http://<public-ip>
```

### 011 — command (source paragraphs 3242–3242)

```bash
$ aws ssm start-session --target <instance-id>
```

### 012 — terraform (source paragraphs 3248–3257)

```hcl
resource "aws_instance" "main" {
  # ... existing configuration

  tags = {
    Name        = "${var.environment}-ec2-instance"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Updated     = "2026-01-01"
  }
}
```

### 013 — command (source paragraphs 3260–3260)

```bash
$ terraform plan
```

### 014 — sample output (source paragraphs 3263–3270)

```text
Terraform will perform the following actions:

  # aws_instance.main will be updated in-place
  ~ resource "aws_instance" "main" {
      ~ tags = {
          + "Updated" = "2026-01-01"
        }
    }
```

### 015 — command (source paragraphs 3273–3273)

```bash
$ terraform apply
```

### 016 — command (source paragraphs 3276–3276)

```bash
$ terraform show
```

### 017 — command (source paragraphs 3282–3282)

```bash
$ terraform plan
```

### 018 — command (source paragraphs 3285–3285)

```bash
$ terraform apply
```

### 019 — command (source paragraphs 3288–3288)

```bash
$ curl http://<public-ip>
```

### 020 — command (source paragraphs 3291–3291)

```bash
$ aws ssm start-session --target <instance-id>
```

### 021 — command (source paragraphs 3299–3301)

```bash
$ aws ec2 create-tags \
    --resources <instance-id> \
    --tags Key=Updated,Value=2026-01-02
```

### 022 — command (source paragraphs 3304–3304)

```bash
$ terraform plan
```

### 023 — sample output (source paragraphs 3307–3314)

```text
Terraform will perform the following actions:

  # aws_instance.main will be updated in-place
  ~ resource "aws_instance" "main" {
      ~ tags = {
          ~ "Updated" = "2026-01-02" -> "2026-01-01"
        }
    }
```

### 024 — command (source paragraphs 3325–3325)

```bash
$ terraform apply
```

### 025 — fragment (source paragraphs 3330–3335)

```hcl
tags = {
  Name        = "${var.environment}-ec2-instance"
  Environment = var.environment
  ManagedBy   = "Terraform"
  Updated     = "2026-01-02"
}
```

### 026 — command (source paragraphs 3337–3338)

```bash
$ terraform plan -refresh-only
$ terraform apply -refresh-only
```

### 027 — command (source paragraphs 3342–3344)

```bash
$ terraform plan

No changes. Your infrastructure matches the configuration.
```

### 028 — command (source paragraphs 3347–3349)

```bash
$ aws s3api create-bucket \
    --bucket terraform-capstone-import-<unique-suffix> \
    --region us-east-1
```

### 029 — terraform (source paragraphs 3352–3359)

```hcl
resource "aws_s3_bucket" "imported" {
  bucket = "terraform-capstone-import-<unique-suffix>"

  tags = {
    Environment = var.environment
    Imported    = "true"
  }
}
```

### 030 — terraform (source paragraphs 3361–3364)

```hcl
import {
  id = "terraform-capstone-import-<unique-suffix>"
  to = aws_s3_bucket.imported
}
```

### 031 — command (source paragraphs 3366–3366)

```bash
$ terraform plan
```

### 032 — sample output (source paragraphs 3368–3384)

```text
Terraform will perform the following actions:

  # aws_s3_bucket.imported will be imported
  import {
    to = aws_s3_bucket.imported
    id = "terraform-capstone-import-<unique-suffix>"
  }

  # aws_s3_bucket.imported will be updated in-place
  ~ resource "aws_s3_bucket" "imported" {
      + tags = {
          + "Environment" = "dev"
          + "Imported"    = "true"
        }
    }

Plan: 1 to import, 0 to add, 1 to change, 0 to destroy.
```

### 033 — command (source paragraphs 3386–3386)

```bash
$ terraform apply
```

### 034 — command (source paragraphs 3388–3390)

```bash
$ terraform state list

aws_s3_bucket.imported
```

### 035 — command (source paragraphs 3394–3394)

```bash
$ terraform plan -destroy
```

### 036 — command (source paragraphs 3398–3398)

```bash
$ terraform destroy
```
