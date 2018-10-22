# This file contains the default configuration variables used to
# build the VMs.
# To override a variable, just pass it on command line when invoking make.
# Ex:
# make debian VM_RAM=2048 VM_NUM_CPUS=4

## Basic

VM_NAME ?=

## Resources

# Baseline processor model. Easier when migrating VMs to other physical
# servers.
VM_CPU_MODEL ?= core2duo

# Number of virtual CPUs to allocate to the VM.
VM_NUM_CPUS ?= 2

# RAM to allocate to the VM, in MBs.
VM_RAM ?= 1024

## Storage

# Storage dir.
VM_STORAGE_DIR ?= /var/lib/libvirt/images

# VM storage file.
VM_STORAGE_FILE ?= $(VM_NAME).qcow2

# VM storage size in GB.
VM_STORAGE_SIZE ?= 20

# Cache mode to VM's disk. Can be none, unsafe, writeback, writethrough, etc.
# We use unsafe as default, because it makes installation much faster, and
# this project aims to build VMs templates.
VM_DISK_CACHE_MODE ?= unsafe

# Default LV size for root (minimum - 10GB)
VM_LVM_ROOT_SIZE ?= 10000

# Default LV size for swap.
VM_LVM_SWAP_SIZE ?= 512

## Basic network

# Bridge to attach VM network interface.
VM_HOST_BRIDGE ?= kvm0

# VM IP address.
VM_ADDRESS_IPV4 ?=

# Netmask for the VM. Must be the same of the bridge defined in VM_HOST_BRIDGE.
VM_NETMASK_IPV4 ?= 255.255.255.0

# VM gateway.
VM_GATEWAY_IPV4 ?= 192.168.3.1

# Primary DNS for the VM. Only one for now, because of limitations in Debian
# preseed.
VM_DNS_IPV4 ?= 192.168.3.2

# Local domain for the VM.
VM_DNS_DOMAIN ?= local

## Other

# Timezone for the VM.
VM_TIMEZONE ?= America/Sao_Paulo

# Default locale to use inside VM.
VM_DEFAULT_LOCALE ?= en_US.UTF-8

# SSH public key to inject into VM's root user.
VM_SSH_ADMIN_KEY ?= "`cat ~/.ssh/id_rsa.pub`"
