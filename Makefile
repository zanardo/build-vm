include defaults.mk
include defaults-debian.mk

VM_NAME ?=
VM_ADDRESS_IPV4 ?=
VM_STORAGE_DIR ?=
VM_STORAGE_FILE ?= $(VM_NAME).qcow2
VM_STORAGE_SIZE ?= 10

# Check if obrigatory variables are defined.
REQUIRED_VARS := VM_NAME VM_ADDRESS_IPV4 VM_STORAGE_DIR
$(foreach var,$(REQUIRED_VARS), \
	$(if $($(var)),, \
		$(error $(var) not defined!)))

.DEFAULT_GOAL := debian

tmp:
	mkdir -p tmp

# Prepare Debian preseed file.
tmp/debian-%.cfg: preseed/debian.cfg.m4
	m4 \
		-DSUITE="$(VM_DEBIAN_SUITE)" \
		-DLOCALE="$(VM_DEFAULT_LOCALE)" \
		-DCOUNTRY="$(VM_DEBIAN_COUNTRY)" \
		-DKEYMAP="$(VM_DEBIAN_KEYBOARD)" \
		-DMIRROR="$(VM_DEBIAN_MIRROR)" \
		-DTIMEZONE="$(VM_TIMEZONE)" \
	< $< > $@

.PHONY: debian
debian: clean tmp tmp/debian-$(VM_DEBIAN_SUITE).cfg
	sudo qemu-img create -f qcow2 -o preallocation=off $(VM_STORAGE_DIR)/$(VM_STORAGE_FILE) $(VM_STORAGE_SIZE)G
	sudo virt-install \
		--connect qemu:///system \
		--noautoconsole \
		--name "$(VM_NAME)" \
		--wait "-1" \
		--graphics "vnc" \
		--cpu "$(VM_CPU_MODEL)" \
		--vcpus "$(VM_NUM_CPUS)" \
		--memory "$(VM_RAM)" \
		--clock offset=utc \
		--network "bridge=$(VM_HOST_BRIDGE),model=virtio" \
		--os-variant "debianwheezy" \
		--disk "$(VM_STORAGE_DIR)/$(VM_STORAGE_FILE),bus=virtio,format=qcow2,cache=$(VM_DISK_CACHE_MODE),discard=unmap" \
		--location "http://$(VM_DEBIAN_MIRROR)/debian/dists/$(VM_DEBIAN_SUITE)/main/installer-amd64/" \
		--initrd-inject="tmp/debian-$(VM_DEBIAN_SUITE).cfg" \
		--extra-args " \
			quiet \
			hostname=${VM_NAME} \
			preseed/file=/debian-$(VM_DEBIAN_SUITE).cfg \
			debian-installer/locale=$(VM_DEFAULT_LOCALE) \
			debian-installer/language=en \
			debian-installer/country=$(VM_DEBIAN_COUNTRY) \
			keyboard-configuration/xkb-keymap=$(VM_DEBIAN_KEYBOARD) \
			interface=$(VM_DEBIAN_INTERFACE) \
			netcfg/disable_autoconfig=true \
			netcfg/get_ipaddress=${VM_ADDRESS_IPV4} \
			netcfg/get_netmask=$(VM_NETMASK_IPV4) \
			netcfg/get_gateway=$(VM_GATEWAY_IPV4) \
			netcfg/get_nameservers=$(VM_DNS_IPV4) \
			netcfg/get_domain=$(VM_DNS_DOMAIN) \
			netcfg/confirm_static=true \
		"

.PHONY: clean
clean:
	rm -rf tmp/
