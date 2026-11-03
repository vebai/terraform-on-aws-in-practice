# Chapter 2 — Inspect and approve Terraform changes

**Outcome:** Understand what Terraform intends to change *before* AWS is modified. You will compare an ordinary plan, a saved plan and the actual state.

## Starting state

Use the S3 exercise from [Chapter 1](../chapter-01-understand-terraform/README.md), or an existing, correctly initialised `terraform-vpc/` deployment. The S3 exercise is the safer choice for first practice.

For the S3 example, first set your actual bucket name and initialise its directory:

```bash
export BUCKET_NAME="your-existing-chapter-1-test-bucket"
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket init
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket fmt -check
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket validate
```

## Compare a plan with the state

```bash
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket plan -var="bucket_name=$BUCKET_NAME"
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket state list
```

If the bucket has not yet been created, the plan should propose adding it. If it already exists *in this Terraform state* and matches configuration, expect no changes. A bucket existing in AWS but **not in this state** is not automatically managed by Terraform.

## Save and review a plan

```bash
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket plan -var="bucket_name=$BUCKET_NAME" -out=reviewed.tfplan
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket show reviewed.tfplan
```

Read the resource name, action (`+`, `~` or `-`), Region and any replacements. Apply the saved plan **only if the proposed change is the one you intend**:

```bash
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket apply reviewed.tfplan
```

Verify:

```bash
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket plan -var="bucket_name=$BUCKET_NAME"
```

A clean plan reports no changes. Saved plans can contain sensitive values; keep them out of Git and delete the local `reviewed.tfplan` after this exercise. Clean up the S3 bucket using the Chapter 1 destroy procedure when finished.

**Troubleshooting:** If a saved plan is stale, stop and generate a new one; do not reuse it after the configuration or state has changed.
