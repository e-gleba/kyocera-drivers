# Security Policy

## Supported Versions

The following branches receive security updates:

| Branch | Supported |
|---|---|
| `master` | ✅ |
| release tags (`v*`) | ✅ latest only |
| all other branches | ❌ |

## Reporting a Vulnerability

If you discover a security issue in the build system, filter code, or bundled binaries:

1. **Do not** open a public issue or discussion.
2. Email the maintainer directly at the address listed in the repository profile.
3. Include a minimal reproduction, affected commit / tag, and severity assessment.
4. Allow up to **7 business days** for an initial acknowledgment and **30 days** for a coordinated disclosure timeline.

We follow responsible disclosure. If a fix is accepted, you will be credited in the release notes unless you request anonymity.

## Scope

In scope:
- Buffer overflows or memory corruption in `rastertokpsl` or `src/` code
- Path traversal or arbitrary execution in `CMakeLists.txt` install rules
- Supply-chain issues in fetched dependencies (if `DOWNLOAD_PPDS` is enabled)

Out of scope:
- Proprietary bundled binaries (`proprietary/`) — these are unmodified OEM blobs; report upstream to Kyocera Document Solutions Inc.
- CUPS daemon vulnerabilities — report to [OpenPrinting CUPS](https://github.com/OpenPrinting/cups)
