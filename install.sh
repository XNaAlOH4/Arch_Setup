pacman -Syu networkmanager vim gcc sudo nasm gdb efibootmgr git openssh make mesa xorg-server xcb-util-xrm xcb-util-keysyms xcb-util-wm xorg-xinit xterm tmux debugedit fakeroot man-pages man less
git clone https://www.github.com/XNaAlOH4/2bwm.git
cd 2bwm
make
make install
cd ..
printf "xterm -fg white -bg black & exec 2bwm" > ~/.xinitrc
printf "[user]\n\temail = xnaaloh4x@gmail.com\n\tname = XNaAlOH4" > ~/.gitconfig
backlight=$(ls /sys/class/backlight)
printf "if [ "$#" -ne 1 ]; then\n\tcat /sys/class/backlight/$backlight/brightness\nelse\n\techo $1 > /sys/class/backlight/$backlight/brightness\nfi" > /usr/bin/backlight

systemctl enable NetworkManager

# Only For Laptop #

# move libinput config and move tmux config 
LAPTOP='mv 50-libinput.conf /etc/X11/xorg.conf.d;mv .tmux.conf ~/'

# Only For Laptop #

# Fan Control
FAN='lm_sensors'
DELL_FAN='acpi tcl'
DELL_FAN_AUR='tcllib i8kutils'
# This is installed if the computer has BIOS fan control overriding the OS level fan control
DELL_FAN_BIOS_AUR='dell-bios-fan-control-git'

# Web browser
fox='firefox'

# File Editors
libre='libreoffice-fresh'

# Audio
AUDIO="alsa-utils"

# File systems
FS="dosfstools ntfs-3g"

# Android File Transfer
aft='android-file-transfer'

# GPU packages

# Intel
# Download libva-utils to check if drivers support GMA4500 H.264 accel decoding, can uninstall once checked
INTEL="intel-media-driver libva-intel-driver libva-utils"
# If H.264 decoding not supported, install libva-intel-driver-g45-h264 AUR

# NVIDIA
NVIDIA="nvidia nvidia-settings libvdpau-va-gl nvidia-prime opencl-nvidia"

# AMD
AMD="xf86-video-amdgpu opencl-rusticl-mesa"
AMD_OPEN="vulkan-radeon"
AMD_OPENCL_AUR="opencl-amd"
AMD_PRO_AUR="amdgpu-pro-installer vulkan-amdgpu-pro"

#Arduino development
ARDUINO="arduino-cli"

#STM32 development: follow steps to install
# For running the uninstaller
STM32="jre-openjdk"
STM32_AUR=("ncurses5-compat-libs")

#Android development
ANDROID_STUDIO="which"
#INSTALL_ANDROID_STUDIO
ANDROID_STUDIO_AUR=("android-studio android-sdk-cmdline-tools-latest android-sdk-build-tools android-sdk-platform-tools android-platform")
NODEJS="nodejs npm"

#Android disassembler
JADX="jadx"

ADDITIONAL_INSTALLS=""
AUR_INSTALLS=""

if [ "$ADDITIONAL_INSTALLS" != "" ]; then
	pacman -Syu $ADDITIONAL_INSTALLS
fi

if [ "$AUR_INSTALLS" != "" ]; then
	for i in $AUR_INSTALLS;
	do
		git clone https://aur.archlinux.org/$i.git
		cd $i
		makepkg -si
		cd ..
	done
fi


