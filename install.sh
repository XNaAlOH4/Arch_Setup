pacman -Syu networkmanager vim gcc sudo nasm gdb efibootmgr git openssh make mesa xorg-server xcb-util-xrm xcb-util-keysyms xcb-util-wm xorg-xinit xterm tmux debugedit fakeroot
git clone https://www.github.com/XNaAlOH4/2bwm
cd 2bwm
make
make install
echo "xrandr --auto\nxterm -fg white -bg black & exec 2bwm"

#Get UUID
blkid >> kern_param.sh
filefrag -v /swapfile | head -n 4 | tail -n 1 >> kern_param.sh

#Arduino development
ARDUINO="arduino-cli"

#STM32 development: follow steps to install
# For running the uninstaller
STM32="jre-openjdk"
STM32_AUR=("ncurses5-compat-libs")
#

#Android development
ANDROID_STUDIO="which"
#INSTALL_ANDROID_STUDIO
ANDROID_STUDIO_AUR=("android_studio android-sdk-cmdline-tools-latest android-sdk-build-tools android-sdk-platform-tools android-platform")

ADDITIONAL_INSTALLS=""
AUR_INSTALLS=""

if [ "$ADDITIONAL_INSTALLS" != "" ]; then
	pacman -Syu "$ADDITIONAL_INSTALLS"
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
