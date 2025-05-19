# Shared Checkstyle Configuration

This repository contains a reusable Checkstyle setup for Java projects across multiple repositories.

---

## Contents

```
checkstyle-config/
├── custom_checks.xml          # Rule definitions
├── run_checkstyle_codebase.sh # Analysis + scoring logic for whole codebase
├── run_checkstyle_for_PR.sh   # Analysis + scoring logic for just the PR created
├── checkstyle-readme.md       # How the checkstyle works and what it checks
├── checkstyle-workflow.yml    # GitHub Actions file that should be copied over to your individual repository
```

---

## 🚀 How to Use This in Your Project

1. **Create `.github/workflows/checkstyle-workflow.yml`** in your project.

2. Paste the contents of `checkstyle-workflow.yml` from this repo.

3. In your repo’s GitHub **Settings → Variables**, add: 

```
Name: ENABLE_GHA_CHECKSTYLE
Value: true
```
4. Copy *.sh files and custom_checks.xml from this repo to your repository.
   
5. The workflow will:
   - Run Checkstyle on PRs and whole codebase whenever a PR is open.
   - Upload `.txt` into the artifacts with a summary

---

##  Custom Rules

You can add or update rules in `custom_checks.xml`. Examples include:

- Naming conventions
- Complexity limits
- Avoiding `log.debug` in `catch` blocks
- Preventing commented-out code

If your team has new requirements, fork this and customize it.

---

For any questions, reach out to `@bhoopesh-kroger` or open an issue here.
