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

# echo ${port}

esptool.py --chip esp32 --port /dev/${port} --baud 921600 --before default_reset --after no_reset write_flash -z \
--flash_mode dio --flash_freq 80m --flash_size detect \
0x1000 bootloader.bin \
0xf000 phy_init_data.bin \
0x10000 MicroPython.bin \
0x8000 partitions_mpy.bin \
0x170000 spiffs_image_0x170000.img
