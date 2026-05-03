---
name: Bug report
about: Create a report to help us improve the driver or build system
title: "fix(scope): short description"
labels: bug
type: bug
assignees: ''
---

## Summary

<!-- A clear and concise description of the bug. -->

## Environment

- **Printer model:** e.g. Kyocera FS-1020MFP
- **Firmware version:** (if known)
- **Linux distribution:** e.g. Fedora 40, Ubuntu 24.04
- **CUPS version:** e.g. 2.4.7
- **CMake preset used:** `gcc` / `clang` / `msvc`
- **Repository commit or tag:** e.g. `master` @ `0804029`

## Steps to Reproduce

1. Step one
2. Step two
3. ...

## Expected Behavior

<!-- What should have happened? -->

## Actual Behavior

<!-- What actually happened? Include error messages, logs, or screenshots. -->

## Logs and Diagnostics

```text
# Paste relevant excerpts from /var/log/cups/error_log here
```

```text
# Paste build or configure output here if the issue is a build failure
```

## Additional Context

- Does the proprietary bundled driver (`INSTALL_ORIGINAL_PROPRIETARY_DRIVERS=ON`) produce the same result?
- Have you tested with another page size or orientation?
- Any relevant PPD modifications?
