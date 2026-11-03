# Chapter 5 — Launch EC2 Securely with Terraform — complete original code and command listings

These listings are transcribed from the uploaded manuscript, in source order. The original `us-east-1` text and illustrative placeholders are intentionally retained here. They are **reference examples**, not a file to execute as a whole.

The numbered entries include complete configurations, partial snippets, shell commands, sample output and deliberately broken examples. Only the designated `.tf` files in the working lab are intended to be executed.

### 001 — terraform (source paragraphs 1115–1128)

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

### 002 — terraform (source paragraphs 1136–1145)

```hcl
resource "aws_security_group" "ec2" {
  name_prefix = "${var.environment}-ec2-sg-"
  description = "Security group for EC2 instance"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-ec2-sg"
    Environment = var.environment
  }
}
```

### 003 — terraform (source paragraphs 1149–1157)

```hcl
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  description = "HTTP from anywhere"
}
```

### 004 — terraform (source paragraphs 1161–1167)

```hcl
resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
  description = "All outbound traffic"
}
```

### 005 — terraform (source paragraphs 1172–1191)

```hcl
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
```

### 006 — terraform (source paragraphs 1197–1200)

```hcl
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
```

### 007 — terraform (source paragraphs 1204–1207)

```hcl
resource "aws_iam_instance_profile" "ec2" {
  name_prefix = "${var.environment}-ec2-profile-"
  role        = aws_iam_role.ec2.name
}
```

### 008 — command (source paragraphs 1220–1220)

```bash
$ aws ssm start-session --target <instance-id>
```

### 009 — fragment (source paragraphs 1225–1231)

```hcl
user_data = <<-EOF
  #!/bin/bash
  dnf install -y nginx
  systemctl enable nginx
  systemctl start nginx
  echo "User data script completed."
EOF
```

### 010 — terraform (source paragraphs 1236–1239)

```hcl
metadata_options {
  http_tokens   = "required" # Enforces IMDSv2
  http_endpoint = "enabled"
}
```

### 011 — terraform (source paragraphs 1243–1247)

```hcl
root_block_device {
  volume_type = "gp3"
  volume_size = 20
  encrypted   = true
}
```

### 012 — terraform (source paragraphs 1252–1287)

```hcl
resource "aws_instance" "main" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
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

### 013 — terraform (source paragraphs 1290–1294)

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
```

### 014 — terraform (source paragraphs 1296–1303)

```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.main.public_ip
}
```

### 015 — command (source paragraphs 1317–1318)

```bash
$ terraform init
$ terraform plan
```

### 016 — sample output (source paragraphs 1320–1320)

```text
Plan: 7 to add, 0 to change, 0 to destroy.
```

### 017 — command (source paragraphs 1330–1330)

```bash
$ terraform apply
```

### 018 — command (source paragraphs 1335–1336)

```bash
$ terraform output instance_id
$ terraform output instance_public_ip
```

### 019 — command (source paragraphs 1339–1339)

```bash
$ curl http://<public-ip>
```

### 020 — command (source paragraphs 1343–1343)

```bash
$ aws ssm start-session --target $(terraform output -raw instance_id)
```

### 021 — command (source paragraphs 1346–1348)

```bash
$ cloud-init status --wait
$ sudo tail -n 50 /var/log/cloud-init-output.log
$ systemctl status nginx --no-pager
```

### 022 — command (source paragraphs 1353–1353)

```bash
$ terraform plan -destroy
```

### 023 — command (source paragraphs 1355–1355)

```bash
$ terraform destroy
```
