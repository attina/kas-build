# LS1046A Yocto Build Environment (KAS)
### Build Command for ls1046apscb
```
kas shell kas/nxp/ls1046apscb.yml -c "bitbake secure-boot-qoriq "
kas shell kas/nxp/ls1046apscb.yml -c "bitbake qoriq-composite-firmware"
kas shell kas/nxp/ls1046apscb.yml -c "bitbake generate-boottgz"
kas build kas/nxp/ls1046apscb.yml
# all steps in one command line
clear && kas shell kas/nxp/ls1046apscb.yml -c "bitbake secure-boot-qoriq" && kas shell kas/nxp/ls1046apscb.yml -c "bitbake qoriq-composite-firmware" && kas shell kas/nxp/ls1046apscb.yml -c "bitbake generate-boottgz" && kas build kas/nxp/ls1046apscb.yml && kas shell kas/nxp/ls1046apscb.yml -c "bitbake package-index"
```
### Build Command for ls1046apscbc
```
kas shell kas/nxp/ls1046apscbc.yml -c "bitbake secure-boot-qoriq"
kas shell kas/nxp/ls1046apscbc.yml -c "bitbake qoriq-composite-firmware"
kas shell kas/nxp/ls1046apscbc.yml -c "bitbake generate-boottgz"
kas build kas/nxp/ls1046apscbc.yml
# all steps in one command line
clear && kas shell kas/nxp/ls1046apscbc.yml -c "bitbake secure-boot-qoriq" && kas shell kas/nxp/ls1046apscbc.yml -c "bitbake qoriq-composite-firmware" && kas shell kas/nxp/ls1046apscbc.yml -c "bitbake generate-boottgz" && kas build kas/nxp/ls1046apscbc.yml && kas shell kas/nxp/ls1046apscbc.yml -c "bitbake package-index"
```
### Build Command for ls1046apxcp
```
kas shell kas/nxp/ls1046apxcp.yml -c "bitbake secure-boot-qoriq"
kas shell kas/nxp/ls1046apxcp.yml -c "bitbake qoriq-composite-firmware"
kas shell kas/nxp/ls1046apxcp.yml -c "bitbake generate-boottgz"
kas build kas/nxp/ls1046apxcp.yml
# all steps in one command line
clear && kas shell kas/nxp/ls1046apxcp.yml -c "bitbake secure-boot-qoriq" && kas shell kas/nxp/ls1046apxcp.yml -c "bitbake qoriq-composite-firmware" && kas shell kas/nxp/ls1046apxcp.yml -c "bitbake generate-boottgz" && kas build kas/nxp/ls1046apxcp.yml && kas shell kas/nxp/ls1046apxcp.yml -c "bitbake package-index"
```
### Build Command for ls1046apscbx5
```
kas shell kas/nxp/ls1046apscbx5.yml -c "bitbake secure-boot-qoriq"
kas shell kas/nxp/ls1046apscbx5.yml -c "bitbake qoriq-composite-firmware"
kas shell kas/nxp/ls1046apscbx5.yml -c "bitbake generate-boottgz"
kas build kas/nxp/ls1046apscbx5.yml
# all steps in one command line
clear && kas shell kas/nxp/ls1046apscbx5.yml -c "bitbake secure-boot-qoriq" && kas shell kas/nxp/ls1046apscbx5.yml -c "bitbake qoriq-composite-firmware" && kas shell kas/nxp/ls1046apscbx5.yml -c "bitbake generate-boottgz" && kas build kas/nxp/ls1046apscbx5.yml && kas shell kas/nxp/ls1046apscbx5.yml -c "bitbake package-index"
```
### Format SD card
```
./flex-installer -i pf -d /dev/sdc
```
### Install Images to SD Card
* Notes: Please change the board name when run the following command, valid board names are: ls1046apscb, ls1046apscbc, ls1046apxcp, ls1046apscbx5
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
### Set MAC Address in U-boot
```
setenv ethaddr 00:E0:0C:00:02:00
setenv eth1addr 00:E0:0C:00:02:01
setenv eth2addr 00:E0:0C:00:02:02
setenv eth3addr 00:E0:0C:00:02:03
setenv eth4addr 00:E0:0C:00:02:04
setenv eth5addr 00:E0:0C:00:02:05
setenv eth6addr 00:E0:0C:00:02:06
setenv eth7addr 00:E0:0C:00:02:07
setenv eth8addr 00:E0:0C:00:02:08
setenv eth9addr 00:E0:0C:00:02:09
setenv eth10addr 00:E0:0C:00:02:0a
setenv eth11addr 00:E0:0C:00:02:0b
setenv eth12addr 00:E0:0C:00:02:0c
setenv eth13addr 00:E0:0C:00:02:0d
setenv eth14addr 00:E0:0C:00:02:0e
setenv eth15addr 00:E0:0C:00:02:0f
```
### Enable Ethernet Device in /etc/network/interfaces
```
# for ls1046apacb
auto fm1-mac5
iface fm1-mac5 inet dhcp

# for ls1046apscbc
auto fm1-mac6
iface fm1-mac6 inet dhcp
```
### Install packages through dev netwrok
#### Set the correct system time
```
date -s "2025-07-02 15:52:00"
```
#### Install the packages
```
apt update
apt install gdb
```
#### find which package provides ldd
```
kas shell kas/nxp/ls1046apxcp.yml -c "oe-pkgdata-util lookup-recipe ldd"
```