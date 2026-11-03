# Install GitHub CLI

GitHub CLI (`gh`) lets you manage GitHub repositories, pull requests
and GitHub Actions from your terminal.

## macOS (Homebrew)

```bash
brew install gh
gh --version
gh auth login
gh auth status
```

To upgrade an existing installation:

```bash
brew upgrade gh
```

## Ubuntu

```bash
sudo apt update
sudo apt install gh
gh --version
gh auth login
```

If the Ubuntu repository does not provide GitHub CLI, follow
the official installation instructions:

https://github.com/cli/cli/blob/trunk/docs/install_linux.md

## Windows

Use the official installation instructions:

https://cli.github.com/

## Verify

```bash
gh auth status
gh repo view
```

These commands confirm that GitHub CLI is authenticated
and can access the current repository.
