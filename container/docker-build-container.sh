#! /bin/bash

cd `dirname $0`

arch="`arch`"
tag=
platform=
while test "$#" -ne 0; do
    if test "$1" = "-a" -o "$1" = "--arm" -o "$1" = "--arm64"; then
        if test "`arch`" = "arm64" -o "`arch`" = "aarch64"; then
            platform=linux/arm64
            shift
        else
            echo "\`docker-build-container.sh --arm\` only works on ARM64 hosts" 1>&2
            exit 1
        fi
    elif test "$1" = "-x" -o "$1" = "--x86-64" -o "$1" = "--x86_64" -o "$1" = "--amd64"; then
        platform=linux/amd64
    else
        armtext=
        if test "`arch`" = "arm64" -o "`arch`" = "aarch64"; then
            armtext=" [-a|--arm] [-x|--x86-64]"
        fi
        echo "Usage: docker-build-container.sh$armtext" 1>&2
        exit 1
    fi
done
if test -z "$platform" -a \( "$arch" = "arm64" -o "$arch" = "aarch64" \); then
    platform=linux/arm64
elif test -z "$platform"; then
    platform=linux/amd64
fi
if test -z "$tag" -a "$platform" = linux/arm64; then
    tag=cs1670:arm64
elif test -z "$tag"; then
    tag=cs1670:latest
fi

if test $platform = linux/arm64; then
    exec docker build -t "$tag" -f Dockerfile.arm64 --platform linux/arm64 .
else
    exec docker build -t "$tag" -f Dockerfile --platform linux/amd64 .
fi
