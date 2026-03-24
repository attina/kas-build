# OK3576 Yocto Build Environment
The build system of ok3576 is mainly based on Yocto and Kas build system. The bitbake layer of RK3576 is from rockchip chip open source project.
## Build
### Get the source code
```bash
git clone https://github.com/picocom-chips/kas-build.git
```
### Build the ok3576 image
```bash
cd kas-build
kas build kas/rockchip/ok3576.yml
```
```
kas checkout kas/rockchip/ok3576.yml
```
### Build SDK for The OK3576 board
If you want to use the aarch64 cross compiler out of the docker environment, you can build a SDK of ok3576 board and use it in any Linux Distributions.
```
kas shell kas/rockchip/ok3576.yml -c "bitbake core-image-minimal -c populate_sdk"
```
### Flash Images to the board
1. Make target board boot into rockusb mode;
2. Connect target to Host PC via USB;
3. Write the image to the eMMC with tool command;
- use download boot command to make target init DRAM and run usbplug;
```
rkdeveloptool db boot.bin
```
- use wl command to write image to target, this step can be repeat for many times;
```
rkdeveloptool wl 0x0 core-image-minimal-ok3576.rootfs.wic
```
- usb ul command to write idbloader into idb from rockchip loader (not sure whether this is ok)
```
rkdeveloptool ul boot.bin
```
### Erase MMC in Boot
```
mmc erase 0 0x80000
```
### Useful u-boot Command line
- Switch current mmc device to eMMC
```
mmc dev 0
```
- Show partitions
```
mmc part
```
- List files in part and folder
```
ext4ls mmc 0:9 /boot
```
- Load FIT image to RAM
```
ext4load mmc 0:9 0x60000000 /boot/fitImage
```
- Boot from RAM
```
bootm 0x60000000
```