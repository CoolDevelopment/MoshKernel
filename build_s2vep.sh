#!/bin/bash

#
#EXPORTS
#

#KERNELVERSION
export KERNELVER=1.9

#TOOLCHAINDIRECTORY
export CROSS_COMPILE=/home/cooldevelopment/android/cm11/prebuilts/gcc/linux-x86/arm/arm-cortex_a9-linux-gnueabihf/bin/arm-cortex_a9-linux-gnueabihf-


continue=0

while [ $continue -eq "0" ]; do
	echo "Do you want to build the kernel for stock(0) rom or a aosp-based(1) rom?"
	read rom
	if [ $rom -eq "0" ] || [ $rom -eq "1" ]; then 
		continue=1
		if [ $rom -eq "0" ]; then
			romfolder="stock"
		else
			romfolder="aosp-based"
		fi
	else
		echo "Wrong input!"
		sleep 2
	fi
done


#BUILD KERNEL
make mrproper
if [ $rom -eq "1" ]; then
	make aosp-mosh_s2vep_defconfig
else 
	make stock-mosh_s2vep_defconfig
fi
make -j8

#MAKE FLASHABLE ZIP
if [ $rom -eq "1" ]; then
	cp arch/arm/boot/zImage build_zip/"$romfolder"/kernel/zImage
else
	cp arch/arm/boot/zImage build_zip/"$romfolder"/zImage
fi

if [ ! -d build_zip/"$romfolder"/system/lib/modules ]; then
	mkdir build_zip/"$romfolder"/system/lib/modules
fi

cp drivers/net/wireless/bcmdhd/dhd.ko build_zip/"$romfolder"/system/lib/modules/dhd.ko
cp drivers/scsi/scsi_wait_scan.ko build_zip/"$romfolder"/system/lib/modules/scsi_wait_scan.ko
cp drivers/char/broadcom/gist.ko build_zip/"$romfolder"/system/lib/modules/gist.ko
cp drivers/char/broadcom/sigmorph.ko build_zip/"$romfolder"/system/lib/modules/sigmorph.ko
cp drivers/char/frandom.ko build_zip/"$romfolder"/system/lib/modules/frandom.ko
cd build_zip
rm MoshKernel-*.zip
find . -type f \( -name *~ -name "boot.img" -name *.cpio.gz \) -exec rm {} \;


cd "$romfolder"

if [ $rom -eq "0" ]; then
	./../tools/mkbootfs ramdisk | gzip > ramdisk.cpio.gz
	./../tools/mkbootimg --kernel zImage --ramdisk ramdisk.cpio.gz --base 0xa2000000 --cmdline 'console=ttyS0,115200n8 mem=832M@0xA2000000 androidboot.console=ttyS0 vc-cma-mem=0/176M@0xCB000000' --pagesize 4096 -o boot.img
fi
	
if [ $rom -eq "1" ]; then
	zip -r ../MoshKernel-aosp-based-"$KERNELVER".zip kernel system META-INF
else 
	zip -r ../MoshKernel-stock-"$KERNELVER".zip boot.img system META-INF
fi

find . -type f \( -name *~ -name "boot.img" -name *.cpio.gz -name "zImage" \) -exec rm {} \;
