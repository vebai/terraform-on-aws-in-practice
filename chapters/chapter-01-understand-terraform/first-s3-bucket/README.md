# Chapter 1 — first S3 bucket

The book uses `my-terraform-example-bucket` as a placeholder. Supply a **new, globally unique** bucket name. Region is `eu-west-2` for our tested setup.

```bash
cd chapters/chapter-01-understand-terraform/first-s3-bucket
terraform init
terraform validate
terraform plan -var='bucket_name=choose-your-own-unique-name'
terraform apply -var='bucket_name=choose-your-own-unique-name'
aws s3api head-bucket --bucket choose-your-own-unique-name --region eu-west-2
terraform plan -destroy -var='bucket_name=choose-your-own-unique-name'
terraform destroy -var='bucket_name=choose-your-own-unique-name'
```

Replace the name consistently; review the two plans before confirming. The clean-up step should target only the bucket created by this exercise. This lab was previously deployed, verified and cleaned up in AWS with an earlier copy of the configuration; this fresh ZIP still needs validation.
