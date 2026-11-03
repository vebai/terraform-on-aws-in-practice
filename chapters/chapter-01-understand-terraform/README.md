# Chapter 1 — Your first Terraform-managed AWS resource

**Outcome:** Create a test S3 bucket, confirm it exists in AWS, and remove it cleanly. This exercise is independent of the later VPC/EC2 environment.

## Before you begin

Install Terraform 1.10+, AWS CLI v2 and configure an AWS identity allowed to create and delete a test S3 bucket. Check the account:

```bash
aws sts get-caller-identity
terraform version
```

The exercise uses `eu-west-2`. An S3 bucket name must be globally unique; choose a lower-case name with numbers and hyphens that no one else uses.

## Run the lab

From the repository root, choose **one bucket name** and use it consistently:

```bash
export BUCKET_NAME="my-terraform-lab-$(aws sts get-caller-identity --query Account --output text)-$(date +%s)"
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket init
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket fmt -check
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket validate
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket plan -var="bucket_name=$BUCKET_NAME"
```

Confirm the plan proposes **one S3 bucket**, with the name you chose. Then:

```bash
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket apply -var="bucket_name=$BUCKET_NAME"
aws s3api head-bucket --bucket "$BUCKET_NAME" --region eu-west-2
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket output bucket_name
```

**Evidence:** Terraform reports the bucket creation, `head-bucket` exits successfully and the output matches your chosen name. A successful `head-bucket` may print nothing.

## Remove the bucket

The bucket must be empty before Terraform can destroy it. This exercise does not upload objects.

```bash
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket plan -destroy -var="bucket_name=$BUCKET_NAME"
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket destroy -var="bucket_name=$BUCKET_NAME"
```

Verify that Terraform reports **one destroyed** and no managed resources remain in this exercise. If the bucket is not empty, inspect its contents before deleting anything; never empty an unfamiliar bucket.

**If blocked:** Recheck identity, S3 permissions, Region, name uniqueness and whether the bucket contains objects. Continue with [Chapter 2: review plans](../chapter-02-plan-and-apply/README.md).
