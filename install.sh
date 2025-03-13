pacman -Syu networkmanager vim gcc sudo nasm gdb efibootmgr git openssh make mesa xorg xcb-util-xrm xcb-util-keysyms xcb-util-wm xorg-xinit xterm tmux debugedit fakeroot
git clone https://www.github.com/XNaAlOH4/2bwm
cd 2bwm
make
make install
echo "xrandr --auto\nxterm -fg white -bg black & exec 2bwm"

#Get UUID
blkid >> kern_param.sh
filefrag -v /swapfile | head -n 4 | tail -n 1 >> kern_param.sh
