---
name: tom-d4rt-dcli
description: >-
  Use this skill when developing, building, or testing CLI tools and shell automation using tom_d4rt_dcli. Covers DCli integration with D4rt, building native standalone executables (dcli compile), running the test suite, and handling DCli permission quirks on macOS/Linux.
---

# tom_d4rt_dcli — DCli Shell Scripting & CLI Tool Skill

`tom_d4rt_dcli` combines the power of the `dcli` command-line and shell automation framework with the D4rt dynamic interpreter. It allows developers to author, execute, and compile command-line tools that run dynamic Dart scripts with native OS command access.

---

## Key Architecture & Concepts

- **DCli + D4rt**: Integrates DCli commands (file operations, shell process execution, pipe operators, user input prompts) directly into interpreted scripts.
- **Native Compilation**: Compiles the CLI runner to native standalone binaries via `dart compile exe` or DCli compiler.
- **Testing Surface**: Dedicated testing methodologies for verifying CLI commands, exit codes, and cross-platform terminal behavior.

---

## When to Use This Skill

Activate this skill when:
- Building or compiling the `tom_d4rt_dcli` binary (`dcli`).
- Authoring command-line automation scripts that leverage D4rt and DCli.
- Running integration tests for CLI tools.
- Troubleshooting file permission checks (`isWritable`, `isReadable`, `isExecutable`) on macOS or in non-login environments (CI, cron, nested terminals).

---

## Common Workflows & Commands

### 1. Building the DCli Binary
```bash
# Compile the native executable
dart compile exe bin/dcli.dart -o bin/dcli
```

### 2. Testing DCli and D4rt Tools
```bash
# Run the test suite
dart test

# Run permission tests specifically
dart test test/permissions_test.dart
```

---

## Curated Reference Documents

All reference documentation is located in [`references/`](./references/):

- [build.md](./references/build.md): Step-by-step instructions for building and installing the `tom_d4rt_dcli` executable.
- [testing.md](./references/testing.md): Testing guidelines for DCli scripts and tools across platforms.
- [tom_d4rt_dcli_limitations.md](./references/tom_d4rt_dcli_limitations.md): Analysis of upstream DCli permission check limitations under macOS and non-interactive CI/cron sessions.
