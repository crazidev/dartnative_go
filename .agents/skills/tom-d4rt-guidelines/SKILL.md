---
name: tom-d4rt-guidelines
description: >-
  Use this skill when developing across any package in the tom_d4rt repository, verifying publication readiness, auditing documentation conformance, or managing dependencies. Covers the Per-Project Documentation Checklist (D1-D6 artifacts), the canonical limitations rule (todo-2 canon), category rules A-F, and interpreter version resolution (caret vs floor rules).
---

# tom_d4rt_guidelines — Repo-Wide Development & Documentation Guidelines Skill

`tom_d4rt_guidelines` encapsulates the repository-wide engineering policies, publication acceptance gates, documentation standards, and interpreter dependency versioning rules across the entire D4rt project family.

---

## Key Policies & Architecture

### 1. The Per-Project Documentation Checklist (D1–D6)
Every published package in the repo must ship the required baseline doc set:
- **D1 (README.md)**: Purpose, install snippet, minimal usage, dependency table, links. Versions must match `pubspec.yaml` (Policy P4).
- **D2 (CHANGELOG.md)**: Top entry matches current `pubspec.yaml` version.
- **D3 (User Guide)**: `doc/<project>_user_guide.md` — full guide or differences-only pointer.
- **D4 (Configuration Guide)**: `doc/<project>_configuration.md` — mandatory only where configuration surfaces exist (e.g., `tom_d4rt_generator`).
- **D5 (Limitations)**: `doc/<project>_limitations.md` — delta file linking back to the `tom_d4rt` canon.
- **D6 (API Summary)**: `doc/api/<project>_api_summary.md` — curated API surface summary.

### 2. The Limitations-File Canon (Todo-2 Canon)
- Exactly **one canonical limitations document** exists: `tom_d4rt/doc/d4rt_limitations.md`.
- All other packages ship a **delta** file naming only their project-specific deltas and backlinks to the canon.

### 3. Interpreter Resolution & Lockfile Discipline
- **Libraries declare a caret (`^x.y.z`)**: Ensures dependencies track minor lines in committed files since `pubspec.lock` is gitignored.
- **Copy surfaces (examples, demos) declare a floor (`>=x.y.z`)**.
- After publishing an interpreter release, consuming packages must bump their caret constraint and run `pub get`.

---

## When to Use This Skill

Activate this skill when:
- Creating new packages, tools, or libraries within the `tom_d4rt` monorepo.
- Preparing a package for publication to pub.dev or running Phase C doc audits.
- Updating limitations documents (ensuring the canon+delta rule is preserved).
- Resolving dependency version conflicts, `pubspec.lock` staleness, or interpreter mismatches.

---

## Acceptance Gate Checklist

Before submitting code or releasing a package:
1. `README.md` and `CHANGELOG.md` version tags match `pubspec.yaml`.
2. `doc/<project>_user_guide.md` conforms to category rules (full vs differences-only).
3. `doc/<project>_limitations.md` adheres to the delta+backlink model.
4. `dart analyze` passes with zero warnings.
5. Package test suite runs clean.

---

## Curated Reference Documents

All reference documentation is located in [`references/`](./references/):

- [d4rt_project_doc_checklist.md](./references/d4rt_project_doc_checklist.md): Authoritative specification of the D1–D6 required documentation set, category rules A–F, and Phase C acceptance criteria.
- [interpreter_resolution.md](./references/interpreter_resolution.md): Rules governing interpreter dependency versioning, lock-preserving behavior, caret vs floor constraints, and frozen lockfile mitigation.
