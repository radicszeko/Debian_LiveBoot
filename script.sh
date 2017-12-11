rm -rf $HOME/live_boot/image
rm -f $HOME/live_boot/debian-live.iso
mkdir -p $HOME/live_boot/image/{live,isolinux}
cd $HOME/live_boot
mksquashfs chroot image/live/filesystem.squashfs -e boot
cp chroot/boot/vmlinuz-4.9.0-4-686 image/live/vmlinuz1 
cp chroot/boot/initrd.img-4.9.0-4-686 image/live/initrd1 
cat << EOF > $HOME/live_boot/image/isolinux/isolinux.cfg
UI menu.c32

prompt 0
menu title Debian Live

timeout 300

label Debian Live 4.9.0-3-686
menu label ^Debian Live 4.9.0-3-686
menu default
kernel /live/vmlinuz1
append initrd=/live/initrd1 boot=live

label hdt
menu label ^Hardware Detection Tool (HDT)
kernel hdt.c32
text help
HDT displays low-level information about the systems hardware.
endtext

label memtest86+
menu label ^Memory Failure Detection (memtest86+)
kernel /live/memtest
EOF
cd $HOME/live_boot/image/
cp /usr/lib/ISOLINUX/isolinux.bin isolinux/
cp /usr/lib/syslinux/modules/bios/menu.c32 isolinux/
cp /usr/lib/syslinux/modules/bios/hdt.c32 isolinux/
cp /usr/lib/syslinux/modules/bios/ldlinux.c32 isolinux/
cp /usr/lib/syslinux/modules/bios/libutil.c32 isolinux/
cp /usr/lib/syslinux/modules/bios/libmenu.c32 isolinux/
cp /usr/lib/syslinux/modules/bios/libcom32.c32 isolinux/
cp /usr/lib/syslinux/modules/bios/libgpl.c32 isolinux/
cp /usr/share/misc/pci.ids isolinux/
cp /boot/memtest86+.bin live/memtest
genisoimage \
    -rational-rock \
    -volid "Debian Live" \
    -cache-inodes \
    -joliet \
    -hfs \
    -full-iso9660-filenames \
    -b isolinux/isolinux.bin \
    -c isolinux/boot.cat \
    -no-emul-boot \
    -boot-load-size 4 \
    -boot-info-table \
    -output $HOME/live_boot/debian-live.iso \
    $HOME/live_boot/image
cp $HOME/live_boot/debian-live.iso /media/sf_VirtualBox/.
