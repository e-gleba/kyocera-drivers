# kyocera_drivers

[![CI](https://github.com/e-gleba/kyocera-drivers/actions/workflows/package.yml/badge.svg)](https://github.com/e-gleba/kyocera-drivers/actions/workflows/package.yml)
[![Release](https://img.shields.io/github/v/release/e-gleba/kyocera-drivers)](https://github.com/e-gleba/kyocera-drivers/releases/latest)
[![CMake](https://img.shields.io/badge/CMake-%E2%89%A53.31-064F8C?logo=cmake&logoColor=white)](https://cmake.org/cmake/help/latest/release/3.31.html)
[![License](https://img.shields.io/badge/License-GPL--3.0-33A852?logo=gnu&logoColor=white)](license)
[![Platform](https://img.shields.io/badge/Platform-Linux%20x86__64-FCC624?logo=linux&logoColor=black)](https://www.kernel.org/)
[![OpenPrinting](https://img.shields.io/badge/OpenPrinting-PPD%20Archive-orange)](https://www.openprinting.org/download/PPD/Kyocera/en/)

> CMake packaging and installation system for proprietary Kyocera CUPS drivers on Linux x86_64.

---

## Overview

`kyocera_drivers` bundles the proprietary Kyocera `rastertokpsl` filter binaries and legacy PPD files into a modern CMake install system for Linux CUPS environments.

This project contains **no compiled code** — it is a pure packaging layer:

- `proprietary/rastertokpsl_amd64` — x86_64 filter binary
- `proprietary/rastertokpsl_x86` — x86 filter binary
- `proprietary/wrapper.sh.in` — architecture-aware wrapper (configured at build time, installed as `rastertokpsl`)
- `ppd/English/` — bundled legacy PPD files
- `package/kyocera_drivers.desktop` — desktop integration entry
- `CMakePresets.json` — `clang` preset chain: configure → build → package

---

## Supported Models

Bundled PPD files support the following Kyocera printers:

| Model | Type |
|---|---|
| FS-1020MFP | GDI |
| FS-1025MFP | GDI |
| FS-1040 | GDI |
| FS-1060DN | GDI |
| FS-1120MFP | GDI |
| FS-1125MFP | GDI |

**Field tested:** FS-1020MFP

---

## Prerequisites

- Linux x86_64 distribution with CUPS
- `cmake` >= 3.31
- `ninja`
- `clang`

```bash
# Fedora
sudo dnf install cmake ninja-build clang cups

# Ubuntu / Debian
sudo apt install cmake ninja-build clang cups
```

---

## Build & Install

### Clone

```bash
git clone https://github.com/e-gleba/kyocera-drivers.git
cd kyocera-drivers
```

### Configure & Build

```bash
cmake --preset clang
cmake --build --preset clang
```

### Install

```bash
sudo cmake --install build/clang --prefix /usr
```

Or as a single workflow (configure → build → package):

```bash
cmake --workflow --preset clang
```

---

## Packaging

DEB, RPM and TGZ packages are generated via CPack:

```bash
cpack --preset clang
# packages appear in build/clang/
```

Install the resulting package:

```bash
# Debian / Ubuntu
sudo dpkg -i build/clang/kyocera_drivers-*-Linux.deb

# Fedora / ALT Linux / other RPM-based distros
sudo rpm -i build/clang/kyocera_drivers-*-Linux.rpm
```

CI builds packages on every push and PR.

Releases are fully automated: push a tag `v*.*.*` and the [release workflow](.github/workflows/release.yml) builds packages, generates release notes and attaches `.deb`, `.rpm` and `.tar.gz` as assets.

---

## Uninstall

If installed via `cmake --install`:

```bash
cd build/clang
sudo xargs rm -f < install_manifest.txt
```

If installed from a package:

```bash
sudo dpkg -r kyocera_drivers   # DEB
sudo rpm -e kyocera_drivers    # RPM
```

---

## Usage

Restart CUPS after installation, then add the printer via the CUPS web UI (`http://localhost:631`) or `lpadmin`, selecting the installed Kyocera PPD:

```bash
sudo systemctl restart cups
```

---

## Troubleshooting

| Symptom | Resolution |
|---|---|
| Permission errors during install | Run with `sudo`. Ensure `/usr/share/cups/model/Kyocera` and `/usr/lib/cups/filter` are writable by root. |
| `No such preset "clang"` | Preset schema version 9 requires CMake >= 3.31. Check `cmake --version` and run `cmake --list-presets` to see available presets. |
| Missing dependencies during configure | Verify `cmake`, `ninja` and `clang` are on `PATH`. |
| Filter runtime errors | Inspect `/var/log/cups/error_log` for CUPS-level diagnostics. |
| Incorrect page size or orientation | Ensure the selected PPD matches your exact printer model. |

---

## Architecture

### CUPS Filter Pipeline

```mermaid
flowchart LR
    A[Application<br>PDF / PS / Image] -->|stdin / file| B[CUPS Scheduler<br>cupsd]
    B --> C[pdftops / imagetoraster<br>CUPS built-in filters]
    C --> D[rastertokpsl<br>Kyocera KPSL filter]
    D -->|KPSL byte stream| E[USB / TCP / LPD<br>Printer backend]
    E --> F[Kyocera Printer<br>FS-1020MFP / FS-1040 / ...]
```

### Build System

```mermaid
flowchart TD
    A[cmake --preset clang<br>configure] --> B[cmake --build --preset clang<br>build]
    B --> C[cpack --preset clang<br>DEB / RPM / TGZ]
    B --> D[cmake --install build/clang]
    D --> E[lib/cups/filter/rastertokpsl*]
    D --> F[share/cups/model/Kyocera/English/*.ppd]
    D --> G[share/doc · share/applications · lib/cmake]
```

---

## Notice

Kyocera Document Solutions Inc. has transitioned to a universal driver model and cloud-centric print solutions. Legacy per-model PPD download endpoints are no longer maintained.

| Evidence | Source |
|---|---|
| Kyocera models supporting universal print | [KYOCERA — Universal Print](https://www.kyoceradocumentsolutions.com/support/universal_print/) |
| Global download portal (consolidated packages) | [KYOCERA Global Download](https://global.kyocera.com/support/download/) |
| Legacy PPD archive (OpenPrinting) | [OpenPrinting — Kyocera PPD Archive](https://www.openprinting.org/download/PPD/Kyocera/en/) |

Because upstream no longer maintains legacy download infrastructure, automated PPD fetching is disabled by default (`DOWNLOAD_PPDS=OFF`). The default build path uses the bundled `ppd/English/` directory.

---

## References

- [CMake — Presets](https://cmake.org/cmake/help/latest/manual/cmake-presets.7.html)
- [CMake — Installing and Testing](https://cmake.org/cmake/help/latest/guide/tutorial/Installing%20and%20Testing.html)
- [SDB: Using Your Own Filters to Print with CUPS](https://en.opensuse.org/SDB:Using_Your_Own_Filters_to_Print_with_CUPS)
- [KYOCERA — Models Supporting Universal Print](https://www.kyoceradocumentsolutions.com/support/universal_print/)
- [KYOCERA Global Download & Support Portal](https://global.kyocera.com/support/download/)
- [OpenPrinting — Kyocera PPD Archive](https://www.openprinting.org/download/PPD/Kyocera/en/)

---

## License

This project is licensed under the GNU General Public License v3.0. See [license](license) for the full text.
