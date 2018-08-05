#!/bin/bash
# This script checks if the necessary tooling is installing on your
# machine before creating VMs.

check() {
	echo -n "checking if $1 is installed... "
	if hash "$1" 2>/dev/null; then
		echo "ok"
	else
		echo "not found!"
	fi
}

check "virt-install"
