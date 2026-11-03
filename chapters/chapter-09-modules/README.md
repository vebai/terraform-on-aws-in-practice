# Chapter 9 — Refactor a network into a module without replacing it

**Outcome:** Move the VPC's Terraform addresses into `module.network` while keeping the *same AWS resources* and the *same Terraform state*.

## Understand the two stages

A starting configuration may declare resources such as `aws_vpc.main` directly. After the refactor, the corresponding address becomes `module.network.aws_vpc.main`. Terraform `moved` blocks tell Terraform that this is a change of **address**, not permission to destroy and recreate a VPC.

The complete refactored structure is shown in [refactor-example/](refactor-example/README.md), including `main.tf`, `moved.tf` and `modules/network/`.

## Check your existing state

Use the already deployed `terraform-vpc/` directory and its configured backend:

```bash
terraform -chdir=terraform-vpc workspace show
terraform -chdir=terraform-vpc state list
terraform -chdir=terraform-vpc validate
terraform -chdir=terraform-vpc plan
```

If the state already contains `module.network.*`, your configuration is **already refactored**; inspect the module and plan without repeating migration steps.

If state still contains root addresses such as `aws_vpc.main`, study the refactor snapshot before changing any `.tf` files. Copy the module into the *same root*, update references and add the corresponding `moved` blocks; then initialise and plan against the **existing state**.

## Verify the move

A safe migration plan shows Terraform address moves **without `destroy`/`create` for the networking resources**. Stop if the VPC, subnets, routes or internet gateway would be replaced unexpectedly.

After a reviewed apply, check:

```bash
terraform -chdir=terraform-vpc state list
terraform -chdir=terraform-vpc plan
```

The state should show `module.network.*`, and a fresh plan should be clean. Keep the environment running if continuing to CI/CD.
