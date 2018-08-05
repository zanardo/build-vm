#!/bin/bash
# This script checks if the necessary tooling is installing on your
# machine before creating VMs.

ALLGOOD=1

check_installed() {
	echo -n "checking if $1 is installed... "
	if hash "$1" 2>/dev/null; then
		echo "ok"
	else
		echo "not found!"
		ALLGOOD=0
	fi
}

check_sudo() {
	echo -n "checking if you have sudo access... "
	if sudo true 1>/dev/null 2>&1; then
		echo "ok"
	else
		echo "error!"
		ALLGOOD=0
	fi
}

check_installed "sudo"
check_sudo
check_installed "virt-install"

if [ "$ALLGOOD" = "0" ]; then
	echo "problems were found. please correct them!"
	exit 1
else
	echo "dependencies are correct!"
fi
