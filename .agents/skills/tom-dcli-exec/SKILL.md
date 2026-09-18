---
name: tom-dcli-exec
description: >-
  Use this skill when compiling, testing, or executing DCli replay scripts and CLI tools using tom_dcli_exec. Covers building bin/dclie.dart, running replay tests in test mode (-test, -output), test verification functions, and CI/CD test automation.
---

# tom_dcli_exec — DCli Execution Runner Skill

`tom_dcli_exec` provides the execution runner and replay test harness for DCli and D4rt command-line tools. It supports silent replay execution, test assertions, structured result reporting, and command verification for automated testing environments.

---

## Key Architecture & Concepts

- **Test Mode & Replays**: Executes `.dcli` and `.d4rt` replay files with structured verification assertions and exit codes.
- **Verification Infrastructure**: Built-in script verification methods that assert execution states, file contents, and exit statuses without polluting standard stdout.
- **Reporting Engine**: Generates test logs, line-by-line failure summaries, and pass/fail verdicts suitable for CI/CD test pipelines.

---

## When to Use This Skill

Activate this skill when:
- Compiling or executing `bin/dclie.dart`.
- Running replay files (`*.dcli`, `*.d4rt`) in test mode.
- Writing or maintaining automated CLI test scripts.
- Integrating DCli/D4rt execution tests into CI/CD workflows.

---

## Common Workflows & Commands

### 1. Building the Executable
```bash
dart compile exe bin/dclie.dart -o bin/dclie
```

### 2. Running Replay Tests
```bash
# Run a single replay script in test mode
dart run bin/dclie.dart mytest.dcli -test -output=test_results.txt

# Run all replay tests via shell script
./test/replay/run_tests.sh
```

---

## Curated Reference Documents

All reference documentation is located in [`references/`](./references/):

- [testing.md](./references/testing.md): Full testing manual covering replay test commands, test mode flags (`-test`, `-output`), assertion functions, and result evaluation.
- [build.md](./references/build.md): Build and compilation guide for the DCli execution runner.
