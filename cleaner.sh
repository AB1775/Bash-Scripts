#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then
	echo "[+] Please run this script as root or with sudo privileges"
	exit 1
else
	####################
 	# Get Current Date #
  	####################
   	current_date=$(date +"%Y-%m-%d")
    
	###########
	# Logging #
	###########
	log_file = "/var/log/cleaner_sh.log"
	exec > >(tee -a $log_file)
	exec 2>&1
	
	#######################
	# Remove Old Packages #
	####################### 
	echo "[+] Removing old Packages"
	apt autoremove
	
	#######################
	#  Clean Up APT Cache #
	#######################
	echo "[+] Cleaning up APT Cache"
	du -sh /var/cache/apt
	apt autoclean
	
	###########################
	# Clean Up Snap Revisions #
	###########################
	echo "[+] Cleaning up Old Revisions of Snaps"
	set -eu
	snap list --all | awk '/disabled/{print $1, $3}' |
		while read snapname revision; do
			snap remove "$snapname" --revision="$revision"
		done
	
	############################
	# Clean Up Thumbnail Cache #
	############################
	echo "[+] Cleaning up Thumbnail Cache"
	rm -rf ~/.cache/thumbnails/*
	
	########################
	# Remove Old Log Files #
	########################
	echo "[+] Removing old log files"
	find /var/log/ -name "*.log" -type f -mtime +10 -delete
	echo "[+] Cleanup complete on ${current_date}. Log File: $log_file"
fi
