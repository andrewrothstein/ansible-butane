#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/coreos/butane/releases/download

# https://github.com/coreos/butane/releases/download/v0.13.1/butane-x86_64-unknown-linux-gnu

dl()
{
    local ver=$1
    local arch=$2
    local os=$3
    local dotexe=${4:-}
    local platform="${arch}-${os}"
    local lfile=$DIR/butane-${ver}-${platform}${dotexe}
    local url=$MIRROR/v${ver}/butane-${platform}${dotexe}
    if [ ! -e $lfile ]
    then
        curl -sSLf -o $lfile $url
    fi
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(sha256sum $lfile | awk '{print $1}')
}

dl_ver ()
{
    local ver=$1
    printf "  '%s':\n" $ver
    dl $ver aarch64 apple-darwin
    dl $ver aarch64 unknown-linux-gnu
    dl $ver ppc64le unknown-linux-gnu
    dl $ver s390x unknown-linux-gnu
    dl $ver x86_64 apple-darwin
    dl $ver x86_64 pc-windows-gnu .exe
    dl $ver x86_64 unknown-linux-gnu
}

dl_ver ${1:-0.17.0}
