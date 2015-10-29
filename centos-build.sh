#!/bin/bash

# This script runs the Superbuild in the thewtex/centos-build docker image

die() {
  echo "Error: $@" 1>&2
  exit 1;
}

export CC=/opt/rh/devtoolset-2/root/usr/bin/gcc
export CXX=/opt/rh/devtoolset-2/root/usr/bin/g++

# yum install -y mesa-libGL-devel || die "Could not install OpenGL"

cd /usr/src/OGS-Superbuild-build || die "Could not cd into the build directory"

cmake \
  /usr/src/OGS-Superbuild || die "CMake configuration failed"
make VERBOSE=1 || die "Build failed"
