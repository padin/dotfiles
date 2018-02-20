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
#配置网络
config_netctl(){
    print_title "config_network"
    sudo mk /etc/netctl/wireless-wqa
    sudo echo "Description='A simple WPA encrypted wireless connection'" >> /etc/netctl/wireless-wqa
    sudo echo "Interface=wlp3s0" >> /etc/netctl/wireless-wqa
    sudo echo "Connection=wireless" >> /etc/netctl/wireless-wqa
    sudo echo "Security=wpa" >> /etc/netctl/wireless-wqa
    sudo echo "IP=dhcp" >> /etc/netctl/wireless-wqa
    sudo echo "ESSID='pan'" >> /etc/netctl/wireless-wqa
    sudo echo "Key='panding123'" >> /etc/netctl/wireless-wqa
    
    sudo netctl start wireless-wqa 
	sudo netctl enable wlp3s0-wqa
}
#配置软件仓库
install_yaourt(){
	print_title "install_yaourt"
	sudo ln -sf `pwd`/pacman.conf /etc/pacman.conf
	sudo pacman -Sy yaourt
}
#安装图形环境
install_xorg(){
	print_title "install_xorg"
	sudo pacman -S xf86-video-intel xorg xorg-apps xorg-xinit
}
#安装字体
install_font(){
	print_title "install_font"
	sudo pacman -S ttf-dejavu wqy-zenhei wqy-microhei
}
#安装浏览器
install_firefox(){
	print_title "install_firfox"
	sudo pacman -S libx264 firefox ttf-ubuntu-font-family pepper-flash
}
#安装窗口管理器
install_i3(){
	print_title "install_i3"
	sudo pacman -S i3-wm i3status i3blocks dmenu conky lm_sensors xterm
	ln -sf `pwd`/.Xresources $HOME/.Xresources
	sudo ln -sf `pwd`/config /etc/i3/config 
	ln -sf `pwd`/.bashrc $HOME/.bashrc 
	ln -sf `pwd`/.xinitrc $HOME/.xinitrc
	ln -sf `pwd`/.conkyrc $HOME/.conkyrc
	ln -sf `pwd`/.bashrc $HOME/.bashrc 
	source $HOME/.bashrc 
}
#配置vim
config_vim(){
    print_title "config_vim"
	ln -sf `pwd`/.vimrc $HOME/.vimrc
    mkdir -p $HOME/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim	
}
#安装输入法
install_fcitx(){
    print_title "install_fcitx"
    sudo pacman -S fcitx fcitx-googlepinyin fcitx-im fcitx-configtool
}
#安装常用工具
install_utils(){
    print_title "install_utils"
    sudo pacman -S ranger wget alsa-utils zip 
    sudo pacman -Syu
    sudo pacman -S netease-cloud-music
    sudo pacman -S jdk8
    sudo pacman -S eclipse-jee
}



install_yaourt
config_vim
install_font
install_xorg
install_i3
install_fcitx
install_firefox
install_utils
