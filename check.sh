#!/bin/bash
# This script checks if the necessary tooling is installing on your
# machine before creating VMs.

check_installed() {
	echo -n "checking if $1 is installed... "
	if hash "$1" 2>/dev/null; then
		echo "ok"
	else
		echo "not found!"
	fi
}

check_sudo() {
	echo -n "checking if you have sudo access... "
	if sudo true 1>/dev/null 2>&1; then
		echo "ok"
	else
		echo "error!"
	fi
}

check_installed "sudo"
check_sudo
check_installed "virt-install"
