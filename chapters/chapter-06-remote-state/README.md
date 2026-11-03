# Chapter 6 — Store Terraform state in S3 and test locking

**Outcome:** Move an existing lab's state into a protected, versioned S3 bucket and understand why a second operation cannot safely write the same state at the same time.

## Before touching state

You must know which **Terraform root, AWS account, Region and workspace** currently manage your lab. Use `terraform-vpc/`, not a fresh copy. Do not migrate state until you have confirmed that the existing state contains the resources you expect.

```bash
aws sts get-caller-identity
terraform -chdir=terraform-vpc workspace show
terraform -chdir=terraform-vpc state list
```

If `state list` is empty when you expect deployed resources, stop; locate the correct backend instead of applying a new configuration.

## Create a dedicated backend bucket

Choose a **new, globally unique name** for remote state, different from the Chapter 1 test bucket or the Chapter 11 import bucket. The detailed AWS CLI setup, including versioning, encryption and public-access blocking, is in [S3 State Setup](S3-STATE-SETUP.md).

Before migration confirm:

- The bucket belongs to the intended AWS account and is in `eu-west-2`.
- S3 versioning, default encryption and Block Public Access are enabled.
- The backend configuration uses the correct bucket, key, Region and `use_lockfile = true`.
- Your IAM identity can access the state object and create/delete the associated `.tflock` object.

## Back up, initialise and migrate

In your terminal **outside the repository**, preserve a restricted copy of the existing state:

```bash
umask 077
terraform -chdir=terraform-vpc state pull > "$HOME/terraform-state-before-migration.tfstate"
chmod 600 "$HOME/terraform-state-before-migration.tfstate"
```

After editing the backend settings in the appropriate `terraform` block for `terraform-vpc/`, migrate **that same state**:

```bash
terraform -chdir=terraform-vpc init -migrate-state
terraform -chdir=terraform-vpc state list
terraform -chdir=terraform-vpc plan
```

Expect the managed resources still to be listed, and no unexpected replacement or duplicate creation. Do not overwrite an existing populated state object.

## Observe a lock conflict

Only with a known-good, active lab and no other team operation, run a Terraform operation that holds the state lock in one terminal. In a second terminal, attempt another conflicting operation on **the same backend and workspace**. The second should be prevented by the lock. Do not use `-lock=false` or force-unlock to bypass an active operation.

**Clean up:** Destroy the managed lab first. Delete the separately provisioned backend bucket, versions and lock objects only after confirming that no state or workflow still needs them. More detail: [Chapter 12 cleanup](../chapter-12-capstone/README.md).
