FROM georgiapipeline/ltsp-basesystem as ltsp-image

# Retrieve kernel modules
COPY --from=georgiapipeline/ltsp-builder /opt/ltsp/amd64/modules.tar.gz /opt/ltsp/amd64/modules.tar.gz

# Install kernel modules
RUN ltsp-chroot sh -c \
    ' export KERNEL="$(ls -1t /usr/src/ | grep -m1 "^linux-headers" | sed "s/^linux-headers-//g")" \
   && tar xpzf /modules.tar.gz \
   && depmod -a "${KERNEL}" \
   && rm -f /modules.tar.gz'


# Install components for baremetal base image here
#
#
#
#

# Disable automatic updates
RUN rm -f /opt/ltsp/amd64/etc/apt/apt.conf.d/20auto-upgrades

# Disable apparmor profiles
RUN ltsp-chroot find /etc/apparmor.d \
      -maxdepth 1 \
      -type f \
      -name "sbin.*" \
      -o -name "usr.*" \
      -exec ln -sf "{}" /etc/apparmor.d/disable/ \;

# Write kernel cmdline options
RUN KERNEL_OPTIONS="$(echo \
      init=/sbin/init-ltsp \
      forcepae \
      console=tty1 \
      console=ttyS0,9600n8 \
      nvme_core.default_ps_max_latency_us=0 \
    )" \
 && sed -i "/^CMDLINE_LINUX_DEFAULT=/ s|=.*|=\"${KERNEL_OPTIONS}\"|" \
      "/opt/ltsp/amd64/etc/ltsp/update-kernels.conf"


# Cleanup caches
RUN rm -rf /opt/ltsp/amd64/var/lib/apt/lists \
 && ltsp-chroot apt-get clean

# Build squashed image
RUN ltsp-update-image
