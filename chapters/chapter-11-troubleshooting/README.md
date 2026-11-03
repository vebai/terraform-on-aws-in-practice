# Chapter 11 — Diagnose drift and import an existing resource

**Outcome:** Distinguish real AWS changes from Terraform configuration, restore intended values and adopt an unmanaged test S3 bucket safely.

Work against the **existing** `terraform-vpc/` state, account and `eu-west-2` Region. Do not use a new state for resources already deployed by Terraform.

## Exercise A — Find and repair tag drift

Prerequisite: The EC2 instance from Chapter 5 is running and managed in the current state.

```bash
aws sts get-caller-identity
terraform -chdir=terraform-vpc workspace show
INSTANCE_ID="$(terraform -chdir=terraform-vpc output -raw instance_id)"
aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --region eu-west-2 \
  --query 'Reservations[0].Instances[0].Tags' --output table
```

For an intentional failure drill, change only the `Environment` tag from the expected `dev` to `prod`:

```bash
aws ec2 create-tags --resources "$INSTANCE_ID" --region eu-west-2 \
  --tags Key=Environment,Value=prod
terraform -chdir=terraform-vpc plan -refresh-only
terraform -chdir=terraform-vpc plan
```

**Observe:** `plan -refresh-only` highlights the actual remote change. A normal plan should propose an in-place update returning the tag from `prod` to the value declared in Terraform. Check that there is **no instance replacement**.

If the declared `dev` value is correct, apply the reviewed normal plan:

```bash
terraform -chdir=terraform-vpc apply
terraform -chdir=terraform-vpc plan
```

Verify in the EC2 console or CLI that the tag is `dev`, and the plan reports no changes. Avoid `apply -refresh-only` here: it accepts observed values into state but does not restore AWS to the declared configuration.

## Exercise B — Import a separate existing S3 bucket

Use a **new empty test bucket**; never use the Terraform remote-state bucket. Choose a globally unique name in your own account:

```bash
export IMPORT_BUCKET="terraform-import-lab-$(aws sts get-caller-identity --query Account --output text)-$(date +%s)"
aws s3api create-bucket --bucket "$IMPORT_BUCKET" --region eu-west-2 \
  --create-bucket-configuration LocationConstraint=eu-west-2
aws s3api head-bucket --bucket "$IMPORT_BUCKET" --region eu-west-2
```

Add a temporary file `terraform-vpc/chapter11-import.tf` containing the following configuration (the bucket name is supplied from an environment variable, not hard-coded):

```hcl
variable "import_bucket_name" {
  type = string
}

resource "aws_s3_bucket" "existing" {
  bucket = var.import_bucket_name
}

import {
  to = aws_s3_bucket.existing
  id = var.import_bucket_name
}
```

Make the variable available to Terraform:

```bash
export TF_VAR_import_bucket_name="$IMPORT_BUCKET"
terraform -chdir=terraform-vpc fmt
terraform -chdir=terraform-vpc validate
terraform -chdir=terraform-vpc plan
```

The plan should show an **import of `aws_s3_bucket.existing`**, not a creation of another bucket. Inspect *all* other planned changes before applying. Apply only if import and any updates are intentional:

```bash
terraform -chdir=terraform-vpc apply
terraform -chdir=terraform-vpc state show aws_s3_bucket.existing
terraform -chdir=terraform-vpc plan
```

**Verify:** The imported resource shows the correct bucket ID and the final plan is clean. The import block is a record of the import; if you remove it later, keep the resource configuration while Terraform still manages the bucket. Never remove a managed resource from configuration casually: doing so may produce a destroy plan.

## Safe recovery and cleanup

If you need to stop midway, preserve the current state and inspect `terraform state list` before further changes. Do not edit the state file by hand, force-unlock an active operation or import the same AWS object into two resource addresses.

At the end of the entire cumulative lab, destroy the managed resources **while `chapter11-import.tf` is still present**, so the imported test bucket is included in the reviewed destroy plan. Only after the bucket is removed and state is empty should you delete that temporary `.tf` file. The versioned S3 backend bucket is a separate cleanup task.
