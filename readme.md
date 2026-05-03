# Kyocera Reverse‑Engineered `rastertokpsl` — Modern CMake Toolkit

[![CMake](https://img.shields.io/badge/CMake-%E2%89%A53.25-064F8C?logo=cmake&logoColor=white)](https://cmake.org/cmake/help/latest/release/3.25.html)
[![C++23](https://img.shields.io/badge/C%2B%2B-23-00599C?logo=c%2B%2B&logoColor=white)](https://en.cppreference.com/w/cpp/23)
[![C23](https://img.shields.io/badge/C-23-A8B9CC?logo=c&logoColor=white)](https://en.cppreference.com/w/c/23)
[![License](https://img.shields.io/badge/License-GPL--3.0-33A852?logo=gnu&logoColor=white)](./license)
[![Platform](https://img.shields.io/badge/Platform-Linux%20x86__64-FCC624?logo=linux&logoColor=black)](https://www.kernel.org/)
[![OpenPrinting Archive](https://img.shields.io/badge/OpenPrinting-PPD%20Archive-orange)](https://www.openprinting.org/download/PPD/Kyocera/en/)

> High‑performance, open‑source raster‑to‑KPSL conversion filter for legacy Kyocera printers on Linux CUPS environments.

---

## Table of Contents

- [Overview](#overview)
- [Important Notice — Kyocera Driver Model Transition](#important-notice--kyocera-driver-model-transition)
- [Supported Models](#supported-models)
- [Known Limitations](#known-limitations)
- [Prerequisites](#prerequisites)
- [Build & Install](#build--install)
- [Installation Components](#installation-components)
- [Uninstall](#uninstall)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [References & Evidence](#references--evidence)
- [License](#license)

---

## Overview

This repository delivers a fully open, reverse‑engineered Kyocera filter solution for Linux printing environments. It includes:

- Modern **C++23 / C23** source for `rastertokpsl` (Kyocera raster filter)
- Automated **CMake ≥3.25** build and install system with Ninja Multi‑Config generator
- Bundled PPD files, filter binaries, and installation scripts
- CMake workflow presets for **GCC**, **Clang**, and **MSVC** toolchains

**Supported platform:** Linux x86_64 with CUPS (requires `libcups` / `cups-devel`).

---

## Important Notice — Kyocera Driver Model Transition

**Kyocera Document Solutions Inc.** has shifted from per‑model manual PPD distribution to a **Universal Driver Model** and cloud‑centric print solutions such as [Universal Print](https://www.kyoceradocumentsolutions.com/support/universal_print/). As a direct result, the legacy automated PPD download endpoints are no longer maintained by the manufacturer.

| Evidence | Source |
|---|---|
| Kyocera officially catalogs products that natively support Universal Print | [KYOCERA — Models Supporting Universal Print](https://www.kyoceradocumentsolutions.com/support/universal_print/) |
| The global download portal no longer exposes per‑model legacy PPD APIs | [KYOCERA Global Download & Support Portal](https://global.kyocera.com/support/download/) |
| Current Linux driver packages are published as consolidated “Linux Universal Driver” releases | [KYOCERA EU — Linux Universal Driver (Phase 9.4)](https://www.kyoceradocumentsolutions.eu/en/support/downloads.name-L2V1L2VuL3ByaW50ZXJzL0VDT1NZU1AzMTU1RE4=.html) |
| Legacy PPD collections are now preserved only by the OpenPrinting archive | [OpenPrinting — Kyocera PPD Archive](https://www.openprinting.org/download/PPD/Kyocera/en/) |

Because upstream no longer maintains the legacy download infrastructure, this project **disables automated PPD downloading by default** (`DOWNLOAD_PPDS=OFF`). The default build path uses the bundled `ppd/` directory. Users who require external drivers should obtain current universal packages directly from [KYOCERA Document Solutions](https://global.kyocera.com/support/download/).

---

## Supported Models

This driver package provides bundled PPDs and filter support for the following Kyocera printers:

| Model | Type |
|---|---|
| Kyocera FS‑1020MFP | GDI |
| Kyocera FS‑1025MFP | GDI |
| Kyocera FS‑1040 | GDI |
| Kyocera FS‑1060DN | GDI |
| Kyocera FS‑1120MFP | GDI |
| Kyocera FS‑1125MFP | GDI |

**Field‑tested:** Kyocera FS‑1020MFP.

---

## Known Limitations

- **Page orientation changes** (vertical ↔ horizontal) may produce incorrect output.
- The current driver argument order does not match the proprietary reference. For full feature parity, enable `INSTALL_ORIGINAL_PROPRIETARY_DRIVERS` to install a corrected proprietary build.

---

## Prerequisites

- Fedora, Ubuntu, or any modern Linux distribution with CUPS
- `cmake` **≥3.25** (≥3.30 recommended for preset support)
- `ninja` (Ninja Multi‑Config generator)
- `g++` (C++23) and `gcc` (C23) **or** `clang++` / `clang`
- `libstdc++` and `libstdc++-devel`
- CUPS development headers

```bash
# Fedora
sudo dnf install cups-devel cmake ninja-build gcc g++ libstdc++-devel

# Ubuntu / Debian
sudo apt install libcups2-dev cmake ninja-build gcc g++ libstdc++-12-dev
```

---

## Build & Install

The project provides CMake presets for GCC, Clang, and MSVC. On Linux the supported toolchains are **GCC** and **Clang**.

### 1. Clone

```bash
git clone https://github.com/e-gleba/kyocera-drivers.git
cd kyocera-drivers
```

### 2. Configure

```bash
# GCC (recommended for Linux)
cmake --preset gcc

# LLVM Clang
cmake --preset clang
```

### 3. Build

```bash
cmake --build --preset gcc
# or
cmake --build --preset clang
```

You may also build directly against the generated tree:

```bash
cmake --build build/gcc --parallel
```

### 4. Install (system‑wide)

```bash
sudo cmake --install build/gcc --prefix /usr
```

---

## Installation Components

CMake install components are provided for selective deployment:

| Component | Command |
|---|---|
| Runtime only | `cmake --install build/gcc --component runtime` |
| Development | `cmake --install build/gcc --component devel` |

---

## Uninstall

CMake tracks installed files in `install_manifest.txt`. To remove them:

```bash
cd build/gcc
sudo xargs rm -f < install_manifest.txt
```

If the `uninstall` target is present in your build tree:

```bash
sudo cmake --build . --target uninstall
```

*(If the target is missing, see the [CMake Installing and Testing tutorial](https://cmake.org/cmake/help/latest/guide/tutorial/Installing%20and%20Testing.html) for the standard uninstall recipe.)*

---

## Usage

After installation, CUPS recognizes the bundled Kyocera PPDs and filters. Add a printer via the CUPS web UI or `lpadmin`, selecting the installed Kyocera driver.

To exercise the filter directly:

```bash
./build/gcc/rastertokpsl <args>
```

Run `--help` for argument details.

---

## Troubleshooting

| Symptom | Resolution |
|---|---|
| Installation fails with permission errors | Ensure `/usr/share/cups/model/Kyocera` and `/usr/lib/cups/filter` are writable (requires root). |
| Missing dependencies during configure | Install `cups-devel` (Fedora) or `libcups2-dev` (Ubuntu) and verify CMake is on PATH. |
| Verbose build logs needed | Append `--verbose` to the build command: `cmake --build . --verbose` |
| Filter runtime errors | Inspect `/var/log/cups/error_log` for CUPS‑level diagnostics. |

---

## References & Evidence

- [CMake Tutorial — Installing and Testing](https://cmake.org/cmake/help/latest/guide/tutorial/Installing%20and%20Testing.html)
- [SDB: Using Your Own Filters to Print with CUPS](https://en.opensuse.org/SDB:Using_Your_Own_Filters_to_Print_with_CUPS)
- [Ghidra — Software Reverse Engineering Framework](https://ghidra-sre.org/)
- [Original Reverse‑Engineering Repository](https://github.com/sv99/rastertokpsl-re)
- [KYOCERA Document Solutions — Models Supporting Universal Print](https://www.kyoceradocumentsolutions.com/support/universal_print/)
- [KYOCERA Global Download & Support Portal](https://global.kyocera.com/support/download/)
- [OpenPrinting — Kyocera Legacy PPD Archive](https://www.openprinting.org/download/PPD/Kyocera/en/)

---

## License

This project is licensed under the **GNU General Public License v3.0**. See [license](./license) for the full text.
