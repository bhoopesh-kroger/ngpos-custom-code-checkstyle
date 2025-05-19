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

4. The workflow will:
   - Clone this repo from `https://github.com/bhoopesh-kroger/checkstyle-config`
   - Copy `run_checkstyle_codebase.sh`, `run_checkstyle_for_PR` and `custom_checks.xml` to your project
   - Run Checkstyle on PRs and whole codebase
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
