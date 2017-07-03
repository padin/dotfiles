# dotfiles
The repository to save some dotfiles and system config.

系统安装与配置记录。

基于Archlinux发行版，用于搭建开发环境以及学习。

配置：清华同方H46K笔电

1.插入启动盘，推荐rufus刻录工具采用BIOS启动方式。开机。

2.分区（略）推荐fdisk或cfdisk
	sda1	1G		boot
	sda2	20G
	sda3	677G
	我的笔电内存8G，基本不会溢出，所以不做交换分区了。
	
3.格式化
	mkfs.ext4 /dev/sda1
	mkfs.ext4 /dev/sda2
	mkfs.ext4 /dev/sda3

4.挂载
	mount /dev/sda2 /mnt
	mkdir /mnt/boot
	mount /dev/sda1 /mnt/boot
	mkdir /mnt/home
	mount /dev/sda3 /mnt/home
	
5.修改镜像列表
	vim	/etc/pacman.d/mirrorlist
	把阿里，中科大或网易的镜像提到第一位，这里已经挂载了，所以是临时修改启动盘的内容，所以随意选一个。
	
6.连接无线网，有线网请参考https://wiki.archlinux.org/index.php/Network_configuration_(简体中文)
	wifi-menu
	
7.安装基本库
	pacstrap -i /mnt base base-devel iw wpa_supplicant netctl dialog grub
	
8.配置系统
	genfstab -U /mnt >> /mnt/etc/fstab
	arch-chroot /mnt
	mkinitcpio -p linux
	grub-install --target=i386-pc /dev/sda
	grub-mkconfig -o /boot/grub/grub.cfg
	passwd	设置root密码
	exit
	umount -R /mnt
	
9.关机
	shutdown now
	
10.拔启动盘，开机。

11.连接网络
	wifi-menu
	netctl enable network-SSID
	systemctl enable netctl-auto@network-SSID.service
	
12.创建用户
	useradd -m -g users -G wheel -s /bin/bash ice
	passwd ice
	chmod u+w /etc/sudoers
	vi /etc/sudoers		在root ALL=(ALL)ALL后添ice ALL=(ALL)ALL
	chmod u-w /etc/sudoers
	
13.切换用户
	logout
	
14.安装git
	sudo pacman -S git
	

另外可以使用shell脚本安装：
	 wget https://github.com/padin/dotfiles/tarball/master -O - | tar xz
	 
	 cd <dir..>

	 chmod +x & ./setup.sh
	 
