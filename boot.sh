#!/bin/bash

# See https://www.mail-archive.com/qemu-devel@nongnu.org/msg471657.html thread.
#
# The "pc-q35-2.4" machine type was changed to "pc-q35-2.9" on 06-August-2017.
#
# The "media=cdrom" part is needed to make Clover recognize the bootable ISO
# image.

##################################################################################
# NOTE: Comment out the "MY_OPTIONS" line in case you are having booting problems!
##################################################################################
BACKING_DIR=/backing
SNAPSHOT_DIR=/snapshot
mkdir -p $BACKING_DIR $SNAPSHOT_DIR
[ ! -f $SNAPSHOT_DIR/mac_hdd.img ] && qemu-img create -f qcow2 -b $BACKING_DIR/mac_hdd-backing.img $SNAPSHOT_DIR/mac_hdd.img


MY_OPTIONS="+aes,+xsave,+avx,+xsaveopt,avx2,+smep"

exec qemu-system-x86_64 -enable-kvm -m 3072 -cpu Penryn,kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on,$MY_OPTIONS\
    -vnc 0.0.0.0:0 \
    -redir tcp:2222::22 \
    -redir tcp:5001::5001 \
	  -machine pc-q35-2.9 \
	  -smp 4,cores=2 \
	  -usb -device usb-kbd -device usb-tablet \
	  -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
	  -drive if=pflash,format=raw,readonly,file=/usr/lib/qemu/OVMF_CODE-pure-efi.fd \
	  -drive if=pflash,format=raw,file=/usr/lib/qemu/OVMF_VARS-pure-efi-1024x768.fd \
	  -smbios type=2 \
	  -device ich9-intel-hda -device hda-duplex \
	  -device ide-drive,bus=ide.2,drive=Clover \
	  -drive id=Clover,if=none,snapshot=on,format=qcow2,file=/usr/lib/qemu/Clover.qcow2 \
	  -device ide-drive,bus=ide.1,drive=MacHDD \
	  -drive id=MacHDD,if=none,file=$SNAPSHOT_DIR/mac_hdd.img,format=qcow2 \
	  -netdev user,id=net0 -device e1000-82545em,netdev=net0,id=net0,mac=52:54:00:c9:18:27 \
	  -monitor stdio
