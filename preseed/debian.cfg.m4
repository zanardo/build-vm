d-i debian-installer/locale string LOCALE
d-i debian-installer/language string en
d-i debian-installer/country string COUNTRY
d-i keyboard-configuration/xkb-keymap select KEYMAP

d-i mirror/country string br
d-i mirror/http/hostname string MIRROR
d-i mirror/http/directory string /debian
d-i mirror/http/proxy string

ifelse(SUITE, `stretch',`
d-i apt-setup/security_host string MIRROR
d-i apt-setup/security_path string /debian-security
d-i apt-setup/services-select multiselect security, updates
d-i mirror/suite string SUITE
d-i mirror/udeb/suite string SUITE
')

d-i partman-auto/disk string /dev/vda
d-i partman-auto/method string regular
d-i partman-auto/choose_recipe select atomic
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

d-i passwd/make-user boolean false
d-i passwd/root-password password root
d-i passwd/root-password-again password root

d-i clock-setup/utc boolean true
d-i time/zone string TIMEZONE
d-i clock-setup/ntp boolean true

popularity-contest popularity-contest/participate boolean false

tasksel tasksel/first multiselect ssh-server
d-i pkgsel/include string sudo, python, bash-completion, qemu-guest-agent
d-i pkgsel/install-language-support boolean false
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true
d-i grub-installer/bootdev string /dev/vda

d-i debian-installer/add-kernel-opts string console=ttyS0,115200n8 serial
d-i finish-install/reboot_in_progress note

d-i preseed/late_command string echo ; \
	sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /target/etc/default/grub ; \
	in-target update-grub ; \
	touch /target/reboot-me ; \
	echo "PermitRootLogin yes" >> /target/etc/ssh/sshd_config ; \
	echo "UseDNS no" >> /target/etc/ssh/sshd_config ;
