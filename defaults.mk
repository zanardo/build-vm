# This file contains the default configuration variables used to
# build the VMs.
# To override a variable, just pass it on command line when invoking make.
# Ex:
# make debian VM_RAM=2048 VM_NUM_CPUS=4

## Resources

# Baseline processor model. Easier when migrating VMs to other physical
# servers.
VM_CPU_MODEL ?= core2duo

# Number of virtual CPUs to allocate to the VM.
VM_NUM_CPUS ?= 2

# RAM to allocate to the VM, in MBs.
VM_RAM ?= 1024

## Storage

# Cache mode to VM's disk. Can be none, unsafe, writeback, writethrough, etc.
# We use unsafe as default, because it makes installation much faster, and
# this project aims to build VMs templates.
VM_DISK_CACHE_MODE ?= unsafe

## Basic network

# Bridge to attach VM network interface.
VM_HOST_BRIDGE ?= kvm0

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
