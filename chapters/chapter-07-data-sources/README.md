# Chapter 7 — Read AWS information instead of hard-coding it

**Outcome:** Use Terraform data sources to identify the current AWS caller, select an Amazon Linux AMI and list available Availability Zones.

## Starting state

Work in the existing `terraform-vpc/` root. The optional file `add-to-terraform-vpc/caller_identity.tf` shows the caller-identity data source and its outputs. If your root already declares `data.aws_caller_identity.current` and the same outputs, **do not copy a duplicate definition**.

Inspect your identity first:

```bash
aws sts get-caller-identity
```

Compare it with the configuration:

```bash
grep -RIn 'aws_caller_identity\|aws_availability_zones\|aws_ami' terraform-vpc --include='*.tf'
terraform -chdir=terraform-vpc validate
```

When the correct backend and AWS identity are configured, run:

```bash
terraform -chdir=terraform-vpc plan
```

The data sources read AWS information; they do not themselves create the VPC or instance. If the plan proposes infrastructure changes, inspect those separately before applying anything.

## Verify the outputs

If the existing state has been applied with these outputs, inspect:

```bash
terraform -chdir=terraform-vpc output account_id
terraform -chdir=terraform-vpc output user_arn
```

The account ID should agree with `aws sts get-caller-identity`. For an assumed role the exact ARN presentation may differ between API and provider contexts, so inspect the returned identity rather than assuming an IAM user ARN.

**Troubleshooting:** Data-source errors usually point to Region, permissions, lookup filters or credentials. Check the provider's AWS Region and the requested AMI architecture; fix the lookup rather than hard-coding an arbitrary AMI ID.
