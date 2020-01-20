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

# Create a local repo from a remote repo and setup gerrit access

import os
import shutil
from xml.dom import minidom

## remote xml
MANIFEST_NAME = "OpenQ_apq8084_1.2.xml"
## remote branch, where the manifest xml is located
MANIFEST_BRANCH = "OpenQ_apq8084_1.2"
## local branch
BRANCH_NAME = "OpenQ_apq8084_1.2"
#
SERVER_REPO_PATH = "/home/gerrit2/android-gitrepo/repos/"
MANIFESTS_PATH = "/home/gerrit2/android-gitrepo/manifests/"
SERVER_GIT_PATH = "git://git-repo/"
SERVER_MANIFEST_REPO = "platform/manifest.git"

LOCAL_REPO_PATH = "ssh://gerrit-server/android/"
TMP_PATH = os.getenv('PWD')+"/repo_tmp/"
MANIFEST_XML = '<?xml version="1.0" encoding="UTF-8"?>\n<manifest>\n\t<remote fetch="ssh://gerrit-server/" name="origin" review="gerrit-server:8080"/>\n\t<default remote="origin" revision="'+BRANCH_NAME+'"/>\n'
# update manifests
os.makedirs(MANIFESTS_PATH, exist_ok=False)
os.chdir(MANIFESTS_PATH)
os.system("git clone "+SERVER_GIT_PATH+SERVER_MANIFEST_REPO+" .")
os.system("git checkout -b "+BRANCH_NAME+" origin/"+MANIFEST_BRANCH)

mfile = minidom.parse(MANIFESTS_PATH+MANIFEST_NAME)
items = mfile.getElementsByTagName('default')
gRevision = ""
if (len(items) == 1):
    gRevision = items[0].attributes['revision'].value

items = mfile.getElementsByTagName('project')
print("Found:",len(items), "Projects")
j=1
os.makedirs(TMP_PATH, exist_ok=True)
for i in items:
    name = i.attributes['name'].value
    if ('path' in i.attributes):
        path = i.attributes['path'].value
    else:
        path = name
    if ('revision' in i.attributes):
        revision = i.attributes['revision'].value
        # diff between sha and branch name
        if (len(revision) != 40):
            revision = "origin/"+revision
    else:
        revision = "origin/"+gRevision
    print("\n>> [",j,"/",len(items),"] - Name:",name,"path:",path,"revision:",revision)
    j += 1
    os.system("ssh gerrit-server gerrit create-project android/"+name+".git")
    os.makedirs(TMP_PATH+name, exist_ok=False)
    if (os.path.exists(SERVER_REPO_PATH+name+".git") == False):
        os.system("git clone --mirror "+SERVER_GIT_PATH+name+".git "+SERVER_REPO_PATH+name+".git")
    else:
        os.chdir(SERVER_REPO_PATH+name+".git")
        os.system("git remote update")
    os.chdir(TMP_PATH+name)
    os.system("git clone "+SERVER_REPO_PATH+name+".git .")
    os.system("git checkout -b "+BRANCH_NAME+" "+revision)
    os.system("git remote add temp "+LOCAL_REPO_PATH+name+".git")
    r = 1
    # Keep pushing till no error
    while (r):
        r = os.system("git push temp --set-upstream "+BRANCH_NAME)
    os.chdir(TMP_PATH)
    shutil.rmtree(TMP_PATH+name)
    if (i.getElementsByTagName('copyfile')):
        MANIFEST_XML += '\t<project name="android/'+name+'" path="'+path+'" revision="'+BRANCH_NAME+'">\n'
        n = len(i.getElementsByTagName('copyfile'))
        m = 0
        while(n):
            MANIFEST_XML += '\t\t'+i.getElementsByTagName('copyfile')[m].toxml()+'\n'
            m += 1
            n -= 1
        MANIFEST_XML += '\t</project>\n'
    else:
        MANIFEST_XML += '\t<project name="android/'+name+'" path="'+path+'" revision="'+BRANCH_NAME+'"/>\n'
    print("--------------------------------------------------------------")
MANIFEST_XML+='</manifest>\n'
#manifest
print(">> [ Manifest repository ]")
os.system("ssh gerrit-server gerrit create-project android/manifest.git")
os.makedirs(TMP_PATH+"manifest", exist_ok=False)
os.chdir(TMP_PATH+"manifest")
os.system("git clone "+LOCAL_REPO_PATH+"manifest.git .")
r = os.system("git checkout -b "+BRANCH_NAME+" origin/"+BRANCH_NAME)
if (r != 0):
    os.system("git checkout -b "+BRANCH_NAME)
with open('default.xml', 'w') as f:
    print(MANIFEST_XML, file=f)
os.system("git add default.xml")
os.system('git commit -m "'+BRANCH_NAME+' manifest"')
os.system("git remote add temp "+LOCAL_REPO_PATH+"manifest.git")
os.system("git push temp --set-upstream "+BRANCH_NAME)
print("--------------------------------------------------------------")
print("Deleting temporary files...")
shutil.rmtree(TMP_PATH)
shutil.rmtree(MANIFESTS_PATH)
