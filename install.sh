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


install_package(){
	print_title "install_package"
	sudo pacman -S xorg xorg-xinit xf86-video-intel i3 conky lm_sensors firefox eclipse-java xterm dmenu ranger wget wqy-zenhei wqy-microhei alsa-utils pepper-flash netease-cloud-music fcitx-sogoupinyin fcitx-im pulseaudio pulseaudio-alsa hydorgen
}

config_system(){
	print_title "config"
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
	ln -sf `pwd`/.Xresources $HOME/.Xresources
	ln -sf `pwd`/.bashrc $HOME/.bashrc 
	ln -sf `pwd`/.vimrc $HOME/.vimrc
	ln -sf `pwd`/.xinitrc $HOME/.xinitrc
	source $HOME/.bashrc 
	mkdir -p $HOME/.config/i3
		ln -sf `pwd`/config $HOME/.config/i3/config
	mkdir -p $HOME/.config/conky
		ln -sf `pwd`/.conkyrc $HOME/.config/conky/.conkyrc
    mkdir -p $HOME/.vim/bundle
        git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim	
        
    sudo pacman -Syu yaourt
}


install_package
config_system
