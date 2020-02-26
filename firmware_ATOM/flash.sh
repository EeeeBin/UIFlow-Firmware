#!/bin/bash

machine=""
port=""

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=MacOS;;
    CYGWIN*)    machine=Win;;
    MINGW*)     machine=Win;;
    *)          machine=UNKNOWN
esac

# echo ${machine}

if [ "${machine}" == "Linux" ]; then
    echo "linux"
    port="ttyUSB0"
fi

if [ "${machine}" == "MacOS" ]; then
    echo "MacOS"
    port="tty.SLAB_USBtoUART"
fi

esptool.py --chip esp32 --port /dev/${port} --baud 921600 --before default_reset --after no_reset write_flash -z \
--flash_mode dio --flash_freq 40m --flash_size detect \
0x1000 bootloader_0x1000.bin \
0x8000 partitions_0x8000.bin \
0xf000 phy_init_data_0xf000.bin \
0x10000 application_0x10000.bin \
0x200000 fatfsImg_0x200000.img
