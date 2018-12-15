FROM ubuntu:18.04
COPY *.patch diffconfig /tmp/
RUN apt-get update && \
  apt install -y --no-install-recommends \
  build-essential \
  libncurses5-dev \
  gawk \
  git \
  subversion \
  libssl-dev \
  gettext \
  zlib1g-dev \
  swig \
  unzip \
  time \
  python \
  gnat-7 \
  sudo \
  file \
  wget \
  curl && \
  useradd -s /bin/bash -m openwrt && \
  echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt && \
  su - openwrt -c " \
    set -e ;\
    git config --global http.sslVerify false ;\
    git clone --depth 2 -b openwrt-18.06 https://github.com/openwrt/openwrt.git ;\
    cd openwrt ;\
    patch -p1 < /tmp/openwrt-enable_ada.patch ;\
    cp /tmp/955-gnat_on_musl.patch toolchain/gcc/patches/7.3.0/ ;\
    cp /tmp/diffconfig .config ;\
    ./scripts/feeds update -a ;\
    make defconfig ;\
    make -j1 toolchain/install V=w ;\
    make clean ;\
    rm -rf dl tmp build_dir ;\
    rm staging_dir/toolchain-arm_cortex-a9+vfpv3_gcc-7.3.0_musl_eabi/lib/lib ;\
  "
