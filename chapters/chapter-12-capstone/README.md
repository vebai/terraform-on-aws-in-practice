# Chapter 12 — Change, break, diagnose and recover an AWS environment

**Outcome:** Make one planned configuration change, deliberately interrupt HTTP access to an EC2 web server, confirm the independent management path still works, restore access and verify a clean state.

This exercise continues the **same** `terraform-vpc/` VPC, EC2 instance, module and Terraform state used earlier. It does not create a parallel environment.

## Preconditions — verify before breaking anything

Run from your MacBook terminal or AWS CloudShell, **at the repository root**. Ensure the instance is running and the active workspace and backend are the ones that created it:

```bash
aws sts get-caller-identity
terraform -chdir=terraform-vpc workspace show
terraform -chdir=terraform-vpc state list
terraform -chdir=terraform-vpc validate
terraform -chdir=terraform-vpc plan
```

Expect a clean plan before starting. If Terraform proposes to create the environment because state is empty, **stop**: this lab needs an already deployed instance.

Collect the instance details and baseline HTTP response:

```bash
INSTANCE_ID="$(terraform -chdir=terraform-vpc output -raw instance_id)"
PUBLIC_IP="$(terraform -chdir=terraform-vpc output -raw instance_public_ip)"
curl --connect-timeout 10 --max-time 20 -i "http://$PUBLIC_IP/"
```

Expect `HTTP/1.1 200 OK` (or an equivalent HTTP 200 response).

## 1. Make a controlled tag change

In `terraform-vpc/ec2.tf`, add this tag under the `tags` map of `aws_instance.main`:

```hcl
Updated = "2026-01-01"
```

Then:

```bash
terraform -chdir=terraform-vpc validate
terraform -chdir=terraform-vpc plan
```

Ensure the plan proposes **only an in-place tag update**, not instance replacement. After review:

```bash
terraform -chdir=terraform-vpc apply
terraform -chdir=terraform-vpc plan
```

Check the tag in AWS Console → EC2 → Instances or with `aws ec2 describe-instances`. A clean plan verifies the declared and observed states agree.

## 2. Break HTTP access but retain management access

Back up the working file **outside the repository**:

```bash
cp terraform-vpc/ec2.tf "$HOME/terraform-ec2-before-http-drill.tf"
```

Temporarily remove the entire `aws_vpc_security_group_ingress_rule.http` resource block from `terraform-vpc/ec2.tf`. Do **not** remove the security group, egress rule, EC2 instance or IAM role.

```bash
terraform -chdir=terraform-vpc validate
terraform -chdir=terraform-vpc plan
```

The intended plan removes **one HTTP ingress rule** and nothing else. If more resources would change, stop and investigate. Apply the reviewed change, then test:

```bash
terraform -chdir=terraform-vpc apply
curl --connect-timeout 5 --max-time 10 -i "http://$PUBLIC_IP/"
```

The connection should fail or time out. Independently verify that Session Manager still works:

```bash
aws ssm start-session --target "$INSTANCE_ID" --region eu-west-2
```

Exit the remote shell. If Session Manager fails too, inspect the instance role, SSM agent, networking and your caller permissions before changing additional security rules.

## 3. Repair and verify

Restore the known-good configuration:

```bash
cp "$HOME/terraform-ec2-before-http-drill.tf" terraform-vpc/ec2.tf
terraform -chdir=terraform-vpc validate
terraform -chdir=terraform-vpc plan
```

The plan should re-create **only the HTTP ingress rule**. Apply after checking:

```bash
terraform -chdir=terraform-vpc apply
curl --connect-timeout 10 --max-time 20 -i "http://$PUBLIC_IP/"
terraform -chdir=terraform-vpc plan
```

**Success:** HTTP returns 200 and the final Terraform plan has no changes. The exercise shows that you can fail one application path without automatically losing management access.

## 4. Optional drift check

Modify only the EC2 `Updated` tag directly in AWS to `2026-01-02` and compare `terraform plan -refresh-only` with a normal `terraform plan`. Restore `2026-01-01` through a reviewed Terraform apply. See [Chapter 11](../chapter-11-troubleshooting/README.md) for the same workflow using `Environment`.

## 5. Safe shutdown

From the **same** backend and workspace, preserve a private state copy outside Git:

```bash
umask 077
terraform -chdir=terraform-vpc state pull > "$HOME/terraform-before-cleanup.tfstate"
chmod 600 "$HOME/terraform-before-cleanup.tfstate"
terraform -chdir=terraform-vpc plan -destroy
```

Confirm every proposed deletion belongs to this lab. Only then run:

```bash
terraform -chdir=terraform-vpc destroy
terraform -chdir=terraform-vpc state list
```

An empty `state list` confirms no managed resources remain in this Terraform state. It does **not** delete the separately created, versioned S3 backend or any GitHub OIDC IAM role/provider. Inspect those separately, and do not destroy a shared identity provider or a backend still used elsewhere. Once the infrastructure is gone, `terraform apply` would recreate it, so do not run it unintentionally.
