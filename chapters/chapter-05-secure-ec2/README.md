# Chapter 5 — Run an EC2 web server and access it safely

**Outcome:** Start Amazon Linux 2023 with Nginx, verify HTTP access and use AWS Systems Manager Session Manager without opening SSH port 22.

## Starting state

Use the **same `terraform-vpc/` directory and state** as Chapter 4. The required EC2 configuration may already be present in `terraform-vpc/ec2.tf`, `instance_variables.tf` and `instance_outputs.tf`. If those files are absent, `add-to-terraform-vpc/` contains the three files to add to that root. **Do not copy them over newer files or declare the same resource twice.**

Verify the account and Region:

```bash
aws sts get-caller-identity
terraform -chdir=terraform-vpc validate
terraform -chdir=terraform-vpc plan
```

The configuration uses a `t3.micro` instance, an IAM instance profile with `AmazonSSMManagedInstanceCore`, IMDSv2 and a security group allowing HTTP on port 80. Check regional instance quotas and available capacity. Public HTTP access is intended only for the test.

## Create or verify the instance

Review the full Terraform plan, then apply *only if it matches your intended lab*:

```bash
terraform -chdir=terraform-vpc apply
terraform -chdir=terraform-vpc output instance_id
terraform -chdir=terraform-vpc output instance_public_ip
```

Check Nginx from your MacBook or CloudShell:

```bash
PUBLIC_IP="$(terraform -chdir=terraform-vpc output -raw instance_public_ip)"
curl --connect-timeout 10 --max-time 20 -i "http://$PUBLIC_IP/"
```

**Evidence:** An HTTP `200 OK` response and the Nginx page. User data may take a short time after instance launch; if it fails, inspect EC2 status checks and the user-data log via Session Manager.

## Open a Session Manager session

```bash
INSTANCE_ID="$(terraform -chdir=terraform-vpc output -raw instance_id)"
aws ssm start-session --target "$INSTANCE_ID" --region eu-west-2
```

This requires a functioning SSM agent, instance-role permissions, network connectivity to SSM endpoints and your own `ssm:StartSession` permission. From the AWS Console you can also select **EC2 → Instances → instance → Connect → Session Manager**.

**Verify:** The session opens without an inbound SSH rule. Exit the remote shell before proceeding.

## If HTTP or Session Manager fails

For HTTP, check instance health, public IP, route table, port 80 security-group rule and Nginx status. For Session Manager, check instance profile, the attached managed policy, agent connectivity, endpoint access and the caller's IAM permissions. Session Manager and HTTP have **different network and authorisation paths**.

Retain the instance if continuing to [Chapter 6](../chapter-06-remote-state/README.md). Otherwise, review the destroy plan for **all** resources in the cumulative root before using `destroy`.
