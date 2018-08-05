SRC ?= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

$(info checking needed tools)
REQUIRED_TOOLS := sudo virsh virt-install m4
$(foreach tool,$(REQUIRED_TOOLS),\
	$(if $(shell command -v $(tool) 2>/dev/null),,$(error please install `$(tool)`)))

include $(SRC)/defaults.mk

MIRROR ?= cdn-fastly.deb.debian.org
NAME ?= debian9
RELEASE ?= stretch
DISKPATH ?= /srv/kvm
DISKFILE ?= $(NAME).qcow2
DISKSIZE ?= 10
COUNTRY ?= BR
LOCALE ?= en_US.UTF-8
KEYMAP ?= br
INTERFACE ?= ens3
IP ?= 192.168.3.100
debian:
	@OS="debian" \
	NAME="$(NAME)" \
	RELEASE="$(RELEASE)" \
	DISKPATH="$(DISKPATH)" \
	DISKFILE="$(DISKFILE)" \
	DISKSIZE="$(DISKSIZE)" \
	CACHEMODE="$(VM_DISK_CACHE_MODE)" \
	CPU="$(VM_CPU_MODEL)" \
	NUMCPUS="$(VM_NUM_CPUS)" \
	MEMORY="$(VM_RAM)" \
	BRIDGE="$(VM_HOST_BRIDGE)" \
	MIRROR="$(MIRROR)" \
	LOCALE="$(LOCALE)" \
	COUNTRY="$(COUNTRY)" \
	KEYMAP="$(KEYMAP)" \
	TIMEZONE="$(VM_TIMEZONE)" \
	INTERFACE="$(INTERFACE)" \
	IP="$(IP)" \
	NETMASK="$(VM_NETMASK_IPV4)" \
	GATEWAY="$(VM_GATEWAY_IPV4)" \
	DNSPRIMARY="$(VM_DNS_IPV4)" \
	DNSDOMAIN="$(VM_DNS_DOMAIN)" \
	./build.sh

