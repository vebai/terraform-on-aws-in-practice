# Appendix B — Pre-change verification commands

```bash
aws sts get-caller-identity
aws configure list
aws configure get region
terraform -chdir=terraform-vpc version
terraform -chdir=terraform-vpc workspace show
terraform -chdir=terraform-vpc state list
terraform -chdir=terraform-vpc fmt -check -recursive
terraform -chdir=terraform-vpc validate
terraform -chdir=terraform-vpc plan
terraform -chdir=terraform-vpc plan -destroy
git status --short
git diff --check
```
