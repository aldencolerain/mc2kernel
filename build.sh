#!/bin/sh

# build kernel
cp kernel.config .config
make CROSS_COMPILE=toolchain/bin/arm-marvell-linux-gnueabi- ARCH=arm menuconfig
make CROSS_COMPILE=toolchain/bin/arm-marvell-linux-gnueabi- ARCH=arm zImage
make CROSS_COMPILE=toolchain/bin/arm-marvell-linux-gnueabi- ARCH=arm armada-375-wdmc-gen2.dtb
mkdir -p output
cat arch/arm/boot/zImage arch/arm/boot/dts/armada-375-wdmc-gen2.dtb > output/zImage_and_dtb
mkimage -A arm -O linux -T kernel -C none -a 0x00008000 -e 0x00008000 -n 'WDMC-Gen2' -d output/zImage_and_dtb output/uImage
rm output/zImage_and_dtb

# build modules
make CROSS_COMPILE=toolchain/bin/arm-marvell-linux-gnueabi- ARCH=arm modules
make CROSS_COMPILE=toolchain/bin/arm-marvell-linux-gnueabi- ARCH=arm INSTALL_MOD_PATH=output modules_install