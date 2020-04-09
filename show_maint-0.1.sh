#!/bin/bash

# VARS 
html_path=/var/www/html/
vhost_search_str="maintenanssin.enablointi"
maint_false_flag="_EI"

# Get vhost with maintenance disabled and vhosts with maintenance enabled:
vhosts_maint_false=$(find $html_path -name "*$maint_false_flag")
vhosts_maint_true=$(find $html_path -name "*$vhost_search_str*" -exec ls {} \; | grep -v "$maint_false_flag")

# Convert vhost lists into arrays:
maint_false_arr=($vhosts_maint_false)
maint_true_arr=($vhosts_maint_true)

# Renames the file (name string passed as a variable for this) by adding $maint_false_flag to the end of the string.
disable_maint () {
	echo ""
	echo "Disabling maintenance mode for:  $1"
	echo "by executing the following command:"
	echo "mv $1 $1$maint_false_flag"	
	echo ""
	confirm_selection	
	mv "$1" "$1$maint_false_flag"
}

# Renames a file (name string passed as a variable for this) by removing the length of $maint_false_flag
# amount of characters from the name string:
enable_maint () {
	echo ""
	echo "Enabling maintenance mode for:  $1"
	echo "by executing the following command:"
	echo "mv $1 ${1::-${#maint_false_flag}}"
	echo ""
	confirm_selection	
	mv "$1" ${1::-${#maint_false_flag}}
}


# Prints a numbered list of vhosts with maintenance mode disabled: 
list_maint_disabled () {
	n=0
	echo "vhosts with maintenance mode disabled:"
	echo ""
	for i in "${maint_false_arr[@]}"
	do
		echo "$n $i"
		((n=n+1))
	done
}

# Prints a numbered list of vhosts with maintenance mode enabled:
list_maint_enabled () {
	n=0
	echo "vhosts with maintenance mode enabled:"
	echo ""
	for i in "${maint_true_arr[@]}"
	do
		echo "$n $i"
		((n=n+1))
	done
}

# Promts the user for confirmation of selected action:
confirm_selection () {
	read -r -p "Are you sure? [y/N] " response
	case "$response" in
	    [yY][eE][sS]|[yY]) 
	        ;;
	    *)
			echo "Cancelling..."
	        exit 0
	        ;;
	esac	
}

# le Menu:
if [ "$1" == "-e" ]
then	
    enable_maint ${maint_false_arr[$2]}
	echo ""    
    echo "New lists!"
	echo ""    
elif [ "$1" == "-d" ]
then
	disable_maint ${maint_true_arr[$2]}
	echo ""
    echo "New lists!"
    echo ""
elif [ "$1" == "-ld" ]
then
	list_maint_disabled
elif [ "$1" == "-le" ]
then
	list_maint_enabled
elif [ "$1" == "-l" ]
then
	list_maint_enabled
	echo ""
	list_maint_disabled
else		
	echo ""
    echo "Usage:"
    echo ""
    echo "-e and the number of the vhost to ENABLE maintenance mode."    
    echo "-d and the number of the vhost to DISABLE maintenance mode."
    echo ""
    echo "-l to list all vhosts"
    echo "-ld to list all vhosts with maintenance mode disabled:"
    echo "-le to list all vhosts with maintenance mode enabled:"
fi