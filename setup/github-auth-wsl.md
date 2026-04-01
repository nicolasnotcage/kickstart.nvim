# GitHub Authentication on WSL

A guide for authenticating with GitHub from WSL using a fine-grained personal
access token and the GitHub CLI.

---

## 1. Install GitHub CLI

```bash
sudo apt install gh
```

---

## 2. Generate a fine-grained personal access token

Go to GitHub → Settings → Developer settings → Personal access tokens →
Fine-grained tokens → Generate new token.

Configure the token:

- **Token name:** something that identifies the machine (e.g. `wsl-ubuntu`)
- **Expiration:** your preference — 90 days is a reasonable default
- **Repository access:** All repositories (covers current and future repos)
- **Permissions → Repositories:**
  - Contents → Read and write
  - Metadata → Read-only (required, auto-selected)

Click **Generate token** and copy it immediately — GitHub will not show it
again.

> **Note:** You will need to paste this token twice during setup: once when
> authenticating with `gh auth login`, and once on your first `git push` when
> Git prompts for a password. Have it ready in your clipboard.

---

## 3. Authenticate with GitHub CLI

```bash
gh auth login
```

When prompted:

- **Where to authenticate:** GitHub.com
- **Protocol:** HTTPS
- **Authenticate Git with your GitHub credentials:** Yes
- **How to authenticate:** Paste an authentication token

Paste your token when asked.

Verify it worked:

```bash
gh auth status
```

---

## 4. Configure git credential storage

This tells git to save your credentials after the first use so you are not
prompted on every push:

```bash
git config --global credential.helper store
```

---

## 5. First push

On your first `git push`, git will prompt for credentials one final time:

- **Username:** your GitHub username
- **Password:** paste your token (not your GitHub password)

Git will save these to `~/.git-credentials`. All subsequent pushes will
authenticate silently.