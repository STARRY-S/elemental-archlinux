ARG ELEMENTAL_TOOLKIT=""
FROM $ELEMENTAL_TOOLKIT AS toolkit

# OS base image of our choice
FROM archlinux AS os

ARG RANCHER_SYSTEM_AGENT_VERSION="v0.3.11"

# Pre-install rsync
RUN pacman -Syy && \
    pacman -S --noconfirm rsync
# Add system files
COPY framework/ /
RUN rsync -a /files/* / && rm -r /files

# Install kernel & utils
RUN pacman-key --init && \
    pacman -Syu --noconfirm && \
    pacman -S --noconfirm archlinux-keyring archlinuxcn-keyring && \
    pacman -S --noconfirm \
        base linux linux-headers linux-firmware \
        grub \
        openssh \
        dosfstools \
        zsh \
        zsh-syntax-highlighting \
        zsh-autosuggestions \
        vim \
        neovim \
        git \
        openbsd-netcat \
        sudo \
        man-db \
        htop \
        wget \
        dmidecode \
        neofetch \
        lm_sensors \
        net-tools \
        traceroute \
        btrfs-progs \
        bind \
        ethtool \
        bc \
        mkinitcpio \
        rsync \
        efibootmgr \
        shim-signed \
        squashfs-tools \
        dracut \
        mtools \
        libisoburn \
        age && \
    mkdir -p /libexec/elemental-checker

RUN dracut --regenerate-all

# Add elemental-register
COPY build/elemental-operator/build/elemental-register /usr/sbin/elemental-register
COPY build/elemental-operator/build/elemental-support /usr/sbin/elemental-support
# Add the elemental-cli
COPY --from=toolkit /usr/bin/elemental /usr/bin/elemental

# Add the elemental-system-agent
ADD --chmod=0755 https://github.com/rancher/system-agent/releases/download/${RANCHER_SYSTEM_AGENT_VERSION}/rancher-system-agent-amd64 /usr/sbin/elemental-system-agent

# Enable essential services
RUN systemctl enable systemd-networkd.service
RUN mv /boot/vmlinuz-linux /boot/vmlinuz-$(uname -r)

# Init elemental system utils
RUN elemental init --debug --force

# Update os-release file with some metadata
RUN echo TIMESTAMP="`date +'%Y%m%d%H%M%S'`" >> /etc/os-release && \
    echo GRUB_ENTRY_NAME=\"Elemental ArchLinux DEV\" >> /etc/os-release

# Cleanup cache
RUN rm -r /var/cache/pacman/pkg/*

RUN mkdir -p /usr/lib/elemental/bootloader && \
    grub-mkimage -O x86_64-efi -o grubx64.efi -p '(tftp)/grub' efinet tftp && \
    mv grubx64.efi /usr/lib/elemental/bootloader/grubx64.efi && \
    cp /usr/share/shim-signed/shimx64.efi /usr/lib/elemental/bootloader/shimx64.efi && \
    cp /usr/share/shim-signed/mmx64.efi /usr/lib/elemental/bootloader/mmx64.efi

# For validation after the build
CMD /bin/bash
