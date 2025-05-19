
# 🧾 Code Quality Check - Runbook & README

This document explains how to use the standalone Checkstyle-based code quality checker for Java/Spring Boot projects. It covers execution steps, rule definitions, report insights, and customization instructions.

---

## 📦 1. How to Run the Script

1. Place the following files in your **Spring Boot project root directory**:

   - `run_checkstyle_<custom>.sh`
   - `custom_checks.xml`

2. Make the script executable:

```bash
chmod +x run_checkstyle_<custom>.sh
```

3. Run the script:

```bash
./run_checkstyle_<custom>.sh
```

The script will:

- Download the Checkstyle JAR (if not already present)
- Analyze the `src/` directory
- Generate:
  - A `.txt` report with timestamp
  - An `.html` report with timestamp
  - A code quality score (out of 100)

---

## 🔍 2. What Code Checks Are Included

The rules defined in `custom_checks.xml` enforce a wide range of Java coding best practices. These ensure readability, consistency, maintainability, and early detection of potential issues. Here's a breakdown:

### ✅ Naming Conventions

These ensure that your code elements follow industry-standard naming:

- `ClassName`: Classes should use PascalCase (e.g., `OrderService`)
- `MethodName`: Methods should use camelCase (e.g., `calculateTotal()`)
- `ConstantName`: Constants should use ALL_CAPS with underscores
- `LocalVariableName`, `MemberName`, `ParameterName`: All follow camelCase and avoid underscores or confusing patterns
- `PackageName`: All lowercase with no underscores or camelCase

### ✅ Code Formatting & Whitespace

Enforces consistent structure in your Java files:

- `WhitespaceAround`, `WhitespaceAfter`, `NoWhitespaceBefore`: Controls spacing around operators, commas, and keywords
- `NeedBraces`, `LeftCurly`, `RightCurly`: Ensures all control structures (`if`, `while`, etc.) use braces and have consistent placement
- `EmptyLineSeparator`: Enforces spacing between methods or groups for clarity

### ✅ Code Complexity Checks

Keeps your code clean and manageable:

- `MethodLength`: Flags methods that exceed 50 lines
- `CyclomaticComplexity`: Detects overly complex methods (threshold is 10 paths/branches)
- `ClassFanOutComplexity`: Detects classes that depend on too many other classes (max 20)
- `ReturnCount`: Warns if a method has too many `return` statements (max 3)
- `NestedIfDepth`: Limits nesting of `if` conditions (max depth: 3)

### ✅ Import Hygiene

Improves clarity and avoids confusion:

- `AvoidStarImport`: Disallows `import java.util.*;`
- `RedundantImport`: Prevents duplicate imports
- `UnusedImports`: Detects unused imports that should be removed

### ✅ Javadoc & Documentation

Ensures important classes and methods are documented:

- `JavadocType`: Flags public classes that lack Javadoc
- `JavadocMethod`: Flags public/protected methods missing proper documentation (including `@param` and `@throws`)
- `JavadocVariable`: Flags missing Javadoc on public fields

### ✅ Error-Prone & Maintainability Issues

Catches things that lead to bugs or unreadable code:

- `EmptyCatchBlock`: Prevents silent failure of exceptions
- `IllegalCatch`, `IllegalThrows`: Discourages broad `catch (Exception)` or throwing `Throwable`
- `EqualsAvoidNull`: Encourages `"value".equals(var)` instead of `var.equals("value")` to avoid null pointers

### ✅ TODO Comment Format

Standardizes task tracking in code:

- `TodoComment`: Enforces TODOs in this format: `TODO(john): refactor this logic`

---

## 📄 3. What the Report Files Contain

### `checkstyle_report_<timestamp>.txt`

- Plain text list of all violations
- At the top: code quality score and violation count

### `checkstyle_report_<timestamp>.html`

- Clickable, color-coded web report
- Grouped by file and line

### ✅ Code Quality Scoring Logic

- `Score = 100 - violation count`
- If score < 0, it’s capped at 0
- Score >= 85 is considered **PASS**

---

## ⚙️ 4. How to Update the Checks File (`custom_checks.xml`)

To add, remove, or change rules:

1. Open `custom_checks.xml`
2. Add new `<module>` entries under `<module name="TreeWalker">` or at the root
3. Example: To enforce max 3 return statements:

```xml
<module name="ReturnCount">
  <property name="max" value="3"/>
</module>
```

4. Save and rerun the script

To temporarily disable a rule:

- Comment it out with `<!-- ... -->`
- Or set `<property name="severity" value="ignore"/>`

---

## 📚 5. What This Is Based On

The check rules are derived from:

- ✅ [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- ✅ Extended with custom rules for complexity, maintainability, and review standards
- ✅ Uses [Checkstyle](https://checkstyle.org) (version 10.12.3)

This system is designed to provide high-confidence code health signals in **pre-PR** reviews and can later be extended into CI/CD pipelines.
