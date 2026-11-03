# Chapter 1 — Understand Terraform and Infrastructure as Code — complete original code and command listings

These listings are transcribed from the uploaded manuscript, in source order. The original `us-east-1` text and illustrative placeholders are intentionally retained here. They are **reference examples**, not a file to execute as a whole.

The numbered entries include complete configurations, partial snippets, shell commands, sample output and deliberately broken examples. Only the designated `.tf` files in the working lab are intended to be executed.

### 001 — example (source paragraphs 148–151)

```text
Create a VPC.
Create a subnet inside it.
Create an Internet Gateway.
Connect the resources.
```

### 002 — terraform (source paragraphs 157–164)

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}
```

### 003 — command (source paragraphs 189–190)

```bash
$ brew tap hashicorp/tap
$ brew install hashicorp/tap/terraform
```

### 004 — command (source paragraphs 195–196)

```bash
$ sudo apt update
$ sudo apt install -y wget gpg
```

### 005 — command (source paragraphs 199–201)

```bash
$ wget -qO- https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --batch --yes --dearmor \
  -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

### 006 — command (source paragraphs 205–205)

```bash
$ gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
```

### 007 — command (source paragraphs 211–215)

```bash
$ . /etc/os-release
$ CODENAME="${UBUNTU_CODENAME:-$VERSION_CODENAME}"
$ echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $CODENAME main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
```

### 008 — command (source paragraphs 219–220)

```bash
$ sudo apt update
$ sudo apt install terraform
```

### 009 — command (source paragraphs 224–224)

```bash
$ terraform version
```

### 010 — example (source paragraphs 226–227)

```text
Terraform v1.x.x
on linux_amd64
```

### 011 — command (source paragraphs 233–237)

```bash
$ echo "1.16.3" > .terraform-version
$ tfenv install
$ tfenv use
$ tfenv list
$ terraform version
```

### 012 — command (source paragraphs 243–243)

```bash
$ aws sts get-caller-identity
```

### 013 — json (source paragraphs 245–249)

```json
{
  "UserId": "ARO...:terraform-session",
  "Account": "123456789012",
  "Arn": "arn:aws:sts::123456789012:assumed-role/terraform-role/terraform-session"
}
```

### 014 — command (source paragraphs 262–263)

```bash
$ mkdir terraform-aws-practice
$ cd terraform-aws-practice
```

### 015 — terraform (source paragraphs 266–280)

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
provider "aws" {
  region = "us-east-1"
}
resource "aws_s3_bucket" "example" {
  bucket = "my-terraform-example-bucket"
}
```

### 016 — command (source paragraphs 285–285)

```bash
$ terraform init
```

### 017 — sample output (source paragraphs 288–292)

```text
Initializing provider plugins...
- Finding hashicorp/aws versions matching “~> 6.0”...
- Installing hashicorp/aws v...
- Installed hashicorp/aws v...
Terraform has been successfully initialized!
```

### 018 — command (source paragraphs 294–294)

```bash
$ terraform plan
```

### 019 — sample output (source paragraphs 296–303)

```text
Terraform will perform the following actions:

  # aws_s3_bucket.example will be created
  + resource "aws_s3_bucket" "example" {
      + bucket = "my-terraform-example-bucket"
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

### 020 — command (source paragraphs 305–305)

```bash
$ terraform apply
```

### 021 — command (source paragraphs 310–310)

```bash
$ aws s3api head-bucket --bucket my-terraform-example-bucket
```

### 022 — command (source paragraphs 323–323)

```bash
$ terraform plan -destroy
```

### 023 — command (source paragraphs 325–325)

```bash
$ terraform destroy
```
