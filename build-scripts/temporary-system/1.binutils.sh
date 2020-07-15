#!/bin/bash

cd $LFS/sources

mkdir -v staging || exit 1
cd staging || exit 1

tar -xJf ../binutils-2.34.tar.xz || exit 1

cd binutils-2.34 || exit 1
mkdir -v build || exit 1
cd build || exit 1

time { \
    ../configure --prefix=/tools \
    --with-sysroot=$LFS \
    --with-lib-path=/tools/lib \
    --target=$LFS_TGT \
    --disable-nls \
    --disable-werror;
}

if [ $? -ne 0 ]
then
    exit 1
fi

make || exit 1

case $(uname -m) in
    x86_64)
        mkdir -v /tools/lib && ln -sv /tools/lib /tools/lib64
        ;;
esac

make install || exit 1

cd $LFS/sources || exit 1
rm -rvf staging
