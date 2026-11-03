# Front matter — complete original code and command listings

These listings are transcribed from the uploaded manuscript, in source order. The original `us-east-1` text and illustrative placeholders are intentionally retained here. They are **reference examples**, not a file to execute as a whole.

The numbered entries include complete configurations, partial snippets, shell commands, sample output and deliberately broken examples. Only the designated `.tf` files in the working lab are intended to be executed.

### 001 — command (source paragraphs 83–83)

```bash
$ aws sts get-caller-identity
```

### 002 — example (source paragraphs 86–88)

```text
Which AWS account am I using?
Which AWS region am I using?
What does Terraform plan to change?
```

### 003 — command (source paragraphs 102–102)

```bash
$ terraform plan
```

### 004 — terraform (source paragraphs 104–106)

```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
```
