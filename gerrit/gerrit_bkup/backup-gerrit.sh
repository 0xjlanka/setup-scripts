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

DATE=`date +%F`
GERRIT_CFG_BASE=~/gerrit/
GERRIT_CFG_NAME=android_review_site
GERRIT_REPO_BASE=~/
GERRIT_REPO_NAME=repos
BKUP_DIR=~/gerrit-backup

# 1. Clear the temp dir
echo "[1/5] Clearing the temp dir"
rm -fr $GERRIT_CFG_BASE/tmp/*
# 2. Backup all Gerrit congifurations
echo "[2/5] Backingup Gerrit configuration"
tar -Jcf gerrit-cfg-$DATE.tar.xz -C $GERRIT_CFG_BASE $GERRIT_CFG_NAME
# 3. Restart the gerrit server
echo "[3/5] Restarting the gerrit server"
$GERRIT_CFG_BASE/bin/gerrit.sh restart
# 4. Backup MySQL review database
echo "[4/5] Backingup MySQL review database"
mysqldump -ugerrit2 -psecret reviewdb > reviewdb-$DATE.sql
# Restore mysql db by running: (will overwrite existing reviewdb, delete existing reviewdb before running this)
# $ mysql -ugerrit2 -psecret reviewdb < reviewdb.sql
# 5. Archive repositories
echo "[5/5] Archiving all repositories... (this will take a while)"
tar -Jcf repos-$DATE.tar.xz -C $GERRIT_REPO_BASE $GERRIT_REPO_NAME
mkdir -p $BKUP_DIR
mv *.xz $BKUP_DIR
mv reviewdb* $BKUP_DIR
echo "Backup complete"
