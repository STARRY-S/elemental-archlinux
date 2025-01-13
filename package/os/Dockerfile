ARG ELEMENTAL_TOOLKIT
ARG ELEMENTAL_REGISTER

FROM ${ELEMENTAL_REGISTER} as register
FROM ${ELEMENTAL_TOOLKIT} as toolkit

# OS base image of our choice
FROM library/archlinux as OS

ARG RANCHER_SYSTEM_AGENT_VERSION
ARG PACMAN_MIRROR_LIST="Server = https://mirrors.bfsu.edu.cn/archlinux/\$repo/os/\$arch"

# Comfigure pacman mirror
RUN echo ${PACMAN_MIRROR_LIST} > /etc/pacman.d/mirrorlist && \
    pacman -Syy --noconfirm

# Install kernel, useful tools
RUN ARCH=$(uname -m); \
    [[ "${ARCH}" == "aarch64" ]] && ARCH="arm64"; \
    pacman -S --noconfirm \
        base linux linux-firmware \
        grub \
        openssh \
        dosfstools \
        zsh zsh-syntax-highlighting zsh-autosuggestions \
        vim neovim git openbsd-netcat \
        sudo man-db htop wget \
        dmidecode \
        neofetch \
        lm_sensors \
        net-tools traceroute \
        btrfs-progs \
        bind \
        ethtool \
        bc \
        age

# Add system files
# COPY framework/files/ /

# Add elemental-register
COPY --from=register /usr/sbin/elemental-register /usr/sbin/elemental-register
COPY --from=register /usr/sbin/elemental-support /usr/sbin/elemental-support
# Add the elemental cli
COPY --from=toolkit /usr/bin/elemental /usr/bin/elemental

# Add the elemental-system-agent
ADD --chmod=0755 https://github.com/rancher/system-agent/releases/download/${RANCHER_SYSTEM_AGENT_VERSION}/rancher-system-agent-amd64 /usr/sbin/elemental-system-agent

# Enable essential services
RUN systemctl enable systemd-networkd.service

# Generate initrd with required elemental services
RUN elemental init --debug --force

# Update os-release file with some metadata
RUN echo TIMESTAMP="`date +'%Y%m%d%H%M%S'`" >> /etc/os-release && \
    echo GRUB_ENTRY_NAME=\"Elemental ArchLinux DEV\" >> /etc/os-release

# Good for validation after the build
CMD /bin/bash
