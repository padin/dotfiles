#!/bin/bash

print_line() {
	printf "%$(tput cols)s\n"|tr ' ' '-'
}

print_title() {
	clear
	print_line
	echo -e "# ${Bold}$1${Reset}"
	print_line
	echo ""
}
arch_chroot() {
	arch-chroot /mnt /bin/bash -c "${1}"
}

#替换仓库列表
update_mirrorlist(){
	print_title "update_mirrorlist"
	tmpfile=$(mktemp --suffix=-mirrorlist)	
	url="https://www.archlinux.org/mirrorlist/?country=CN&protocol=http&protocol=https&ip_version=4"
	curl -so ${tmpfile} ${url} 
	sed -i 's/^#Server/Server/g' ${tmpfile}
	mv -f ${tmpfile} /etc/pacman.d/mirrorlist;
}
#开始分区
create_partitions(){
	print_title "create_partitions"
	parted -s /dev/sda mklabel msdos
	parted -s /dev/sda mkpart primary ext4 1M 512M
	parted -s /dev/sda mkpart primary ext4 512M 20G
	parted -s /dev/sda mkpart primary ext4 20G 100%
	parted -s /dev/sda set 1 boot on
	parted -s /dev/sda print
}
#开始格式化
format_partitions(){
	print_title "format_partitions"
	mkfs.ext4 /dev/sda1 
	mkfs.ext4 /dev/sda2 
	mkfs.ext4 /dev/sda3 
}
#挂载分区
mount_partitions(){
	print_title "mount_partitions"
	mount /dev/sda2 /mnt
	mkdir /mnt/boot
	mount /dev/sda1 /mnt/boot
	mkdir /mnt/home
	mount /dev/sda3 /mnt/home
	lsblk
}
#最小安装
install_baseSystem(){
	print_title "install_baseSystem"
	pacstrap /mnt base base-devel iw wireless_tools wpa_supplicant dialog netctl vim grub screenfetch git
}

#生成标卷文件表
generate_fstab(){
	print_title "generate_fstab"
	genfstab -U /mnt >> /mnt/etc/fstab
}

#配置系统时间,地区和语言
configure_system(){
	print_title "configure_system"
	arch_chroot "ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime"
	arch_chroot "hwclock --systohc --utc"
	arch_chroot "mkinitcpio -p linux"
	echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
	echo "zh_CN.UTF-8 UTF-8" >> /mnt/etc/locale.gen
	arch_chroot "locale-gen"
	echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
}

#添加本地域名
configure_hostname(){

	print_title "configure_hostname"

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
#安装配置引导程序
configrue_bootloader(){
	print_title "configrue_bootloader"
	arch_chroot "grub-install --target=i386-pc /dev/sda"
	arch_chroot "grub-mkconfig -o /boot/grub/grub.cfg"
	umount -R /mnt
	clear
	print_title "install has been.please reboot ."
}


update_mirrorlist
create_partitions
format_partitions
mount_partitions
install_baseSystem
generate_fstab
configure_system
configure_hostname
configrue_bootloader

