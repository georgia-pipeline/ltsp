FROM georgiapipeline/ltsp-base as basesystem

ARG DEBIAN_FRONTEND=noninteractive

# Prepare base system
RUN debootstrap --arch amd64 xenial /opt/ltsp/amd64

# Install updates
RUN echo "\
      deb http://archive.ubuntu.com/ubuntu xenial main restricted universe multiverse\n\
      deb http://archive.ubuntu.com/ubuntu xenial-updates main restricted universe multiverse\n\
      deb http://archive.ubuntu.com/ubuntu xenial-security main restricted universe multiverse" \
      > /opt/ltsp/amd64/etc/apt/sources.list \
 && ltsp-chroot apt-get -y update \
 && ltsp-chroot apt-get -y upgrade

# Installing LTSP-packages
RUN ltsp-chroot apt-get -y install ltsp-client-core

# Apply initramfs patches
# 1: Read params from /etc/lts.conf during the boot (#1680490)
# 2: Add support for PREINIT variables in lts.conf
ADD /patches /patches
RUN patch -p4 -d /opt/ltsp/amd64/usr/share < /patches/feature_initramfs_params_from_lts_conf.diff \
 && patch -p3 -d /opt/ltsp/amd64/usr/share < /patches/feature_preinit.diff

# Write new local client config for boot NBD image to ram:
RUN echo "[Default]\nLTSP_NBD_TO_RAM = true" \
      > /opt/ltsp/amd64/etc/lts.conf

# Install packages
RUN echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' \
      >> /opt/ltsp/amd64/etc/apt/apt.conf.d/01norecommend \
 && ltsp-chroot apt-get -y install \
      software-properties-common \
      apt-transport-https \
      ca-certificates \
      ssh \
      bridge-utils \
      pv \
      jq \
      vlan \
      bash-completion \
      screen \
      vim \
      mc \
      lm-sensors \
      htop \
      jnettop \
      rsync \
      curl \
      wget \
      tcpdump \
      arping \
      apparmor-utils \
      nfs-common \
      telnet \
      sysstat \
      ipvsadm \
      ipset \
      make

# Install kernel
RUN ltsp-chroot apt-get -y install linux-generic-hwe-16.04
