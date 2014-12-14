#!/bin/bash
# Script To run some common regular tasks

# first function to be called
func_begin_script () {
	echo ""
	echo "_____________________________________________________"
	echo "       COMMON TASK SCRIPT"
	echo "Please specify what you want to do."
	echo ""
	echo "0. Exit."
	echo "1. Update git sources for Linux Kernel, gcc, glibc."
	echo "2. Update clamav antivirus database."
	echo "3. Check and clean infected files with clamav."
	echo "4. Partition and format a pen drive to FAT32."
	echo "5. Sync my dropbox account."
	echo "6. Check network details."
	echo "7. Update software repository list."
	echo "8. Upgrade packages."
	echo "9. Check which services are enabled at boot."
	echo "_____________________________________________________"
	echo ""

	read var_choice
	case "$var_choice" in
		0 | 00 ) exit;;
		1 | 01 ) func_update_git_src ;;
		2 | 02 ) func_update_clamav_db ;;
		3 | 03 ) ;;
		4 | 04 ) ;;
		5 | 05 ) func_sync_dropbox ;;
		6 | 06 ) ;;
		7 | 07 ) func_update_repo ;;
		8 | 08 ) func_upgrade_packages ;;
		9 | 09 ) func_services_enabled_at_boot ;;
		* ) echo "WRONG input." ;;
	esac
	echo ""
	echo "Operation over."
} # end of the function func_begin_script()


# function to update the ClamAV antivirus database
func_update_clamav_db () {
	echo ""
	if [ $EUID -eq "1002" ] || [ $EUID -eq "0" ]; then
		echo "Updating ClamAV antivirus DB."
		sudo freshclam
	else
		echo "ERROR: You are not root."
	fi
} # end of the function func_update_clamav_db ()


# function to sync with dropbox
func_sync_dropbox () {
	echo ""
	echo "Syncing with dropbox."
	if [ -f /home/kamal/.dropbox-dist/dropboxd ]; then
		bash /home/kamal/.dropbox-dist/dropboxd
	else
		echo "ERROR: dropbox sync script not found."
	fi
} # end of the function func_sync_dropbox ()


# function to update the software repository list using apt-get
# script must be run by the superuser
func_update_repo () {
	echo ""
	if [ $EUID -eq "1002" ] || [ $EUID -eq "0" ]; then
		echo "Updating software repository list."
		sleep 2
		sudo apt-get update
	else
		echo "ERROR: You are not root."
	fi
} # end of the function func_update_repo ()


# function to upgrade the software packages using apt-get
# script must be run by the superuser
func_upgrade_packages () {
	echo ""
	if [ $EUID -eq "1002" ] || [ $EUID -eq "0" ]; then
		echo "Upgrading software packages."
		sleep 2
		sudo apt-get upgrade
	else
		echo "ERROR: You are not root."
	fi
} # end of the function func_upgrade_packages ()


# function to update git sources for some packages
# these sources are in the external harddisk, so it has to be mounted first
# currently supported packages are the Linux Kernel, gcc, glibc
func_update_git_src () {
	echo ""
	
	echo "Updating git sources for the Linux Kernel."
	sleep 2
	if [ -d /media/kamal/code/linux ]; then
		cd /media/kamal/code/linux
		git pull
		cd -
	else
		echo "ERROR: Linux Kernel source location missing."
	fi

	echo ""
	echo "Updating git sources for GCC"
	sleep 2
	if [ -d /media/kamal/code/gcc ]; then
		cd /media/kamal/code/gcc
		git pull
		cd -
	else
		echo "ERROR: GCC source location missing."
	fi

	echo ""
	echo "Updating git sources for GLIBC."
	sleep 2
	if [ -d /media/kamal/code/glibc ]; then
		cd /media/kamal/code/glibc
		git pull
		cd -
	else
		echo "ERROR: GLIBC source location missing"
	fi
} # end of the function func_update_git_src()


#function to check which services are enabled at boot
func_services_enabled_at_boot () {
	echo ""

	R=$(runlevel  | awk '{ print $2}')
	for s in /etc/rc${R}.d/*;
	do
		basename $s | grep '^S' | sed 's/S[0-9].//g' ;
	done
}


#----TODO----#
# Give me usual updates
# ie; music tracks on musicforprogramming.net
# ie; weather update of Bangalore city
# ie; news headlines from google news page

# HELP on using this script
#------------#

func_begin_script
