#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2020-2021 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#

export LC_ALL="C"

# A/B (FOX_* only; OF_* are kept in fox_piano.mk)
export FOX_AB_DEVICE=1
export FOX_VIRTUAL_AB_DEVICE=1
export FOX_VIRTUAL_AB_COMPRESSION=1
export FOX_RECOVERY_INSTALL_PARTITION=/dev/block/by-name/boot

# Binaries
export FOX_USE_TAR_BINARY=1
export FOX_USE_SED_BINARY=1
export FOX_USE_LZ4_BINARY=1
export FOX_USE_ZSTD_BINARY=1
export FOX_USE_DATE_BINARY=1
export FOX_USE_GREP_BINARY=1
export FOX_USE_BUSYBOX_BINARY=1
export FOX_USE_XZ_UTILS=1
export FOX_USE_FSCK_EROFS_BINARY=1
export FOX_USE_PATCHELF_BINARY=1

# Compatibility
export FOX_DELETE_AROMAFM=1
export FOX_VANILLA_BUILD=1

# Kernel/partition OF_* settings are kept in fox_piano.mk

# Settings / data
export FOX_SETTINGS_ROOT_DIRECTORY=/persist
export FOX_ALLOW_EARLY_SETTINGS_LOAD=1
export FOX_USE_UPDATED_MAGISKBOOT=1
export FOX_MOVE_MAGISK_INSTALLER_TO_RAMDISK=1

# Misc
export FOX_ENABLE_KERNELSU_SUPPORT=1
export FOX_ENABLE_KERNELSU_NEXT_SUPPORT=1
export FOX_ENABLE_SUKISU_SUPPORT=1

# For Xiaomi Pad 8 Pro (piano)
export TARGET_DEVICE_ALT="piano"
export FOX_VARIANT="Pad"
export FOX_MAINTAINER_PATCH_VERSION=$(date +%y%m%d)

F=$(find "device" -maxdepth 2 -name "piano")
# Change splash to black
\cp -fp bootable/recovery/gui/theme/portrait_hdpi/splash.xml "$F"/recovery/root/twres/splash.xml 2>/dev/null
sed -i 's/value="#D34E38"/value="#000000"/g' "$F"/recovery/root/twres/splash.xml 2>/dev/null
sed -i 's/value="#FF8038"/value="#000000"/g' "$F"/recovery/root/twres/splash.xml 2>/dev/null

if [ -f "$HOME/android/Magisk-v29.0.zip" ]; then
        mkdir -p /tmp/misc/
        cp "$HOME/android/Magisk-v29.0.zip" /tmp/misc/
        echo -e "${BLUE}-- Successfully Copy the Magisk.zip File to \"$OF_MAGISK\" ...${NC}"
fi

if [ -n "$FOX_USE_SPECIFIC_MAGISK_ZIP" ]; then
        if [ ! -f "$OF_MAGISK" ]; then
        # some colour codes
        RED='\033[0;31m'
        GREEN='\033[0;32m'
        ORANGE='\033[0;33m'
        BLUE='\033[0;34m'
        PURPLE='\033[0;35m'
        echo -e "${RED}-- File \"$OF_MAGISK\" not found  ...${NC}"
        echo -e "${ORANGE}-- Downloading...${NC}"
        mkdir -p /tmp/misc
        wget -O /tmp/misc/Magisk-v29.0.zip https://github.com/topjohnwu/Magisk/releases/download/v29.0/Magisk-v29.0.apk
        echo -e "${BLUE}-- Successfully Downloaded the Magisk.zip File \"$OF_MAGISK\" ...${NC}"
        fi
fi
