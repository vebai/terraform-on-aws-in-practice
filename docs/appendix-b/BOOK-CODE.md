# Appendix B — complete original code and command listings

These listings are transcribed from the uploaded manuscript, in source order. The original `us-east-1` text and illustrative placeholders are intentionally retained here. They are **reference examples**, not a file to execute as a whole.

The numbered entries include complete configurations, partial snippets, shell commands, sample output and deliberately broken examples. Only the designated `.tf` files in the working lab are intended to be executed.

### 001 — example (source paragraphs 3495–3506)

```text
Correct account?    ─── aws sts get-caller-identity
Correct region?     ─── Check provider or AWS_REGION
Correct workspace?  ─── terraform workspace show
Remote state?       ─── backend configured and accessible
Dependencies controlled? ─── .terraform.lock.hcl committed and dependency changes reviewed?
Replacement understood? ─── -/+ investigated
Destroy understood? ─── terraform plan -destroy reviewed
IAM reviewed?       ─── Least privilege? No static keys?
Network reviewed?   ─── Security groups, routes, public access?
Secrets protected?  ─── No secrets in configuration or user data? State and saved plans encrypted and access-controlled?
Apply controlled?   ─── Reviewed plan and required approval path in place?
Verification complete? ─── Infrastructure matches expectations?
```
