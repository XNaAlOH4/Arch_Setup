
ROOT_UUID="root=$(blkid >> kern_param.sh)"
FILE_SWAP="$(filefrag -v /swapfile | head -n 4 | tail -n 1 | grep " [0-9]" >> kern_param.sh)"

efibootmgr -c -d /dev/sda -p 1 -L "archTop" -l "\EFI\arch\vmlinuz-linux" -u "root=UUID=fe9d56d6-9f5e-4a78-9f24-9ed91c1203d1 resume_offset=34816 resume=/dev/sda7 rw quiet loglevel=3 initrd=\EFI\arch\initramfs-linux.img"
#rcutree.gp_init_delay=1 nvidia-drm.modeset=1"
