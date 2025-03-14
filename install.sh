pacman -Syu networkmanager vim gcc sudo nasm gdb efibootmgr git openssh make mesa xorg-server xcb-util-xrm xcb-util-keysyms xcb-util-wm xorg-xinit xterm tmux debugedit fakeroot
git clone https://www.github.com/XNaAlOH4/2bwm
cd 2bwm
make
make install
echo "xrandr --auto\nxterm -fg white -bg black & exec 2bwm"

#Web browser
#firefox

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
NVIDIA="nvidia nvidia-settings libvdpau-va-gl nvidia-prime"
