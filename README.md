# Terraform on AWS in Practice — companion code

**Victor Ebai** · Companion repository for *Terraform on AWS in Practice: Build, Change, and Troubleshoot AWS Infrastructure Safely*

This repository is built from the **latest uploaded 175-page manuscript**. It contains **all 259 formatted code/output listings** extracted in manuscript order, plus an audit of **224 paragraphs containing inline code references**. No previous candidate ZIP is needed.

## Reader quick start

- Open `chapters/chapter-XX-.../BOOK-CODE.md` to copy **every example from that chapter** in the same order as the book. Some snippets are conceptual or intentionally show errors; these reference files are **not** scripts to run as a whole.
- For the first S3 lab, use `chapters/chapter-01-understand-terraform/first-s3-bucket/`.
- For the continuing network lab, use **one** folder: `terraform-vpc/`. The Chapter 4 `.tf` files are ready to copy and initialise.
- In Chapter 5, add the **three** files from `chapters/chapter-05-secure-ec2/add-to-terraform-vpc/` to that **same** `terraform-vpc/` folder.
- Chapter 6 introduces an optional S3 remote backend. Follow `chapters/chapter-06-remote-state/S3-STATE-SETUP.md` only **after** your state already exists and you understand which working directory owns it.
- The Chapter 9 refactor files are in `chapters/chapter-09-modules/refactor-example/`. **Follow the migration instructions against the existing state**; do not deploy a duplicate VPC.
- Chapters 10–12 include the entire corresponding manuscript listings, workflow and recovery examples; see their chapter READMEs.

## Standard Terraform checks (run on your MacBook)

```bash
cd terraform-vpc
terraform init -backend=false
terraform fmt -check
terraform validate
```

`init -backend=false` and `validate` verify local configuration but **do not deploy AWS resources**. Use normal `init`, `plan` and `apply` only after checking your AWS identity, Region, state and plan. Never apply a plan you do not understand.

## Region and source fidelity

The uploaded manuscript uses `us-east-1`. The **runnable files** in this repo use **`eu-west-2`**, as agreed for the London lab; the `BOOK-CODE.md` references retain the book's original text. We also require a unique S3 name instead of the illustrative bucket placeholder. All differences are listed in `docs/CHANGES-FROM-BOOK.md`. If the manuscript is later changed, re-run the coverage audit on that exact revision.

## Important: existing AWS resources

You previously verified a live VPC during testing. Extracting a new ZIP **does not import or inherit its Terraform state**. Before any live `apply`, check whether those earlier AWS resources still exist and locate/clean up their original Terraform state safely. Do not create duplicate infrastructure by applying from an empty folder.

## Validation status

This is a **complete source-listing ZIP**, not a declaration that all labs are AWS-tested. Earlier Chapter 1 S3 and Chapter 4 VPC deployments succeeded, but **this newly reconstructed ZIP still requires Terraform CLI validation and live checks**. CI/CD and state recovery procedures require careful separate testing. See `docs/TEST-STATUS.md`.
