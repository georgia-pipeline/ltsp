FROM georgiapipeline/basesystem as builder

# Set cpuinfo (for building from sources)
RUN cp /proc/cpuinfo /opt/ltsp/amd64/proc/cpuinfo

# Compile Mellanox driver
RUN ltsp-chroot sh -cx \
   '  VERSION=4.3-1.0.1.0-ubuntu16.04-x86_64 \
   && curl -L http://www.mellanox.com/downloads/ofed/MLNX_EN-${VERSION%%-ubuntu*}/mlnx-en-${VERSION}.tgz \
      | tar xzf - \
   && export \
        DRIVER_DIR="$(ls -1 | grep "MLNX_OFED_LINUX-\|mlnx-en-")" \
        KERNEL="$(ls -1t /lib/modules/ | head -n1)" \
   && cd "$DRIVER_DIR" \
   && ./*install --kernel "$KERNEL" --without-dkms --add-kernel-support \
   && cd - \
   && rm -rf "$DRIVER_DIR" /tmp/mlnx-en* /tmp/ofed*'

# Save kernel modules
RUN ltsp-chroot sh -c \
    ' export KERNEL="$(ls -1t /usr/src/ | grep -m1 "^linux-headers" | sed "s/^linux-headers-//g")" \
   && tar cpzf /modules.tar.gz /lib/modules/${KERNEL}/updates'
