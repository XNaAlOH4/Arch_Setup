#!/bin/bash

#Setup

#export AUDIO_HW=$(aplay -l | grep ALC274 | head -c 37 | tail -c 1)

#End Setup

export __NV_PRIME_RENDER_OFFLOAD=1
# ONLY ENABLE IF I WANT NVIDIA TO BE USED AS SOON AS STARTX IS RUN
#export __GLX_VENDOR_LIBRARY_NAME=nvidia
export LIBVA_DRIVER_NAME=nvidia
export VDPAU_DRIVER=nvidia

export PATH=$PATH:/home/coolberry/.cmds
export C_INCLUDE_PATH="/home/coolberry/.clib/:$C_INCLUDE_PATH"
export GIT_SSH_COMMAND="/usr/bin/ssh -i ~/.ssh/id_rsa" git pull
export CHOME='/home/coolberry'

alias ls='ls --color'
alias ll='ls -a -l'
alias ..='cd ..'
alias ...='cd ../../'
alias .2='cd ../../'
alias .3='cd ../../../'
alias v='vim --noplugin'
alias view_ram='free -m'

alias recod='vim $CHOME/.bash_profile'
alias relod='source ~/.bash_profile'
alias find_pkg='sudo pacman -Ss'
alias get_graphics='lspci -v -nn -d ::03xx'
alias stm32-ide='$CHOME/st/stm32cubeide_1.17.0/stm32cubeide'
alias stm32-prog='$CHOME/STMicroelectronics/STM32Cube/STM32CubeProgrammer/bin/STM32_Programmer_CLI'

function update() {
	sudo pacman -Syu $1
}

function start-ssh() {
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/id_ed25519
}

function clone-aur() {
	git clone https://aur.archlinux.org/$1
}

function clone() {
	git clone https://github.com/$1
}

function ssh-clone() {
	git clone git@github.com:$1
}

function update_stm32() {
	stm32-prog -c port=swd -w '/home/coolberry/STM32CubeIDE/workspace_1.17.0/First Proj/Release/First Proj.bin' 0x08000000 -s
}

function backlight() {
	echo $1 > /sys/class/backlight/dell_uart_backlight/brightness
}

function neofetch() {
	printf "\033[32;1;1m"
	cat $CHOME/.Pine
	printf "\033[31;1;1mOperating System\033[0m = \033[31;1;4m$(head -c 16 /usr/lib/os-release | tail -c 10)\n\033[0m"
	printf "\033[31;1;1mVersion\033[0m = $(uname -r)\n"
#$(head -c 27 /proc/version | tail -c 13)
	printf "\033[31;1;1mColor\033[0m = $(head -c 95 /usr/lib/os-release | tail -c 15)\n"
	printf "CPU = $(head -c 105 /proc/cpuinfo | tail -c 25) ($(head -c 248 /proc/cpuinfo | tail -c 1))$(head -c 120 /proc/cpuinfo | tail -c 10)\n"
	printf "Shell: $(echo $SHELL | tail -c 5)\n"
	printf "Packages: $(pacman -Q | wc -l)\n"
}

alias unzip='python $CHOME/.cmds/unzip.py'

alias help='grep alias /home/coolberry/.bash_profile'

function seekfile() {
	head -c $((512*($2+1))) $1 | tail -c $((512)) | xxd
}

function google() {
	curl https://www.google.com/search?q=$1
}

function escapist() {
	curl -o escapist.tmp 'https://dw.uptodown.net/dwn/cYKezPoDD5ZWid4xIEgitauBEua4nAr3ThdkvefatG_Z3hPb9as8nNHBpFY7bpmZ0HpGB3AyjeAXpokSAS2DmN51WqMRgzzjprJHKLcOYjEwmfE21sx93_u-sQldQwdx/vpDfzaX_M-hZSye9naH9IqvrHPrscCCShFrfbcJalxylwNdXmXG-wzMIjYkXM2nthU29W9E49c459lzVH4LIRnSEL20nJdlYTiOWGxpvDHNBYYHRIddX8ZtGuqVCTHtf/DgtJqBljhdDDJd2eSNU0z0MMHyNnFAlsks5nWoV50VREiN0Np12McaYrsWM0ZdG8S9ilWEa4JquooHwNiK6HMGpN1ewEgEIG1vlaB6sTVbXfFzwDg6A25OGDwqKQ6XSf/zu_52Qd2j8rHCKbY3Q5a_w==/the-escapists-prison-escape-trial-636064.apk'
}

function git_get() {
	git clone git://sourceware.org/git/binutils-gdb.git
}

function get_pdf_parser() {
	curl -o pdf_parser.zip https://didierstevens.com/files/software/pdf-parser_V0_7_9.zip
}

## AUDIO_ONLY / SCREEN_ONLY / VIDEO RECORDING

#alias audio_record='ffmpeg -f pulse -ac 1 -i alsa_output.pci-0000_00_1f.3.analog-stereo.monitor output.mp3'

alias screen_record='ffmpeg -f x11grab -r 25 -s 1920x1080 -i :0.0 -vcodec libx264 -preset ultrafast output.mpg;ffmpeg -i output.mpg output.mp4'

alias screen_shot='ffmpeg -f x11grab -video_size 1920x1080 -framerate 1 -i :0.0 -vframes:v 1 output.png'

alias video_record='ffmpeg -f pulse -ac 1 -i alsa_output.pci-0000_00_1f.3.analog-stereo.monitor -f x11grab -s 1920x1080 -r 25 -i :0.0 -vcodec libx264 -preset ultrafast output.mpg;ffmpeg -i output.mpg output.mp4'
alias webcam_record='ffmpeg -f v4l2 -r 25 -video_size 1280x720 -vcodec libx264 -preset ultrafast -i /dev/video0 output.mpg;ffmpeg -i output.mpg webcam.mp4'

alias console_playvid='ffmpeg -y -nostats -i /home/coolberry/output.mp4 -f pulse alsa_output.pci-0000_00_1f.3.analog-stereo -pix_fmt bgra -filter:v fps=25 -filter:v realtime -f fbdev /dev/fb0 > /dev/null 2>&1'
alias console_record='ffmpeg -f fbdev -i /dev/fb0 -q:v 0.1 -filter:v fps=20 /home/coolberry/AudioVisual/output.mpg'
alias console_screen_shot='ffmpeg -f fbdev -i /dev/fb0 -vframes:v 1 output.png'

#quality screen record
function qscrrec() {
	ffmpeg -y -nostats -f x11grab -s 1920x1080 -r 60 -i :0.0 -qscale 0 -vcodec huffyuv $1.avi
	ffmpeg -i $1.avi -vcodec libx264 -preset ultrafast -qp 0 $1.mkv
	rm $1.avi
}

function qconrec() {
	ffmpeg -y -nostats -f fbdev -i /dev/fb0 -filter:v fps=20 -q:v 0 -vcodec libx264 -preset ultrafast -qp 0 $1.mkv
}

function audio_record() {
	ffmpeg -f alsa -i hw:$AUDIO_HW $1
}

function play_sound() {
	#ffmpeg -y -nostats -i $1 -f pulse alsa_output.pci-0000_00_1f.3.analog-stereo > /dev/null 2>&1
	ffmpeg -i $1 -f alsa hw:$AUDIO_HW
}

function console_vid() {
	ffmpeg -y -nostats -i $1 -pix_fmt bgra -filter:v realtime -f fbdev /dev/fb0 > /dev/null 2>&1
}

function console_img() {
	ffmpeg -y -nostats -loop 1 -framerate 1 -i $1 -pix_fmt bgra -f fbdev /dev/fb0 > /dev/null 2>&1
}

function console_vid_aud() {
	#ffmpeg -y -nostats -i $1 -f pulse alsa_output.pci-0000_00_1f.3.analog-stereo -pix_fmt bgra -filter:v realtime -f fbdev /dev/fb0 > /dev/null 2>&1
	ffmpeg -y -nostats -i $1 -f alsa hw:0 -pix_fmt bgra -filter:v realtime -f fbdev /dev/fb0 > /dev/null 2>&1
}

function console_webcam() {
	ffmpeg -y -nostats -f v4l2 -video_size 640x480 -i /dev/video0 -pix_fmt bgra -f fbdev /dev/fb0 > /dev/null 2>&1
}

function x11_display_webcam() {
	ffmpeg -y -nostats -f v4l2 -s 1280x720 -i /dev/video0 -pix_fmt yuv420p -window_size 960x720 -f xv display > /dev/null 2>&1
}

function webcam_record() {
	ffmpeg -y -nostats -f v4l2 -s 1280x720 -i /dev/video0 output.mpg > /dev/null 2>&1
}

function webcam_pic() {
	ffmpeg -y -nostats -f v4l2 -s 1280x720 -i /dev/video0 -framerate 1 -vframes:v 1 output.png> /dev/null 2>&1
}

function x11_vid() {
	ffmpeg -y -nostats -i $1 -pix_fmt yuv420p -window_size 960x720 -filter:v realtime -f xv display > /dev/null 2>&1
}

function x11_vid_aud() {
	#ffmpeg -y -nostats -i $1 -f pulse alsa_output.pci-0000_00_1f.3.analog-stereo -pix_fmt yuv420p -window_size 960x720 -filter:v realtime -f xv display
	ffmpeg -y -nostats -i $1 -f alsa hw:0 -pix_fmt yuv420p -window_size 960x720 -filter:v realtime -f xv display
}

function x11_img() {
	ffmpeg -y -nostats -loop 1 -framerate 1 -i $1 -pix_fmt yuv420p -f xv display > /dev/null 2>&1
}

function test_mic() {
	ffmpeg -f alsa -i default -f alsa hw:0
}
