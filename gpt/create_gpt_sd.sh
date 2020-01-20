#!/bin/bash

# MIT License
#
# Copyright (c) 2020 Jitendra Lanka - https://github.com/0xjlanka
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Script that creates gpt partition table on the SD card device.
# WARNING: This script will wipe off the MBR.
# Pointing this to incorrect device will wipeoff the device data.

if [ $# -ne 1 ]; then
	echo "Usage: create_gpt_sd.sh <device>"
	echo "<device> must be the root device like /dev/sdX, not a partition like /dev/sdX1"
	echo "Edit the script to have the correct partition layout before running"
	exit 0
fi
DEV=$1
echo "Current partition layout on $DEV:"
sudo sgdisk -p $DEV
if [ $? -ne 0 ]; then
	exit 0
fi
echo ""
echo ""
echo "This program is going to create new GPT partition table on $DEV"
echo "Make sure that $DEV is the device for SD card"
echo "Proceed? (y/N)"
read choice
if [ "$choice" = "y" -o "$choice" = "Y" ]; then
	sudo umount $DEV* 2>/dev/null
	sudo sgdisk -og $DEV
	# create partition 1 with 16MB size, "boot3" as name 
	# and read only option set (bit 60 of attributes)
	sudo sgdisk -n 1::+16M -c 1:"boot4" -A 1:set:60 $DEV
	sudo sgdisk -n 2::+16M -c 2:"recovery" -A 2:set:60 $DEV
	sudo sgdisk -n 3::+16M -c 3:"recovery2" -A 3:set:60 $DEV
	sudo sgdisk -n 4::+32M -c 4:"persist" -A 4:set:60 $DEV
	sudo sgdisk -n 5::+32M -c 5:"persist2" -A 5:set:60 $DEV
	sudo sgdisk -n 6::+128M -c 6:"cache" -A 6:set:60 $DEV
	sudo sgdisk -n 7::+128M -c 7:"cache2" -A 7:set:60 $DEV
	sudo sgdisk -n 8::+3G -c 8:"userdata" -A 8:set:60 $DEV
	sudo sgdisk -n 9::+3G -c 9:"userdata2" -A 9:set:60 $DEV
	
	echo "New partition layout:"
	sudo sgdisk -p $DEV
	sudo umount $DEV* 2>/dev/null
fi

