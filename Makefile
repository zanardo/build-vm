SRC ?= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

REQUIRED_TOOLS := sudo virsh virt-install m4
$(foreach tool,$(REQUIRED_TOOLS),\
	$(if $(shell command -v $(tool) 2>/dev/null),,$(error please install `$(tool)`)))

include $(SRC)/defaults.mk
include $(SRC)/defaults-debian.mk

NAME ?= debian9
IP ?= 192.168.3.100
DISKPATH ?= /srv/kvm

DISKFILE ?= $(NAME).qcow2

DISKSIZE ?= 10

debian:
	@OS="debian" \
	NAME="$(NAME)" \
	RELEASE="$(VM_DEBIAN_SUITE)" \
	DISKPATH="$(DISKPATH)" \
	DISKFILE="$(DISKFILE)" \
	DISKSIZE="$(DISKSIZE)" \
	CACHEMODE="$(VM_DISK_CACHE_MODE)" \
	CPU="$(VM_CPU_MODEL)" \
	NUMCPUS="$(VM_NUM_CPUS)" \
	MEMORY="$(VM_RAM)" \
	BRIDGE="$(VM_HOST_BRIDGE)" \
	MIRROR="$(VM_DEBIAN_MIRROR)" \
	LOCALE="$(VM_DEFAULT_LOCALE)" \
	COUNTRY="$(VM_DEBIAN_COUNTRY)" \
	KEYMAP="$(VM_DEBIAN_KEYBOARD)" \
	TIMEZONE="$(VM_TIMEZONE)" \
	INTERFACE="$(VM_DEBIAN_INTERFACE)" \
	IP="$(IP)" \
	NETMASK="$(VM_NETMASK_IPV4)" \
	GATEWAY="$(VM_GATEWAY_IPV4)" \
	DNSPRIMARY="$(VM_DNS_IPV4)" \
	DNSDOMAIN="$(VM_DNS_DOMAIN)" \
	./build.sh

.PHONY: clean
.SILENT: clean
clean:
	rm -rf $(SRC)/tmp/
