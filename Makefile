include defaults.mk
include defaults-debian.mk

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
		-DSSH_ADMIN_KEY=$(VM_SSH_ADMIN_KEY) \
	< $< > $@

# Check if obrigatory variables are defined.
.PHONY: check-vm-build-vars
check-vm-build-vars:
	@test -n "$(VM_NAME)" || (echo "ERROR: missing VM_NAME variable!" && exit 1)
	@test -n "$(VM_ADDRESS_IPV4)" || (echo "ERROR: missing VM_ADDRESS_IPV4 variable!" && exit 1)
	@test -n "$(VM_STORAGE_DIR)" || (echo "ERROR: missing VM_STORAGE_DIR variable!" && exit 1)

# Create the VM storage disk.
.PHONY: format-disk
format-disk: check-vm-build-vars
	@test ! -f "$(VM_STORAGE_DIR)/$(VM_STORAGE_FILE)" || (\
		echo "ERROR: $(VM_STORAGE_DIR)/$(VM_STORAGE_FILE) already exists!" ; \
		exit 1)
	sudo qemu-img create \
		-f qcow2 \
		-o preallocation=off \
		"$(VM_STORAGE_DIR)/$(VM_STORAGE_FILE)" \
		"$(VM_STORAGE_SIZE)G"

.PHONY: debian
debian: check-vm-build-vars format-disk clean tmp tmp/debian-$(VM_DEBIAN_SUITE).cfg
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
		--channel unix,mode=bind,target_type=virtio,name=org.qemu.guest_agent.0 \
		--controller scsi,model=virtio-scsi \
		--disk "$(VM_STORAGE_DIR)/$(VM_STORAGE_FILE),bus=scsi,format=qcow2,cache=$(VM_DISK_CACHE_MODE),discard=unmap" \
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
	# Remove SSH host keys.
	ssh-keygen -R $(VM_NAME)
	ssh-keygen -R $(VM_ADDRESS_IPV4)
	sleep 15
	ssh-keyscan $(VM_ADDRESS_IPV4) >> ~/.ssh/known_hosts

.PHONY: clean
clean:
	rm -rf tmp/
