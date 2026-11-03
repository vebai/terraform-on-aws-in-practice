# Install Terraform and configure AWS access

Use this guide before your first lab. The commands below run in a **local macOS or Linux terminal**. If you use AWS CloudShell, AWS CLI credentials are provided by the CloudShell session; check which tools are already available before installing anything.

## 1. Install Terraform 1.10 or later

Choose **one** installation method for your operating system. The labs use Terraform 1.10+ and the AWS provider 6.x. Keep Terraform below 2.0 unless the configuration has been checked with that major version.

### macOS (Homebrew)

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform version
```

If Terraform is already installed, check `terraform version` first. Do not install a second competing Terraform binary without checking your `PATH`.

### Ubuntu or Debian (APT)

```bash
sudo apt-get update
sudo apt-get install -y curl gpg unzip
curl -fsSL https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --batch --yes --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(. /etc/os-release && echo "$VERSION_CODENAME") main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
sudo apt-get update
sudo apt-get install -y terraform
terraform version
```

If the HashiCorp APT repository does not support your distribution release, use the installation instructions linked below rather than changing your release identifier to an unrelated version.

### Fedora (DNF)

```bash
sudo dnf install -y curl unzip
curl -fsSL https://rpm.releases.hashicorp.com/fedora/hashicorp.repo |   sudo tee /etc/yum.repos.d/hashicorp.repo >/dev/null
sudo dnf install -y terraform
terraform version
```

Use a Fedora release supported by HashiCorp's RPM repository. Check the official installation page if your release is not supported.

## 2. Install AWS CLI v2

### macOS (Homebrew)

```bash
brew install awscli
aws --version
```

### Linux (x86_64 or ARM64)

```bash
case "$(uname -m)" in
  x86_64) aws_arch=x86_64 ;;
  aarch64) aws_arch=aarch64 ;;
  *) echo "Unsupported CPU architecture" >&2; exit 1 ;;
esac
aws_tmp="$(mktemp -d)"
curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${aws_arch}.zip" -o "$aws_tmp/awscliv2.zip"
unzip -q "$aws_tmp/awscliv2.zip" -d "$aws_tmp"
sudo "$aws_tmp/aws/install" --update
rm -rf "$aws_tmp"
aws --version
```

AWS CLI v2 should be shown in the output of `aws --version`. If an older binary appears, inspect your shell `PATH` before proceeding.

## 3. Configure an AWS identity

You need an AWS account and permission to create and remove resources required by the lab. **Never place access keys, credentials or Terraform state in the repository.** For local authentication, prefer IAM Identity Center or an existing managed AWS CLI profile over long-lived IAM user keys.

### Option A: IAM Identity Center (SSO)

Use this option when your organisation has granted you an IAM Identity Center assignment. Have the SSO start URL (or issuer URL) and SSO Region available.

```bash
aws configure sso --profile terraform-lab
aws sso login --profile terraform-lab
aws configure set region eu-west-2 --profile terraform-lab
export AWS_PROFILE=terraform-lab
export AWS_REGION=eu-west-2
aws sts get-caller-identity
```

The SSO setup is interactive. Select the authorised account and permission set; do not assume a role you have not been granted.

### Option B: Use an existing configured profile

```bash
aws configure list-profiles
export AWS_PROFILE=your-existing-profile
export AWS_REGION=eu-west-2
aws sts get-caller-identity
```

Replace `your-existing-profile` with a profile you already configured. If your environment supplies temporary credentials through a managed role, keep its prescribed authentication method rather than creating new credentials.

## 4. Verify before running Terraform

Run these commands from the repository root:

```bash
terraform version
aws --version
aws configure list
aws sts get-caller-identity
```

Check that Terraform is version 1.10 or newer, AWS CLI reports version 2, and the AWS account is the one you intend to use. The labs default to **London (`eu-west-2`)**; check the Region independently if using a different account or profile. AWS resources may incur charges.

Now open [Chapter 1](../chapters/chapter-01-understand-terraform/README.md) and follow its steps. Later EC2 labs can also require the [AWS Session Manager plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html) for CLI sessions.

Official references: [Install Terraform](https://developer.hashicorp.com/terraform/install), [Install AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html), [Configure AWS IAM Identity Center](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html).
