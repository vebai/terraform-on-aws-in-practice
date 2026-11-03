# Changes between manuscript and copyable lab files

The `BOOK-CODE.md` files reproduce the manuscript code in original wording; the executable lab files introduce only the changes needed for safe and consistent testing:

1. The manuscript currently defaults to `us-east-1`; executable HCL uses `eu-west-2` (London). London S3 bucket creation also requires `--create-bucket-configuration LocationConstraint=eu-west-2`.
2. Chapter 1's illustrative `my-terraform-example-bucket` becomes a required `bucket_name` input to avoid S3 global-name collisions.
3. The Chapter 4 network files are distributed into `versions.tf`, `providers.tf`, `variables.tf`, `outputs.tf` and `vpc.tf` following the manuscript, with continuous network state.
4. Chapter 5 only adds `ec2.tf`, `instance_variables.tf` and `instance_outputs.tf` to Chapter 4's directory. The existing VPC should not be redeployed in a different state.
5. Chapter 9's after-refactor example changes EC2 references to module outputs as taught in the chapter and capstone, and uses the eight supplied moved blocks. It is reference code, not a separate environment to apply.
6. Chapter 10's original Actions example is included for study but deliberately is not automatically enabled in `.github/workflows`, because the example contains placeholder IAM role ARNs and automatic apply steps.

These are reader-facing differences that may warrant a focused manuscript correction after the code is fully tested. No changes were made to the uploaded manuscript.
