#!/bin/sh

source scripts/setup.bash

cd work

# change version here
wget -c $ROM_URL -O dl_rom.zip
if [ -n "$OTA_URL" ]; then
  wget -c $OTA_URL -O ota.zip
fi
unzip dl_rom.zip -d unzipped_rom

# just to get file_contexts
#./unpack_intel UL-ASUS_T00F-WW-1.17.40.16-user/boot.img bzImage ramdisk.cpio.gz
#mkdir ramdisk; cd ramdisk
#gzcat ../ramdisk.cpio.gz | cpio -i
#cd ..

mv unzipped_rom/system .
../scripts/create_link_file.sh unzipped_rom/META-INF/com/google/android/updater-script ../scripts/$LINK_PERM_SETUP_FILE
rm -rf unzipped_rom

cp -R ../root/* system

read -p 'Press any key and enter sudo password to build system.img .. '

sudo ../scripts/$LINK_PERM_SETUP_FILE
sudo ../scripts/apply_ota.sh
sudo ../scripts/link_and_set_perm_root
# Uncomment to remove apps listed in exclude_apps_list
#sudo ../scripts/exclude_apps.sh

if [ -n "$FILE_CONTEXT" ]; then
    FCOPT="-S ../scripts/$FILE_CONTEXT"
fi
    
sudo ./make_ext4fs -s -l $SYSTEM_SIZE -a system $FCOPT system.img system

