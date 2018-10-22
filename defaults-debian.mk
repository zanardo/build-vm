# This file contains the default configuration variables used to
# build Debian VMs.
# To override a variable, just pass it on command line when invoking make.
# Ex:
# make debian VM_DEBIAN_SUITE=stretch

# Debian mirror to use.
VM_DEBIAN_MIRROR ?= cdn-fastly.deb.debian.org

# Debian suite to install (ex: wheezy, jessie, stretch, etc).
VM_DEBIAN_SUITE ?= stretch

# Used to determine mirrors, time synchronization, etc.
VM_DEBIAN_COUNTRY ?= BR

# Used inside preseed, to configure the installation keyboard layout.
VM_DEBIAN_KEYBOARD ?= br

# Default network interface name.
VM_DEBIAN_INTERFACE ?= ens3
