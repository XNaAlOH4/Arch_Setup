efibootmgr -c -d /dev/sda -p 1 -L "archPC" -l "\EFI\arch\vmlinuz-linux" -u "root=UUID=e06264e2-1ad6-4f35-b2b0-c76bfe296c05 resume_offset=34816 resume=/dev/sda2 rw quiet loglevel=3 initrd=\EFI\arch\initramfs-linux.img"
#rcutree.gp_init_delay=1 nvidia-drm.modeset=1"
