KERNEL_DIR=/home/cooldevelopment/android/kernel/MoshKernel

obj-m := frandom.o
PWD := $(shell pwd)
default:
	$(MAKE) ARCH=arm CROSS_COMPILE=/home/cooldevelopment/android/cm11/prebuilts/gcc/linux-x86/arm/arm-linux-gnueabi/bin/arm-linux-gnueabi- -C $(KERNEL_DIR) SUBDIRS=$(PWD) modules
clean:
	$(MAKE) -C $(KERNEL_DIR) SUBDIRS=$(PWD) clean
