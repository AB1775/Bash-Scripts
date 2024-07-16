#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "[!] Please run this script with the appropriate privileges."
	exit 1
fi

#############
# Functions #
#############
list_users(){
   echo "[ Current Users on this Machine ]"
   awk -F':' '{ print $1}' /etc/passwd
}

create_user(){
  echo "[+] Enter the new user's username: "
  read userName

  echo "[+] What shell should this user use? (/bin/bash, etc.): "
  read shell

  useradd -m $userName -s $shell

  echo "[+] Enter the new user's password: "
  passwd $userName

  echo "[+] Should the new user have SUDO privileges? (y/n): "
  read response

  if [ "$response" = "y" ]; then
	  usermod -aG sudo $userName // This will need to be modified depending on your distro
  fi
}

delete_user(){
  echo "[+] Enter a user to delete: "
  read userName

  userdel -r $userName
}

modify_user_group(){
  echo "[+] Enter the user to modify: "
  read userName

  echo "[+] Add user to group or remove user from a group? (add/remove): "
  read response

  if [ "$response" = "add" ]; then
	  echo "[+] What group would you like to add this user to?: "
	  read group
	  usermod -aG $group $userName
  elif [ "$response" = "remove" ]; then
	  echo "[+] What group would you like to remove this user from?: "
	  read group

	  gpasswd -d $userName $group
  else
	  echo "[!] Invalid Input.."
  fi
}

change_password(){
   echo "[+] Which user would you like to change?: "
   read userName

   passwd $userName
}

list_groups(){
  echo "[ Current Groups on this Machine ]"
  getent group | cut -d: -f1
}

create_group(){
  echo "[+] Enter the name of the group: "
  read group

  groupadd $group
}

delete_group(){
 echo "[+] Enter the name of the group: "
 read group

 groupdel $group
}

while true; do
	echo "-------------------"
	echo "| User Management |"
	echo "-------------------"
	echo "1. List Users"
	echo "2. Create User"
	echo "3. Delete User"
	echo "4. Modify User Groups"
	echo "5. Change User Password"
	echo "6. List Groups"
	echo "7. Create Group"
	echo "8. Delete Group"
	echo "9. Exit"
	echo "[+] Enter an Option: "
	read option

	case $option in
		1) 
			list_users 
			;;
		2) 
			create_user 
			;;
		3) 
			delete_user 
			;;
		4) 
			modify_user_group 
			;;
		5) 
			change_password 
			;;
		6) 
			list_groups 
			;;
		7) 
			create_group 
			;;
		8) 
			delete_group 
			;;
		9) 
			echo "[+] Exiting..."; 
			exit ;;
		*) 
			"[!] Incorrect Option.." 
			;;
	esac
done
	
