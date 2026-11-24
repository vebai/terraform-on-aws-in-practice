# Security

These Terraform and AWS examples are educational lab resources, not production-ready infrastructure defaults. Review AWS IAM, network exposure, state backend permissions and cost implications before applying anything to your account.

## Reporting a security issue

If you discover a vulnerability in a repository example, please use GitHub's **Report a vulnerability** / private vulnerability reporting feature where available. If that option is not enabled, open a GitHub issue **without including credentials, tokens, private keys, account IDs, or other secrets**, and request a private reporting channel.

Do not publish sensitive Terraform state files, saved plan files, `.tfvars` containing credentials, or AWS access keys. If a credential has been exposed, revoke or rotate it promptly.

## Responsible use

Verify the selected AWS account and Region before every plan, review changes before applying, and destroy only lab resources that you have confirmed are safe to remove. Refer to the chapter guides for prerequisites and cleanup.
