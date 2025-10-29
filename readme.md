# Kyocera Reverse Engineered `rastertokpsl` – Modern CMake Project

## Overview

This repository delivers a reverse-engineered Kyocera filter solution for Linux printing environments. It includes:

- C++23/C23 entry for reconstructed `rastertokpsl` (Kyocera raster filter)
- Automated CMake build and install system
- ppd files, filter binaries, and installation scripts in cmake

**Supported:**

- x86_64 Linux
- CUPS print servers (requires `libcups`/`cups-devel`)

**limitations**

possible problems with page type changes (vertical/horizontal), so for full support use proprietary driver with flags order fix. Current driver messes the argument order passed to filter, so setting option to install proprietary drivers will install a fixed version.

## Supported Models

This driver package provides PPDs and filter support for the following Kyocera printers:

- Kyocera FS-1020MFP GDI
- Kyocera FS-1025MFP GDI
- Kyocera FS-1040 GDI
- Kyocera FS-1060DN GDI
- Kyocera FS-1120MFP GDI
- Kyocera FS-1125MFP GDI

**Tested:**

- Kyocera FS-1020MFP.

## Quick Start

### Prerequisites

- Fedora, Ubuntu, or any modern Linux with CUPS
- `cmake` (≥3.25 recommended)
- ninja generator
- `g++` (C++23) and `gcc` (C23) / `clang++` and `clang`
- `libstdc++` and `libstdc++-devel`
- CUPS dev headers: 
  Fedora: `sudo dnf install cups-devel`  
  Ubuntu: `sudo apt install libcups2-dev`

### Build & Install

```sh
# 1. Clone the repo
git clone https://github.com/e-gleba/kyocera-drivers.git
cd kyocera-drivers

# 2. Configure
cmake --preset gcc
# or
cmake --preset clang

# 3. Build
cmake --build --preset gcc
# or
cmake --build --preset clang

# 4. Build everything
cmake --build . --parallel

# 5. Install (requires root for system-wide)
sudo cmake --install build/release --prefix=/usr
```

### Components

To install only runtime:

```sh
cmake --install build --component runtime
```

To install only devel:

```sh
cmake --install build --component devel
```

### Uninstall

CMake tracks all installed files in `install_manifest.txt`. To uninstall:

```sh
cd build
sudo xargs rm < install_manifest.txt
```

Or use the provided uninstall target if available:

```sh
sudo cmake --build . --target uninstall
```

_(If not present, see [CMake uninstall recipe] for adding this target.)_

## Usage

After installation, CUPS will recognize the new Kyocera PPDs and filters.  
Add a printer via CUPS web UI or `lpadmin`, selecting the installed Kyocera driver.

To test the filter directly:

```sh
build/rastertokpsl <args>
```

See `--help` for argument details.

---

## Troubleshooting

- Ensure `/usr/share/cups/model/Kyocera` and `/usr/lib/cups/filter` are writable for install.
- Missing dependencies? Install `cups-devel` and CMake.
- Use `cmake --build . --verbose` for detailed build logs.
- For filter debugging, check `/var/log/cups/error_log`.

## License

This project is licensed under the GNU GENERAL PUBLIC LICENSE v2. See [LICENSE](LICENSE).

## References

- [CMake Install & Uninstall Guide](https://cmake.org/cmake/help/latest/guide/tutorial/Installing%20and%20Testing.html)
- [CUPS Filter Integration](https://en.opensuse.org/SDB:Using_Your_Own_Filters_to_Print_with_CUPS)
- [Ghidra Reverse Engineering](https://ghidra-sre.org/)
- [Original Repo](https://github.com/sv99/rastertokpsl-re?tab=readme-ov-file)
