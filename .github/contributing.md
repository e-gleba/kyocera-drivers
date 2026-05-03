# Contributing to kyocera_drivers

Thank you for considering a contribution. This document explains how to propose changes, report bugs, and submit pull requests.

## Development Setup

```bash
git clone https://github.com/e-gleba/kyocera-drivers.git
cd kyocera-drivers
cmake --preset gcc
cmake --build --preset gcc
ctest --preset gcc
```

## Branch Naming

Use the following prefixes so CI and changelogs can categorize your work automatically:

| Prefix | Purpose |
|---|---|
| `feat/` | New feature or model support |
| `fix/` | Bug fix |
| `docs/` | Documentation or readme changes |
| `build/` | CMake, build system, or packaging |
| `test/` | Test suite changes |
| `refactor/` | Code refactoring without behavior change |

Example: `feat/add_fs_1060dn_ppd`

## Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short summary>

<body explaining what and why>

Refs: <issue or pr number>
```

Allowed types: `feat`, `fix`, `docs`, `build`, `test`, `refactor`, `chore`, `ci`

## Pull Request Checklist

Before requesting review, verify:

- [ ] The branch is rebased on the latest `master`
- [ ] `cmake --build --preset gcc` completes without warnings (treat warnings as errors)
- [ ] `ctest --preset gcc` passes (if tests exist)
- [ ] Markdown files render correctly on GitHub
- [ ] Commit messages follow Conventional Commits
- [ ] License headers are present in new source files
- [ ] The PR description explains the problem and the solution

## Code Style

- C++: follow the `.clang-format` and `.clang-tidy` rules in the repository root
- C: same formatting rules apply via `clang-format`
- CMake: format with `cmake-format` using `.cmake-format.py`
- Python (scripts): PEP 8, black-compatible

## Reporting Bugs

Use the [bug report issue template](../issue_templates/bug_report.md). Include:

- Printer model and firmware version
- Linux distribution and CUPS version
- Build preset (`gcc` / `clang` / `msvc`)
- Exact command or CUPS job that triggered the failure
- Relevant excerpts from `/var/log/cups/error_log`

## Reverse Engineering Contributions

If your contribution involves new protocol or KPSL observations:

- Document the source (firmware version, capture method, Ghidra version)
- Keep notes in a separate `docs/re/` markdown file if the surface area is large
- Do not include proprietary binary excerpts in source files

## Questions?

Open a [discussion](https://github.com/e-gleba/kyocera-drivers/discussions) or mention `@e-gleba` in an issue.
