### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=Kernel by superuseryu
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=vili
supported.versions=11.0-16.0
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

## boot shell variables
BLOCK=boot;
IS_SLOT_DEVICE=1;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# begin passthrough patch
passthrough() {
if [ ! "$(getprop persist.sys.fuse.passthrough.enable)" ]; then
	ui_print "Remounting /system as rw..."
	$home/tools/busybox mount -o rw,remount /system
	ui_print "Patching system's build prop for FUSE Passthrough..."
	patch_prop /system/build.prop "persist.sys.fuse.passthrough.enable" "true"
fi
} # end passthrough patch

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh && passthrough;

# boot install
dump_boot;
write_boot;
## end boot install

## vendor_boot files attributes
vendor_boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

## vendor_boot shell variables
BLOCK=vendor_boot;
IS_SLOT_DEVICE=1;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# reset for vendor_boot patching
reset_ak;

# vendor_boot install
split_boot;
flash_boot;
## end vendor_boot install
