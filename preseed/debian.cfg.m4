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

d-i partman-auto/disk string /dev/sda
d-i partman-auto/method string lvm
d-i partman-auto/expert_recipe string                             \
      boot-root ::                                                \
              1 512 512 ext2                                      \
                      $primary{ }                                 \
                      $bootable{ }                                \
                      method{ format } format{ }                  \
                      use_filesystem{ } filesystem{ ext2 }        \
                      mountpoint{ /boot }                         \
              .                                                   \
              2 10000 -1 vg                                       \
                      $defaultignore{ }                           \
                      $primary{ }                                 \
                      method{ lvm }                               \
                      device{ /dev/sda }                          \
                      vg_name{ vg0 }                              \
              .                                                   \
              3 512 SWAPLVSIZE swap                               \
                      $lvmok{ }                                   \
                      lv_name{ swap }                             \
                      in_vg{ vg0 }                                \
                      method{ swap } format{ }                    \
                      .                                           \
              3 10000 ROOTLVSIZE DROOTFSTYPE                      \
                      $lvmok{ }                                   \
                      lv_name{ root }                             \
                      in_vg{ vg0 }                                \
                      method{ format } format{ }                  \
                      use_filesystem{ } filesystem{ ROOTFSTYPE }  \
                      mountpoint{ / }                             \
              .                                                   \
              4 10 -1 ext4                                        \
                      $lvmok{ }                                   \
                      lv_name{ deleteme }                         \
                      in_vg{ vg0 }                                \
              .
d-i partman-lvm/confirm boolean true
d-i partman/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-lvm/device_remove_lvm_span boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-auto/purge_lvm_from_device boolean true
d-i partman-auto-lvm/new_vg_name string vg0
d-i partman-auto/choose_recipe select boot-root
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
d-i grub-installer/bootdev string /dev/sda

d-i debian-installer/add-kernel-opts string console=ttyS0,115200n8 serial
d-i finish-install/reboot_in_progress note

d-i preseed/late_command string echo ; \
	sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /target/etc/default/grub ; \
	in-target update-grub ; \
	touch /target/reboot-me ; \
	echo "PermitRootLogin yes" >> /target/etc/ssh/sshd_config ; \
	echo "UseDNS no" >> /target/etc/ssh/sshd_config ; \
	mkdir -p /target/root/.ssh ; \
	echo 'SSH_ADMIN_KEY' > /target/root/.ssh/authorized_keys ; \
	lvremove -f vg0/deleteme ;
