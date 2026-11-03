# Chapter 3 — Make Terraform configuration reusable

**Outcome:** Recognise inputs, resource references and outputs; change values without duplicating whole configurations.

## Starting point

Work from the repository root. Open these files in `terraform-vpc/`:

- `variables.tf` — `aws_region`, `environment` and network CIDR inputs.
- `providers.tf` — the AWS provider configuration.
- `versions.tf` — Terraform and provider version requirements.
- `outputs.tf` — values made available after an apply.

A Terraform input variable is defined in `.tf` code and may be overridden on the command line. For example, the `environment` variable defaults to `dev`.

## Practise without deploying

```bash
terraform -chdir=terraform-vpc fmt -check
terraform -chdir=terraform-vpc init -backend=false
terraform -chdir=terraform-vpc validate
```

Find where the environment value is used:

```bash
grep -RIn 'var.environment' terraform-vpc --include='*.tf'
```

Read the results: resource names and tags should be derived from the variable instead of copied literals. Inspect other expressions such as `var.vpc_cidr` and references to resource IDs or module outputs.

If you have deliberately initialised the correct live backend and are using the intended AWS account, compare:

```bash
terraform -chdir=terraform-vpc plan -var='environment=dev'
```

Do **not** apply an exploratory plan simply to test a variable. A changed environment value may rename or replace resources.

## Verify your understanding

Explain what would change if `environment` were changed to another value. Which resource arguments are parameters? Which outputs are available only after deployment? Then inspect `terraform-vpc/outputs.tf` and [Chapter 7's identity data source](../chapter-07-data-sources/README.md).

**Troubleshooting:** A missing variable value, duplicate variable or mismatched reference should be resolved with `terraform validate` before planning or applying.
