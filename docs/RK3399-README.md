# RK3399 Yocto Build Environment

This document covers RK3399 platform boards maintained in this repository:

- `scb600`
- `scb605`

The build system is based on Yocto and Kas. RK3399 board support is provided through the Rockchip related layers and Picocom metadata.

## Build

### Get the Source Code

```bash
git clone https://github.com/picocom-chips/kas-build.git
cd kas-build
```

### Build Images

Build the SCB600 image:

```bash
kas build kas/rockchip/scb600.yml
```

Build the SCB605 image:

```bash
kas build kas/rockchip/scb605.yml
```

### Checkout Layers Only

```bash
kas checkout kas/rockchip/scb600.yml
kas checkout kas/rockchip/scb605.yml
```

### Images Created by the Build System

The final images are available under `build/latest` after the build completes.

## Flash

SCB600 and SCB605 can boot from SD card. Create a bootable SD card with `SDDiskTool` from the RK3399 SDK package.

![SDDiskTool](https://github.com/picocom-chips/kas-build/assets/149779491/3fd1e1f3-b4c6-4151-8bba-f1eb7268960a)

## Customization

### Kernel Source

The local Linux kernel source can be found under the shared work directory after running the build. For example:

```text
build/tmp/work-shared/scb600/kernel-source
build/tmp/work-shared/scb605/kernel-source
```

### Build SDK

Build an SDK for SCB600:

```bash
kas shell kas/rockchip/scb600.yml -c "bitbake core-image-base -c populate_sdk"
```

Build an SDK for SCB605:

```bash
kas shell kas/rockchip/scb605.yml -c "bitbake core-image-base -c populate_sdk"
```

### Build Extra Packages

Example:

```bash
kas shell kas/rockchip/scb600.yml -c "bitbake vpp-core"
kas shell kas/rockchip/scb600.yml -c "bitbake package-index"
```
