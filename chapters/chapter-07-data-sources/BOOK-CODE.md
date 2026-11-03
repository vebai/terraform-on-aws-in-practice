# Chapter 7 — Use AWS Data Sources with Terraform — complete original code and command listings

These listings are transcribed from the uploaded manuscript, in source order. The original `us-east-1` text and illustrative placeholders are intentionally retained here. They are **reference examples**, not a file to execute as a whole.

The numbered entries include complete configurations, partial snippets, shell commands, sample output and deliberately broken examples. Only the designated `.tf` files in the working lab are intended to be executed.

### 001 — fragment (source paragraphs 1616–1620)

```hcl
RESOURCE
Terraform manages it.

DATA SOURCE
Terraform reads it.
```

### 002 — terraform (source paragraphs 1623–1625)

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```

### 003 — terraform (source paragraphs 1635–1638)

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
}
```

### 004 — terraform (source paragraphs 1644–1652)

```hcl
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "user_arn" {
  value = data.aws_caller_identity.current.arn
}
```

### 005 — command (source paragraphs 1655–1659)

```bash
$ terraform output account_id
"123456789012"

$ terraform output user_arn
"arn:aws:sts::123456789012:assumed-role/terraform-role/terraform-session"
```

### 006 — terraform (source paragraphs 1671–1673)

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}
```

### 007 — fragment (source paragraphs 1686–1690)

```hcl
ami = data.aws_ami.amazon_linux_2023.id

tags = {
  AccountID = data.aws_caller_identity.current.account_id
}
```
