# Appendix A — Terraform command reference

```bash
terraform version
terraform init
terraform fmt
terraform fmt -check
terraform validate
terraform plan
terraform plan -out=reviewed.tfplan
terraform show reviewed.tfplan
terraform apply reviewed.tfplan
terraform output
terraform state list
terraform state show aws_instance.main
terraform state pull
terraform workspace list
terraform workspace show
terraform workspace select default
terraform plan -refresh-only
terraform plan -destroy
terraform destroy
```
