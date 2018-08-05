#!/bin/bash
# This script builds a VM with virt-install.

set -u

check_disk() {
    echo "checking paths"

    if [ ! -d "$DISKPATH" ]; then
        echo "error: path ${DISKPATH} not found!"
        exit 1
    fi

    if [ -e "$DISKPATH/$DISKFILE" ]; then
        echo "error: ${DISKPATH}/${DISKFILE} already exists!"
        exit 1
    fi
}

prepare_preseed() {
    echo "preparing preseed"

    FILE="debian-${RELEASE}.cfg"
    PRESEED="$(tempfile)"

    m4 \
        -DLOCALE="${LOCALE}" \
        -DCOUNTRY="${COUNTRY}" \
        -DKEYMAP="${KEYMAP}" \
        -DMIRROR="${MIRROR}" \
        -DTIMEZONE="${TIMEZONE}" \
        < "preseed/${FILE}.m4" \
        > "${PRESEED}"
}

allow_root_x11() {
    echo "allowing root to use X11 session (permit virt-viewer)"
    xhost +si:localuser:root
}

perform_install() {
    echo "starting VM installation"


    PRESEEDBASE="$(basename \"$PRESEED\")"
    sudo virt-install \
        --connect qemu:///system \
        --name "${NAME}" \
        --wait "-1" \
        --graphics "vnc" \
        --cpu "$CPU" \
        --vcpus "$NUMCPUS" \
        --memory "$MEMORY" \
        --clock offset=utc \
        --network "bridge=${BRIDGE},model=virtio" \
        --os-variant "debianwheezy" \
        --disk "${DISKPATH}/${DISKFILE},size=${DISKSIZE},bus=virtio,format=qcow2,cache=${CACHEMODE}" \
        --location "http://${MIRROR}/debian/dists/stretch/main/installer-amd64/" \
        --initrd-inject="${PRESEED}" \
        --extra-args "
            quiet
            hostname=${NAME}
            preseed/file=/${PRESEEDBASE}
            debian-installer/locale=${LOCALE}
            debian-installer/language=en
            debian-installer/country=${COUNTRY}
            keyboard-configuration/xkb-keymap=${KEYMAP}
            interface=${INTERFACE}
            netcfg/disable_autoconfig=true
            netcfg/get_ipaddress=${IP}
            netcfg/get_netmask=${NETMASK}
            netcfg/get_gateway=${GATEWAY}
            netcfg/get_nameservers=${DNSPRIMARY}
            netcfg/get_domain=${DNSDOMAIN}
            netcfg/confirm_static=true
        "
}

echo "starting virt-install"
echo "collecting parameters"

# Redundant, but makes necessary environment variables clear and prevents
# variables without values.
NAME="${NAME}"
RELEASE="${RELEASE}"
DISKPATH="${DISKPATH}"
DISKFILE="${DISKFILE}"
DISKSIZE="${DISKSIZE}"
CACHEMODE="${CACHEMODE}"
CPU="${CPU}"
NUMCPUS="${NUMCPUS}"
MEMORY="${MEMORY}"
BRIDGE="${BRIDGE}"
MIRROR="${MIRROR}"
LOCALE="${LOCALE}"
COUNTRY="${COUNTRY}"
KEYMAP="${KEYMAP}"
INTERFACE="${INTERFACE}"
IP="${IP}"
NETMASK="${NETMASK}"
GATEWAY="${GATEWAY}"
DNSPRIMARY="${DNSPRIMARY}"
DNSDOMAIN="${DNSDOMAIN}"
PRESEED=""  # Contains preseed path

check_disk
prepare_preseed
allow_root_x11
perform_install
