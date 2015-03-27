#!/bin/sh
export ANDROID_NDK=/d/Nero/Mobile/Android/android-ndk-r10d/
SYSROOT=$ANDROID_NDK/platforms/android-17/arch-arm/
# You should adjust this path depending on your platform, e.g. darwin-x86_64 for Mac OS
TOOLCHAIN=$ANDROID_NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/windows-x86_64
CPU=arm
PREFIX=$(pwd)/android/$CPU

# Set these if needed
ADDI_CFLAGS=""
ADDI_LDFLAGS=""

function config_static {
./configure \
    --prefix=$PREFIX \
    --disable-shared \
    --enable-static \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-doc \
    --disable-symver \
    --enable-protocol=concat \
    --enable-protocol=file \
    --enable-muxer=mp4 \
    --enable-demuxer=mpegts \
    --enable-memalign-hack \
    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
    --target-os=android \
    --arch=arm \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="-Os -fpic -marm $ADDI_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS"
}

function config_shared {
./configure \
    --prefix=$PREFIX \
    --enable-shared \
    --disable-static \
    --disable-doc \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-doc \
    --disable-symver \
    --enable-protocol=concat \
    --enable-protocol=file \
    --enable-muxer=mp4 \
    --enable-demuxer=mpegts \
    --enable-memalign-hack \
    --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
    --target-os=android \
    --arch=arm \
    --enable-cross-compile \
    --sysroot=$SYSROOT \
    --extra-cflags="-Os -fpic -marm $ADDI_CFLAGS" \
    --extra-ldflags="$ADDI_LDFLAGS"
}

function build_it {
    make clean
    make
    make install
}

config_static
build_it