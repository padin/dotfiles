#!/bin/bash

print_line() { #{{{

	printf "%$(tput cols)s\n"|tr ' ' '-'

} #}}}

print_title() { #{{{

	clear

	print_line

	echo -e "# ${Bold}$1${Reset}"

	print_line

	echo ""

} #}}}

arch_chroot() { #{{{

	arch-chroot /mnt /bin/bash -c "${1}"

}

#}}}

pause_function() { #{{{

	print_line

	read -e -sn 1 -p "Press enter to continue..."


} #}}}

update_mirrorlist(){
	print_title "update_mirrorlist"
	tmpfile=$(mktemp --suffix=-mirrorlist)	
	url="https://www.archlinux.org/mirrorlist/?country=CN&protocol=http&protocol=https&ip_version=4"
	curl -so ${tmpfile} ${url} 
	sed -i 's/^#Server/Server/g' ${tmpfile}
	mv -i ${tmpfile} /etc/pacman.d/mirrorlist;
}
create_partitions(){
	print_title "create_partion"
	parted -s /dev/sda mklabel msdos
	parted -s /dev/sda mkpart primary ext4 1M 1G
	parted -s /dev/sda mkpart primary ext4 1G 4G
	parted -s /dev/sda mkpart primary ext4 4G 100%
	parted -s /dev/sda set 1 boot on
	parted -s /dev/sda print
}
format_partitions(){
	mkfs.ext4 /dev/sda1 
	mkfs.ext4 /dev/sda2 
	mkfs.ext4 /dev/sda3 
}
mount_partitions(){
	print_title "mount_partitions"
	mount /dev/sda2 /mnt
	mkdir /mnt/boot
	mount /dev/sda1 /mnt/boot
	mkdir /mnt/home
	mount /dev/sda3 /mnt/home
	lsblk
}

install_baseSystem(){
	print_title "install_baseSystem"
	pacstrap -i /mnt base base-devel iw wpa_supplicant dialog netctl vim grub
}

generate_fstab(){
	print_title "generate_fstab"
	genfstab -U /mnt >> /mnt/etc/fstab
}

configure_system(){
	print_title "config_time"
	arch_chroot "ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/locatime"
	arch_chroot "hwclock --systohc --utc"
	arch_chroot "mkinitcpio -p linux"
	clear
	print_title "set root passwd"
	passwd

	
}
configure_hostname(){

	print_title "HOSTNAME - https://wiki.archlinux.org/index.php/HOSTNAME"

	read -p "Hostname [ex: archlinux]: " host_name

	echo "$host_name" > /mnt/etc/hostname

	if [[ ! -f /mnt/etc/hosts.aui ]]; then

	cp /mnt/etc/hosts /mnt/etc/hosts.aui

	else

	cp /mnt/etc/hosts.aui /mnt/etc/hosts

	fi

	arch_chroot "sed -i '/127.0.0.1/s/$/ '${host_name}'/' /etc/hosts"

	arch_chroot "sed -i '/::1/s/$/ '${host_name}'/' /etc/hosts"

}

configrue_bootloader(){
	print_title "configure_bootloader"
	arch_chroot "grub-install --target=i386-pc /dev/sda"
	arch_chroot "grub-mkconfig -o /boot/grub/grub.cfg"
	umount -R /mnt
	pause_function
}


#update_mirrorlist
#create_partitions
#format_partitions
#mount_partitions
#install_baseSystem
#generate_fstab
#configure_system
#configure_hostname
configrue_bootloader

