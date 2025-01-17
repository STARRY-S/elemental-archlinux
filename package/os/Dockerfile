ARG ELEMENTAL_TOOLKIT=""
FROM $ELEMENTAL_TOOLKIT AS toolkit

# OS base image of our choice
FROM archlinux AS os

ARG RANCHER_SYSTEM_AGENT_VERSION="v0.3.11"

COPY framework/files/etc/pacman.conf /etc/pacman.conf
COPY framework/files/etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist
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
        dracut \
        rsync \
        efibootmgr \
        shim-signed \
        squashfs-tools \
        mtools \
        amd-ucode \
        rsync \
        libisoburn \
        age && \
    mkdir -p /libexec/elemental-checker
RUN dracut --regenerate-all

# Add elemental-register
COPY build/elemental-operator/build/elemental-register /usr/sbin/elemental-register
COPY build/elemental-operator/build/elemental-support /usr/sbin/elemental-support
# Add the elemental-cli
COPY build/elemental-toolkit/build/elemental /usr/bin/elemental

# Add system files
COPY framework/ /
RUN rsync -a /files/* / && rm -r /files

# Add the elemental-system-agent
ADD --chmod=0755 https://github.com/rancher/system-agent/releases/download/${RANCHER_SYSTEM_AGENT_VERSION}/rancher-system-agent-amd64 /usr/sbin/elemental-system-agent

# Enable essential services
RUN systemctl enable systemd-networkd.service

# Workaround for elemental to determine kernel version for Arch Linux
RUN cp /boot/vmlinuz-linux /boot/Image-$(uname -r)

# Init elemental system utils
RUN elemental --debug init --force autologin boot-assessment cloud-config-defaults cloud-config-essentials dracut-config elemental-rootfs elemental-setup elemental-sysroot grub-config

# Update os-release file with some metadata
RUN echo TIMESTAMP="`date +'%Y%m%d%H%M%S'`" >> /etc/os-release && \
    echo GRUB_ENTRY_NAME=\"Elemental ArchLinux DEV\" >> /etc/os-release

# Cleanup cache
RUN rm -r /var/cache/pacman/pkg/*

RUN mkdir -p /usr/lib/elemental/bootloader && \
    grub-mkimage -c /etc/elemental/bootargs.cfg -O x86_64-efi -o grubx64.efi -p '(cd0)/EFI/BOOT/' \
        boot linux linux16 chain normal configfile \
        part_gpt part_msdos fat iso9660 udf \
        test true keystatus loopback regexp probe \
        efi_gop efi_uga all_video gfxterm font \
        echo read help ls cat halt reboot && \
    mv grubx64.efi /usr/lib/elemental/bootloader/grubx64.efi && \
    cp /usr/share/shim-signed/shimx64.efi /usr/lib/elemental/bootloader/shimx64.efi && \
    cp /usr/share/shim-signed/mmx64.efi /usr/lib/elemental/bootloader/mmx64.efi

# For validation after the build
CMD /bin/bash
