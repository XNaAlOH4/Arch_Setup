pacman -Syu networkmanager vim gcc sudo nasm gdb efibootmgr git openssh make mesa xorg-server xcb-util-xrm xcb-util-keysyms xcb-util-wm xorg-xinit xterm tmux debugedit fakeroot man-pages
git clone https://www.github.com/XNaAlOH4/2bwm.git
cd 2bwm
make
make install
printf "xrandr --auto\nxterm -fg white -bg black & exec 2bwm" > ~/.xinitrc
printf "[user]\n\temail = xnaaloh4x@gmail.com\n\tname = XNaAlOH4" > ~/.gitconfig

#Web browser
#firefox

#File Editors
#libreoffice-fresh

# Audio
AUDIO="alsa-utils"

# File systems
FS="dosfstools ntfs-3g"

# GPU packages

# Intel
# Download libva-utils to check if drivers support GMA4500 H.264 accel decoding, can uninstall once checked
INTEL="intel-media-driver libva-intel-driver libva-utils"
# If H.264 decoding not supported, install libva-intel-driver-g45-h264 AUR

# NVIDIA
NVIDIA="nvidia nvidia-settings libvdpau-va-gl nvidia-prime opencl-nvidia"

# AMD
AMD="xf86-video-amdgpu opencl-rusticle-mesa"
AMD_AUR="amdgpu-pro-oglp vulkan-amdgpu-pro amf-amdgpu-pro opencl-amd"

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


