# Appendix A — complete original code and command listings

These listings are transcribed from the uploaded manuscript, in source order. The original `us-east-1` text and illustrative placeholders are intentionally retained here. They are **reference examples**, not a file to execute as a whole.

The numbered entries include complete configurations, partial snippets, shell commands, sample output and deliberately broken examples. Only the designated `.tf` files in the working lab are intended to be executed.

### 001 — example (source paragraphs 3471–3493)

```text
terraform init                  Initialise working directory
terraform fmt                   Format configuration files
terraform validate              Validate configuration syntax
terraform plan                  Preview changes
terraform plan -out=reviewed.tfplan      Save reviewed plan to file
terraform show                  Display state or plan
terraform apply                 Apply changes
terraform destroy               Destroy managed resources
terraform output                Show output values
terraform state list            List resources in state
terraform state show            Show resource details
terraform state pull            Read the current state snapshot 
terraform state push            Replace backend state from a snapshot — advanced recovery only
terraform workspace list        List workspaces
terraform workspace select      Switch workspace
terraform workspace show        Show current workspace
terraform plan -refresh-only    Preview state updates
terraform apply -refresh-only   Persist reviewed refresh-only state updates
terraform fmt -check              Check formatting without rewriting files
terraform plan -destroy                           Preview destruction
terraform init -migrate-state   Migrate state to new backend
terraform init -upgrade         Reconsider provider and module versions within constraints
terraform force-unlock          Force-release a stale state lock
```
