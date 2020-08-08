#!/bin/sh
branch=android-8.1.0_r41

clone() {
  repo=$1
  git clone -b $branch https://mirrors.tuna.tsinghua.edu.cn/git/AOSP/platform/$repo src/$repo
}

sudo apt install cmake ninja-build golang-go -y

wget -c https://dl.google.com/android/repository/android-ndk-r17b-linux-x86_64.zip
unzip android-ndk-r17b-linux-x86_64.zip

mkdir src

mkdir src/system
clone system/core
clone system/extras

mkdir src/external
clone external/selinux
clone external/pcre
clone external/f2fs-tools
clone external/e2fsprogs
clone external/mdnsresponder
clone external/libusb

git clone https://boringssl.googlesource.com/boringssl src/boringssl

cd src/system/core
patch -p1 < ../../../99_patch_core
cd ../../..


