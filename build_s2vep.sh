#!/bin/bash

#
#EXPORTS
#

#KERNELVERSION
export KERNELVER=1.5.1

#TOOLCHAINDIRECTORY
export CROSS_COMPILE=/home/cooldevelopment/android/cm10.2/prebuilts/gcc/linux-x86/arm/arm-linux-gnueabihf-4.8/bin/arm-linux-gnueabihf-

#BUILD KERNEL
make mrproper
make custom_s2vep_defconfig
make -j8

#MAKE FLASHABLE ZIP
cp arch/arm/boot/zImage build_zip/kernel/zImage
cp drivers/net/wireless/bcmdhd/dhd.ko build_zip/system/lib/modules/dhd.ko
cd build_zip
rm custom_kernel-*.zip 
zip -r custom_kernel-$KERNELVER.zip kernel system META-INF
