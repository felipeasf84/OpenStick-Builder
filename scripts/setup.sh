#!/bin/sh -e

DEBIAN_FRONTEND=noninteractive
DEBCONF_NONINTERACTIVE_SEEN=true

echo 'tzdata tzdata/Areas select Etc' | debconf-set-selections
echo 'tzdata tzdata/Zones/Etc select UTC' | debconf-set-selections
echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections
echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections
rm -f "/etc/locale.gen"

apt update -qqy
apt upgrade -qqy
apt autoremove -qqy
apt install -qqy --no-install-recommends \
    bridge-utils \
    dnsmasq \
    hostapd \
    iptables \
    ca-certificates \
    libconfig9 \
    libmbim-utils \
    libqmi-utils \
    libusbgx2 \
    locales \
    modemmanager \
    netcat-traditional \
    net-tools \
    network-manager \
    openssh-server \
    qrtr-tools \
    rmtfs \
    sudo \
    systemd-timesyncd \
    tzdata \
    wireguard-tools \
    wpasupplicant

# tailscale from the official repo (key pinned in configs/, fingerprint 2596A99EAAB33821893C0A79458CA832957F5868)
echo 'deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/debian bookworm main' \
    > /etc/apt/sources.list.d/tailscale.list
apt update -qqy
apt install -qqy --no-install-recommends tailscale
systemctl disable tailscaled

apt clean
rm -rf /var/lib/apt/lists/*

passwd -d root

echo user:1::::/home/user:/bin/bash | newusers
echo 'user ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/user
