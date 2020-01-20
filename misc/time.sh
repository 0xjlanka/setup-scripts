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

# Multiple timezones and times from Command line 

LCL=`date`
#VCT=`env TZ=America/Vancouver date`
SET=`env TZ=America/Los_Angeles date`
HOT=`env TZ=America/Chicago date`
TOT=`env TZ=America/Toronto date`
ADT=`env TZ=Africa/Addis_Ababa date`
SAT=`env TZ=Asia/Riyadh date`
IST=`env TZ=Asia/Kolkata date`
KST=`env TZ=Asia/Seoul date`

echo "Local  : $LCL"
#echo "Vancouver time: $VCT"
#echo "Seattle: $SET"
echo "Houston: $HOT"
echo "Toronto: $TOT"
echo "Addis  : $ADT"
echo "Riyadh : $SAT"
echo "India  : $IST"
echo "Seoul  : $KST"
