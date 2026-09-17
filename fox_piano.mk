#
# Copyright (C) 2025 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: GPL-3.0-or-later
#
# OrangeFox product for Xiaomi Pad 8 Pro (piano)
#
# Variable split:
#   OF_*  make variables -> this file (fox_piano.mk)
#   FOX_* env exports    -> vendorsetup.sh
#

DEVICE_PATH := device/xiaomi/piano

# Inherit from device.mk configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)

## Device identifier
PRODUCT_DEVICE := piano
PRODUCT_NAME := fox_piano
PRODUCT_BRAND := Xiaomi
PRODUCT_MANUFACTURER := Xiaomi

# Theme
TW_STATUS_ICONS_ALIGN := center

#-------------------------------------------------
# OrangeFox configuration
#-------------------------------------------------
# A/B + Virtual A/B (compressed)
OF_AB_DEVICE_WITH_RECOVERY_PARTITION := 1
OF_USE_LZ4_COMPRESSION := 1

# Compatibility
OF_TWRP_COMPATIBILITY_MODE := 1
OF_NO_RELOAD_AFTER_DECRYPTION := 1
OF_NO_TREBLE_COMPATIBILITY_CHECK := 1
OF_USE_GREEN_LED := 0
OF_NO_MIUI_PATCH_WARNING := 1
OF_DISABLE_MIUI_OTA_BY_DEFAULT := 1

# Kernel / partitions
OF_FORCE_PREBUILT_KERNEL := 1
OF_ENABLE_LPTOOLS := 1
OF_ENABLE_ALL_PARTITION_TOOLS := 1
OF_DYNAMIC_FULL_SIZE := 13958643712
OF_ENABLE_FS_COMPRESSION := 1
OF_DISPLAY_FORMAT_FILESYSTEMS_DEBUG_INFO := 1

# Settings / data
OF_UNBIND_SDCARD_F2FS := 1
OF_WIPE_METADATA_AFTER_DATAFORMAT := 1
OF_FORCE_DATA_FORMAT_F2FS := 1

# Misc
OF_OPTIONS_LIST_NUM := 6
OF_USE_DMCTL := 1
OF_USE_AIDL_BOOT_CONTROL := 1

# Maintainer info
OF_MAINTAINER := AviderMin

# Screen (12.1" 3200x2136 LCD, portrait UI rotated 270)
OF_SCREEN_H := 2136
OF_STATUS_H := 116
OF_STATUS_INDENT_LEFT := 30
OF_STATUS_INDENT_RIGHT := 30
OF_HIDE_NOTCH := 1
OF_ALLOW_DISABLE_NAVBAR := 0
