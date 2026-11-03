# Test status — evidence, not assumptions

- **Source extraction:** Automatically checked against all pure Menlo-font code paragraphs in the uploaded manuscript. All chapter, front matter, conclusion and appendix listings are present in their corresponding `BOOK-CODE.md` file. Mixed-font paragraphs containing code are also recorded in the inline-code audit.
- **Local Terraform:** Earlier repository drafts passed the local Terraform CLI validation tests on the author's MacBook. The new book-derived `.tf` files in **this** ZIP have not yet been validated by Terraform CLI; run `terraform fmt -check`, `terraform init -backend=false`, `terraform validate` on the relevant lab before claiming that.
- **AWS live tests:** An earlier Chapter 1 S3 lab was created, checked and destroyed in `eu-west-2`. An earlier Chapter 4 VPC was created and verified in `eu-west-2`. Neither establishes that this new ZIP, Chapter 5, S3 backend migration, module refactor, CI/CD workflow or recovery procedures have all been live-validated.
- **GitHub:** No repository push has been performed as part of this build.
- **Cleanup warning:** The earlier live VPC may still exist; verify it and recover its original state or delete it safely before testing a new deployment. Never assume deleting a local folder deletes AWS infrastructure.
