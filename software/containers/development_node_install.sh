#!/bin/bash -ex

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential
rm -rf /var/lib/apt/lists/*

# CMake version 3.18.3
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        make \
        wget
rm -rf /var/lib/apt/lists/*
cd /
mkdir -p /var/tmp && wget -q -nc --no-check-certificate -P /var/tmp https://cmake.org/files/v3.18/cmake-3.18.3-Linux-x86_64.sh
mkdir -p /usr/local
/bin/sh /var/tmp/cmake-3.18.3-Linux-x86_64.sh --prefix=/usr/local --skip-license
rm -rf /var/tmp/cmake-3.18.3-Linux-x86_64.sh
export PATH=/usr/local/bin:$PATH

# GNU compiler
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        g++ \
        gcc \
        gfortran
rm -rf /var/lib/apt/lists/*

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libopenmpi-dev \
        openmpi-bin \
        openmpi-common
rm -rf /var/lib/apt/lists/*

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        gdb \
        strace \
        valgrind
rm -rf /var/lib/apt/lists/*

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        doxygen
rm -rf /var/lib/apt/lists/*

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libgsl-dev \
        libhdf5-dev \
        libhdf5-fortran-102 \
        liblapack-dev \
        libopenblas-dev
rm -rf /var/lib/apt/lists/*

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        jupyter-notebook \
        python3 \
        python3-numpy
rm -rf /var/lib/apt/lists/*

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        emacs \
        less \
        nano \
        vim
rm -rf /var/lib/apt/lists/*

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        git
rm -rf /var/lib/apt/lists/*

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bzip2 \
        gzip \
        tar
rm -rf /var/lib/apt/lists/*

apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        gnuplot
rm -rf /var/lib/apt/lists/*


