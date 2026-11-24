# Optional shortcuts. Initialise the intended Terraform backend before use.
# No target here applies, destroys, or force-unlocks resources.
.PHONY: validate plan clean-check

validate:
	terraform -chdir=terraform-vpc fmt -check -recursive
	terraform -chdir=terraform-vpc validate

plan:
	terraform -chdir=terraform-vpc workspace show
	terraform -chdir=terraform-vpc plan

clean-check:
	terraform -chdir=terraform-vpc workspace show
	terraform -chdir=terraform-vpc plan -destroy
