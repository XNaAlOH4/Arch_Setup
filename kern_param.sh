amd_gpu="radeon.si_support=0 amdgpu.si_support=1"
dell="ignore_dmi=1"

#ROOT_UUID="root=$(blkid >> kern_param.sh)"
#FILE_SWAP="$(filefrag -v /swapfile | head -n 4 | tail -n 1 | grep " [0-9]" >> kern_param.sh)"

efibootmgr -c -d /dev/sda -p 1 -L "archPC1" -l "\EFI\arch\vmlinuz-linux" -u "root=UUID=6abff959-2505-4e8d-99d5-f290ad3ae793 resume_offset=2877440 resume=/dev/sda2 rw quiet loglevel=3 initrd=\EFI\arch\initramfs-linux.img $dell"
#rcutree.gp_init_delay=1 nvidia-drm.modeset=1"
