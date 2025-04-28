# LS1046APSCB Yocto Build Environment (KAS)

### Build Rootfs
```
./kas-container build kas/nxp/ls1046apscb-dev.yml
```
### Build Composite Firmware (ls1046apscb)
```
./kas-container shell kas/nxp/ls1046apscb-dev.yml -c "bitbake secure-boot-qoriq"
./kas-container shell kas/nxp/ls1046apscb-dev.yml -c "bitbake qoriq-composite-firmware"
./kas-container shell kas/nxp/ls1046apscb-dev.yml -c "bitbake generate-boottgz"
```
### Build Composite Firmware (ls1046apscbc)
```
kas shell kas/nxp/ls1046apscbc-dev.yml -c "bitbake secure-boot-qoriq"
kas shell kas/nxp/ls1046apscbc-dev.yml -c "bitbake qoriq-composite-firmware"
kas shell kas/nxp/ls1046apscbc-dev.yml -c "bitbake generate-boottgz"
```
### Build Rootfs Image (ls1046apscbc)
```
kas build kas/nxp/ls1046apscbc-dev.yml
```
### Format SD card
```
./flex-installer -i pf -d /dev/sdc
```
### Install Images to SD Card
```
sudo ./flex-installer -f firmware_ls1046apscb_uboot_sdboot.img -b boot_ls1046apscb_lts_6.6.tgz -r pico-sdk-ls1046a-ls1046apscb.rootfs.tar.gz -d /dev/sdc
```
### Set Ethernet MAC Address in U-Boot
```
setenv ethaddr 9F:86:A2:50:6F:BF
```
### Boot FIT image from TFTP server
```
tftp 80000000 kernel-fsl-ls1046a-pscbc-sdk.itb
bootm 80000000#ls1046apscbc
```
### Patch for meta-qoriq layer
- patches/ls1046apscb-meta-qoriq.patch