# Chapter 6 — state bucket and remote state (London Region)

Work in the existing `terraform-vpc/` directory only. The backend bucket is **not** one of the disposable resources in the VPC state. Check your AWS identity and stop if the current state is missing or unexpected.

Choose your own globally unique state bucket name and store it securely:

```bash
aws sts get-caller-identity
export AWS_REGION=eu-west-2
export TF_STATE_BUCKET="choose-your-own-globally-unique-state-bucket"
aws s3api create-bucket \
  --bucket "$TF_STATE_BUCKET" \
  --region eu-west-2 \
  --create-bucket-configuration LocationConstraint=eu-west-2
aws s3api put-bucket-versioning --bucket "$TF_STATE_BUCKET" \
  --versioning-configuration Status=Enabled
aws s3api put-public-access-block --bucket "$TF_STATE_BUCKET" \
  --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
aws s3api put-bucket-encryption --bucket "$TF_STATE_BUCKET" \
  --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
```

For the **existing** lab only, add this backend block to your `terraform { }` block in `terraform-vpc/versions.tf`, using your real bucket name:

```hcl
backend "s3" {
  bucket       = "replace-with-your-real-state-bucket"
  key          = "dev/terraform.tfstate"
  region       = "eu-west-2"
  encrypt      = true
  use_lockfile = true
}
```

Preserve your current local Terraform state before modifying the backend. Run `terraform init -migrate-state` **from the same working directory that holds the current state** and verify the state after migration. Do not migrate an empty folder or accidentally overwrite existing remote state. Never delete the state bucket as part of the VPC lab cleanup.
