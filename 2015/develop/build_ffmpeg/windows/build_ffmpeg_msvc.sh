#!/bin/sh

#author:Matthew Xu(mxu@outlook.com)
<<COMMENT1
how to use this script?
1) copy this script to the root folder of ffmpeg project
2) ./build_ffmpeg_msvc rebuild x86 debug
3) after dozens of minutes(depends your PC), if build successful, the final binary/lib/header files will copy to output folder 
COMMENT1

echo -n praparing to build the ffmpeg by the follow command line: $0 

for arg in $@; do
    echo -n " -$arg" 
done

echo

arch=x86
archdir=${arch}
clean_build=false
build=release

for arg in $*; do
    case ${arg} in
        x86)
            arch=x86
            ;;
        x64 | amd64)
            arch=x86_64
            ;;
        quick)
            clean_build=false
            ;;
        rebuild)
            clean_build=true
            ;;
        debug)
            build=debug
            ;;
        release)
            build=release
            ;;
        *)
            echo "unknow parameters! $arg"
    esac
done

echo ---------------------------------
echo the final valid configuration is:
echo arch is $arch
echo build is $build
echo clean_build is $clean_build
echo ---------------------------------

make_dirs() (
  if [ ! -d output/bin/${arch}/${build} ]; then
    mkdir -p output/bin/${arch}/${build}
  fi

  if [ ! -d output/lib/${arch}/${build} ]; then
    mkdir -p output/lib/${arch}/${build}
  fi

  if [ ! -d output/include ]; then
    mkdir -p output/include
  fi

  if [ ! -d output/include/libavcodec ]; then
    mkdir output/include/libavcodec
  fi

  if [ ! -d output/include/libavdevice ]; then
    mkdir output/include/libavdevice
  fi

  if [ ! -d output/include/libavformat ]; then
    mkdir output/include/libavformat
  fi

  if [ ! -d output/include/libavfilter ]; then
    mkdir output/include/libavfilter
  fi 
)

copy_headers() (
    # copy libavcodec headers
    cp libavcodec/avcodec.h output/include/libavcodec/

    # copy libavformat headers
    cp libavformat/avformat.h output/include/libavformat/

    # copy libswscale headers
    # cp libswscale/swscale.h output/include/libswscale/
)

copy_binary()(
  cp ./*.exe output/bin/${arch}/${build}
)

copy_to_output() (
  cp lib*/*.dll output/bin/${arch}/${build}
  cp lib*/*.pdb output/bin/${arch}/${build}
  cp lib*/*.lib output/lib/${arch}/${build}

  #copy_binary
  #copy_headers
)

clean() (
  make distclean > /dev/null 2>&1
)

configure_debug()(
  OPTIONS="
  --enable-shared                   \
  --disable-static                  \
  --enable-debug                    \
  --enable-version3                 \
  --disable-doc                     \
  --arch=${arch}
  "

  EXTRA_CFLAGS="-D_WIN32_WINNT=0x0601 -DWINVER=0x0601 -d2Zi+ -MDd -Od"
  EXTRA_LDFLAGS="-NODEFAULTLIB:libcmt"

  sh configure --toolchain=msvc --extra-cflags="${EXTRA_CFLAGS}" --extra-ldflags="${EXTRA_LDFLAGS}" ${OPTIONS}
)

configure() (
  OPTIONS="
    --enable-shared                 \
    --disable-static                \
    --enable-version3               \
    --enable-w32threads             \
    --disable-everything            \
    --disable-programs              \
    --enable-encoder=ac3            \
    --enable-decoder=ac3            \
    --enable-decoder=eac3           \
    --enable-decoder=dca            \
    --disable-filters               \
    --disable-protocols             \
    --enable-protocol=file          \
    --enable-protocol=pipe          \
    --enable-protocol=http          \
    --disable-muxers                \
    --disable-hwaccels              \
    --disable-avdevice              \
    --disable-postproc              \
    --disable-swresample            \
    --disable-bsfs                  \
    --disable-devices               \
    --disable-programs              \
    --enable-debug                  \
    --disable-doc                   \
    --arch=${arch}"

  EXTRA_CFLAGS="-D_WIN32_WINNT=0x0601 -DWINVER=0x0601 -d2Zi+ -MT -O2"
  EXTRA_LDFLAGS="-NODEFAULTLIB:libc.lib -NODEFAULTLIB:msvcrt.lib -NODEFAULTLIB:libcd.lib -NODEFAULTLIB:libcmtd.lib -NODEFAULTLIB:msvcrtd.lib"

  sh configure --toolchain=msvc --extra-cflags="${EXTRA_CFLAGS}" --extra-ldflags="${EXTRA_LDFLAGS}" ${OPTIONS}
)

build() (
  make -j8
)

if [ $build = "debug" ]; then
    echo Building ffmpeg in MSVC Debug config...
else
    echo Building ffmpeg in MSVC Release config...
fi

make_dirs

start_time=$(date +%s)

if $clean_build ; then
    clean
    echo "run ./configure .... current time : $(date +%Y-%m-%d' '%T)"

    ## run configure, redirect to file because of a msys bug
    if [ $build = "debug" ]; then
      configure_debug > config.out 2>&1
    else
      configure > config.out 2>&1
    fi

    CONFIGRETVAL=$?

    ## show configure output
    cat config.out
fi

## Only if configure succeeded, actually build
if ! $clean_build || [ ${CONFIGRETVAL} -eq 0 ]; then
  build &&
  copy_to_output
fi

end_time=$(date +%s)
cost_time=$((${end_time}-${start_time}))

echo "finish the ffmpeg building, cost:$cost_time seconds!...current time : $(date +%Y-%m-%d' '%T)"
