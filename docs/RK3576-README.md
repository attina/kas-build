# RK3576 Yocto Build Environment

This document covers RK3576 platform boards maintained in this repository:

- `ok3576`
- `rk3576acp`

The build system is based on Yocto and Kas. RK3576 board support is provided through the Rockchip related layers and Picocom metadata.

## Build

### Get the Source Code

```bash
git clone https://github.com/picocom-chips/kas-build.git
cd kas-build
```

### Build Images

Build the Forlinx OK3576 image:

```bash
kas build kas/rockchip/ok3576.yml
```

Build the Picocom RK3576ACP image:

```bash
kas build kas/rockchip/rk3576acp.yml
```

### Checkout Layers Only

```bash
kas checkout kas/rockchip/ok3576.yml
kas checkout kas/rockchip/rk3576acp.yml
```

### Build SDK

Build an SDK for OK3576:

```bash
kas shell kas/rockchip/ok3576.yml -c "bitbake core-image-base -c populate_sdk"
```

Build an SDK for RK3576ACP:

```bash
kas shell kas/rockchip/rk3576acp.yml -c "bitbake core-image-base -c populate_sdk"
```

### Build Extra Packages

Example:

```bash
kas shell kas/rockchip/rk3576acp.yml -c "bitbake nodejs brotli c-ares"
kas shell kas/rockchip/rk3576acp.yml -c "bitbake package-index"
```

## Flash

1. Make the target board boot into rockusb mode.
2. Connect the target board to the host PC via USB.
3. Write the image to eMMC.

### rkdeveloptool

For OK3576:

```bash
rkdeveloptool db boot.bin
rkdeveloptool wl 0x0 core-image-base-ok3576.rootfs.wic
rkdeveloptool ul boot.bin
```

For RK3576ACP:

```bash
rkdeveloptool db boot.bin
rkdeveloptool wl 0x0 core-image-base-rk3576acp.rootfs.wic
rkdeveloptool ul boot.bin
```

### upgrade_tool

For OK3576:

```bash
upgrade_tool db loader.bin
upgrade_tool wl 0x0 core-image-base-ok3576.rootfs.wic
upgrade_tool rd
```

For RK3576ACP:

```bash
upgrade_tool db loader.bin
upgrade_tool wl 0x0 core-image-base-rk3576acp.rootfs.wic
upgrade_tool rd
```

## Useful U-Boot Commands

### Erase MMC

```bash
mmc erase 0 0x80000
```

### Switch Current MMC Device to eMMC

```bash
mmc dev 0
```

### Show Partitions

```bash
mmc part
```

### List Files

```bash
ext4ls mmc 0:9 /boot
```

### Load FIT Image to RAM

```bash
ext4load mmc 0:9 0x60000000 /boot/fitImage
```

### Boot FIT Image from RAM

```bash
bootm 0x60000000
```

### Manual Boot

For OK3576:

```bash
load mmc 0:9 0x80080000 /boot/Image
load mmc 0:9 0x88000000 /boot/rk3576-forlinx-ok3576.dtb
setenv bootargs "earlycon=uart8250,mmio32,0x2ad40000,1500000 console=ttyFIQ0,1500000,earlycon rw rootwait loglevel=7"
booti 0x80080000 - 0x88000000
```

For RK3576ACP:

```bash
load mmc 0:9 0x80080000 /boot/Image
load mmc 0:9 0x88000000 /boot/rk3576-picocom-rk3576acp.dtb
setenv bootargs "earlycon=uart8250,mmio32,0x2ad40000,1500000 console=ttyFIQ0,1500000,earlycon rw rootwait loglevel=7"
booti 0x80080000 - 0x88000000
```
