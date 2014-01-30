#!/bin/bash

#
#EXPORTS
#

#KERNELVERSION
export KERNELVER=1.6

#TOOLCHAINDIRECTORY
export CROSS_COMPILE=/home/cooldevelopment/android/cm11/prebuilts/gcc/linux-x86/arm/arm-linux-gnueabi/bin/arm-linux-gnueabi-

#BUILD KERNEL
make mrproper
make custom_s2vep_defconfig
make -j8

#MAKE FLASHABLE ZIP
cp arch/arm/boot/zImage build_zip/kernel/zImage
cp drivers/net/wireless/bcmdhd/dhd.ko build_zip/system/lib/modules/dhd.ko
cp drivers/scsi/scsi_wait_scan.ko build_zip/system/lib/modules/scsi_wait_scan.ko
cp drivers/char/broadcom/gist.ko build_zip/system/lib/modules/gist.ko
cp drivers/char/broadcom/sigmorph.ko build_zip/system/lib/modules/sigmorph.ko
cd build_zip
rm custom_kernel-*.zip 
zip -r custom_kernel-$KERNELVER.zip kernel system META-INF
