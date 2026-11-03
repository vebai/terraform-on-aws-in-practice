# First S3 bucket — complete standalone exercise

The `main.tf` file in this directory creates one AWS S3 bucket, parameterised by `bucket_name`, and prints its name. It uses `eu-west-2` by default.

## Run from the repository root

```bash
aws sts get-caller-identity
export BUCKET_NAME="my-terraform-lab-$(aws sts get-caller-identity --query Account --output text)-$(date +%s)"
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket init
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket validate
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket plan -var="bucket_name=$BUCKET_NAME"
```

Check that only one S3 bucket would be created. Apply the reviewed plan and verify:

```bash
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket apply -var="bucket_name=$BUCKET_NAME"
aws s3api head-bucket --bucket "$BUCKET_NAME" --region eu-west-2
```

A successful `head-bucket` commonly produces no terminal output. Verify the exact bucket in the AWS S3 console as an alternative.

## Clean up

```bash
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket plan -destroy -var="bucket_name=$BUCKET_NAME"
terraform -chdir=chapters/chapter-01-understand-terraform/first-s3-bucket destroy -var="bucket_name=$BUCKET_NAME"
```

The bucket must be empty. Do not use this lab directory to manage the separate Terraform remote-state bucket. See the [full Chapter 1 walkthrough](../README.md).
