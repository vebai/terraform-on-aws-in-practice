# Source coverage audit

**Coverage unit:** every monospaced (Menlo) code paragraph in the uploaded Word manuscript, including executable HCL, shell commands, illustrative fragments, errors and printed program output.

- All identified full Menlo code paragraphs are represented verbatim in the numbered `BOOK-CODE.md` listings.
- All detected mixed-font paragraphs containing inline monospaced spans are preserved in `INLINE-CODE-CROSSCHECK.md`.
- Chapter 10's complete long YAML workflow is included verbatim in `terraform.example.yml`.
- The main executable network and EC2 example files are reassembled from the exact manuscript source ranges and do not imply that other individual snippets are standalone projects.
- Manual AWS behaviour, practical procedures, rendered diagrams and how-to prose are not code listings. Coverage of these must be checked during live exercise testing; this source extraction is not an operational accuracy claim.

The `CODE-INVENTORY.csv` file includes the exact manuscript paragraph range for **every extracted listing**. The `SOURCE-SHA256.txt` file identifies the specific manuscript version used.
