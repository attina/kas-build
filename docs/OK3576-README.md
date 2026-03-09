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
rkdeveloptool wl 0x40 idbloader.img
rkdeveloptool wl 0x4000 u-boot.img
rkdeveloptool wl 0x8000 boot.bin
rkdeveloptool wl 0x40000 rootfs.img
```
- usb ul command to write idbloader into idb from rockchip loader
```
rkdeveloptool ul boot.bin
```
### Erase MMC in Boot
```
mmc erase 0 0x80000
```
