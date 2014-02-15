#!/bin/bash

#
#EXPORTS
#

#KERNELVERSION
export KERNELVER=1.7

#TOOLCHAINDIRECTORY
export CROSS_COMPILE=/home/cooldevelopment/android/cm11/prebuilts/gcc/linux-x86/arm/arm-linux-gnueabi/bin/arm-linux-gnueabi-

#BUILD KERNEL
make mrproper
make custom_s2vep_defconfig
make -j8

#BUILD FRANDOM MODULE
cd frandom-android
make clean
make
cd ..

#MAKE FLASHABLE ZIP
cp arch/arm/boot/zImage build_zip/kernel/zImage
cp drivers/net/wireless/bcmdhd/dhd.ko build_zip/system/lib/modules/dhd.ko
cp drivers/scsi/scsi_wait_scan.ko build_zip/system/lib/modules/scsi_wait_scan.ko
cp drivers/char/broadcom/gist.ko build_zip/system/lib/modules/gist.ko
cp drivers/char/broadcom/sigmorph.ko build_zip/system/lib/modules/sigmorph.ko
cp frandom-android/frandom.ko build_zip/system/lib/modules/frandom.ko
cd build_zip
rm MoshKernel-*.zip 
zip -r MoshKernel-$KERNELVER.zip kernel system META-INF
