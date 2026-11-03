# Chapter 9 — module refactor (existing state, not a new deployment)

This is the **after-refactor** snapshot. If you have already deployed Chapters 4 and 5, do not apply this snapshot as a separate configuration with an empty state file: it would create another set of AWS resources.

Follow the book: copy the module files into the **same** `terraform-vpc/` working directory, replace the direct network resources with the `module "network"` call, add `moved.tf` and update references to the module outputs. Keep the existing backend and state. `terraform init` and review `terraform plan`: the eight network addresses should move, **not** be destroyed/recreated.

The `refactor-example/` folder is a copyable **reference snapshot** and can be checked with `terraform init -backend=false` and `terraform validate`, but its state must not be treated as the currently deployed state.
