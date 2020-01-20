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

# Converts errno <-> errname

import errno
import os
import sys

def printerr(i):
    print(i,errno.errorcode[i],os.strerror(i), sep=" - ")

if len(sys.argv) == 1:
    for i in errno.errorcode:
        printerr(i)
else:
    if (sys.argv[1].upper().startswith("E")):
        ev = [(y,x) for (x,y) in list(errno.errorcode.items())]
        edict = dict(ev)
        s = sys.argv[1].upper()
        if (s in edict): 
            i = edict[s]
            printerr(i)
        else:
            print("Invalid error:",sys.argv[1])
            for j in ev:
                if (j[0].startswith(s)):
                    i = j[1]
                    printerr(i)
    elif (sys.argv[1].isdigit()):
        i = abs(int(sys.argv[1]))
        if (i in errno.errorcode):
            printerr(i)
        else:
            print("Unknown error code",i)
    else:
        print("Invalid error:",sys.argv[1])
        print("Usage: errlist.py <ARG>")
        print("\tNumeric <ARG> - Returns the error code details")
        print("\tString <ARG> of the format E* - Returns the error string details")

