#!/usr/bin/python3

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

# Script to flash GPT partitions from image file to device passed as command line argument.
# Run with no arguments to see usage. Supports flashing sparsed images
#

import sys
import os

SIMG2IMG="/home/jlanka/android/out/host/linux-x86/bin/simg2img"

class partitions:
    def __init__(self):
        self.first_lba = 0
        self.last_lba = 0
        self.size = 0
        self.name = ""
        self.num = 0
partition_list = []

def print_parts(fname, verbose):
    with open(fname, "rb") as fp:
        fdata = fp.read()
    os.system("sudo rm "+fname)
    if (fdata[446:462][4] == 0xEE):
        off = 0x200
        if (verbose == 1):
            print("Signature:", fdata[off:off+8].decode())
            print("GPT Rev:",str(fdata[off+8:off+12]))
            print("Header size:",int.from_bytes(fdata[off+12:off+16], byteorder='little'))
            print("CRC32:"+str(fdata[off+16:off+20]))
            print("Reserved:"+str(fdata[off+20:off+24]))
            print("Current LBA:",int.from_bytes(fdata[off+24:off+32], byteorder='little'))
            print("Backup LBA:",int.from_bytes(fdata[off+32:off+40], byteorder='little'))
            print("First usable LBA:",int.from_bytes(fdata[off+40:off+48], byteorder='little'))
            print("Last usable LBA:",int.from_bytes(fdata[off+48:off+56], byteorder='little'))
            print("Disk GUID:",hex(int.from_bytes(fdata[off+56:off+72], byteorder='little')))
            print("Start of partition entries LBA:",int.from_bytes(fdata[off+72:off+80], byteorder='little'))
            print("Number of partition entries:",int.from_bytes(fdata[off+80:off+84], byteorder='little'))
            print("Size of partition entries:",int.from_bytes(fdata[off+84:off+88], byteorder='little'))
            print("CRC32 of partition array:"+str(fdata[off+88:off+92]))
            print("Partitions:")
            print("-"*30)
        nump = int.from_bytes(fdata[off+80:off+84], byteorder='little')
        lba = int.from_bytes(fdata[off+72:off+80], byteorder='little')+1
        psize = int.from_bytes(fdata[off+84:off+88], byteorder='little')
        off = 0x400
        if ("".join([chr(i) for i in fdata[off:off+8] if (i != 0)]) == "EFI PART"):
            if (verbose == 1):
                print("Signature:", fdata[off:off+8].decode())
                print("GPT Rev:",str(fdata[off+8:off+12]))
                print("Header size:",int.from_bytes(fdata[off+12:off+16], byteorder='little'))
                print("CRC32:"+str(fdata[off+16:off+20]))
                print("Reserved:"+str(fdata[off+20:off+24]))
                print("Current LBA:",int.from_bytes(fdata[off+24:off+32], byteorder='little'))
                print("Backup LBA:",int.from_bytes(fdata[off+32:off+40], byteorder='little'))
                print("First usable LBA:",int.from_bytes(fdata[off+40:off+48], byteorder='little'))
                print("Last usable LBA:",int.from_bytes(fdata[off+48:off+56], byteorder='little'))
                print("Disk GUID:",hex(int.from_bytes(fdata[off+56:off+72], byteorder='little')))
                print("Start of partition entries LBA:",int.from_bytes(fdata[off+72:off+80], byteorder='little'))
                print("Number of partition entries:",int.from_bytes(fdata[off+80:off+84], byteorder='little'))
                print("Size of partition entries:",int.from_bytes(fdata[off+84:off+88], byteorder='little'))
                print("CRC32 of partition array:"+str(fdata[off+88:off+92]))
            st = 0x600
        else:
            st = 0x400
        size = 0
        start = 0
        nump1 = 0
        while (nump):
            off = st+(start*psize)
            name = "".join([chr(i) for i in fdata[off+56:off+128] if (i != 0)])
            if (name != ""):
                nump1 += 1
                p = partitions()
                p.name = "".join([chr(i) for i in fdata[off+56:off+128] if (i != 0)])
                s = int.from_bytes(fdata[off+32:off+40], byteorder='little')
                p.first_lba = s
                e = int.from_bytes(fdata[off+40:off+48], byteorder='little')
                p.last_lba = e
                p.size = (e-s+1)*512
                size += p.size
                p.num = nump1
                partition_list.append(p)
                if (verbose == 1):
                    print("Partition number:",p.num)
                    print("Partition name:",p.name)
                    print("Partition type GUID:",hex(int.from_bytes(fdata[off:off+16], byteorder='little')))
                    print("Unique partition GUID:",hex(int.from_bytes(fdata[off+16:off+32], byteorder='little')))
                    print("First LBA:",hex(s))
                    print("Last LBA:",hex(e))
                    print("Size:",hex(e-s+1), "blocks")
                    print("Size:",p.size, "bytes")
                    print("Attribute flags:"+str(fdata[off+48:off+56]))
                    print("-"*30)
            start += 1
            nump -= 1
        if (verbose == 1):
            print(nump1,"Partitions totalling",size,"bytes")
        return 0
    else:
        print("GPT Not found")
        return 1

def write_part(p, filename):
    print("Partition:",p.name)
    print("Size:",p.size)
    print("Num:",p.num)
    fsz = os.path.getsize(filename)
    if (fsz <= p.size):
        # check if this is a sparse file
        r = os.system(SIMG2IMG+" "+filename+" "+filename+".raw 2>/dev/null")
        if (r != 0):
            os.remove(filename+".raw")
            os.system("sudo dd if="+filename+" of="+devname+str(p.num)+" bs=512")
        else:
            #print("Sparse file")
            os.system("sudo dd if="+filename+".raw of="+devname+str(p.num)+" conv=sparse bs=512")
            os.remove(filename+".raw")
        return 0
    else:
        print("File too big for the partition")
        return 1

def read_part(p, filename):
    print("Partition:",p.name)
    print("Size:",p.size)
    print("Num:",p.num)
    os.system("sudo dd if="+devname+str(p.num)+" of="+filename+" bs=512 conv=sparse")

if __name__ == "__main__":
    if (len(sys.argv) == 5 or len(sys.argv) == 3):
        devname = sys.argv[1]
        oper = sys.argv[2]
        if (oper == "print"):
            r = os.system("sudo dd if="+devname+" of=gpt.bin count=64")
            if (r == 0):
                print_parts("gpt.bin", 1)
        else:
            partname = sys.argv[3]
            filename = sys.argv[4]
            if (partname == "gpt"):
                p1 = partitions()
                p1.first_lba = 0
                p1.size = (34*1024)
                p1.name = "gpt"
                if (oper == "write"):
                    write_part(p1, filename)
                else:
                    read_part(p1, filename)
            else:
                r = os.system("sudo dd if="+devname+" of=gpt.bin count=64")
                if (r == 0):
                    if (print_parts("gpt.bin", 0) == 0):
                        found=0
                        for p in partition_list:
                            if (p.name == ""):
                                continue
                            if (partname == p.name):
                                found=1
                                if (oper == "write"):
                                    write_part(p, filename)
                                else:
                                    read_part(p, filename)
                                break
                if (found == 0):
                    print("Partition not found, check the name and try again")
    else:
        print("Usage:sudo <py> <device> read <partname> <file>")
        print("Usage:sudo <py> <device> write <partname> <file>")
        print("Usage:sudo <py> <device> print")
        print("<device> must be root of the device e.g. /dev/sda not partitions like sda1")

