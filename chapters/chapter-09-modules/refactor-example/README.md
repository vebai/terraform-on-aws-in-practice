# Network module — refactor reference

This directory demonstrates the **post-refactor** layout:

```text
main.tf                 Root module call
moved.tf                Old resource addresses → module.network addresses
modules/network/        Reusable VPC, subnets, routes and outputs
ec2.tf                  EC2 references updated to network module outputs
outputs.tf              Exposes network outputs from the module
```

## Inspect before migrating

Open `moved.tf` and confirm that the eight network resource addresses match those already in your **existing** Terraform state. If your deployed root already uses `module.network`, the refactor has been performed and should not be repeated.

Do a local configuration check on this snapshot without deploying it:

```bash
terraform -chdir=chapters/chapter-09-modules/refactor-example init -backend=false
terraform -chdir=chapters/chapter-09-modules/refactor-example validate
```

## Migrate an existing deployment

Do **not** run `apply` from this snapshot directory against an empty state: that would create a second VPC and EC2 environment. The migration belongs in your current `terraform-vpc/` root **with its current state and backend**:

1. Record and back up the current state.
2. Add `modules/network/` beneath the existing root.
3. Replace root network resources with the `module "network"` call and update dependent references.
4. Add the matching `moved` blocks from `moved.tf`.
5. Run `terraform -chdir=terraform-vpc init`, `validate` and `plan`.
6. Apply only if the plan shows address moves and no unintended infrastructure replacement.
7. Verify `terraform -chdir=terraform-vpc state list` and a clean plan.

**Failure check:** If a plan wants to destroy and recreate an existing VPC, stop. Check the old and new resource addresses, backend, workspace and `moved` blocks before proceeding.
