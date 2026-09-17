#
# Copyright (C) 2025 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#
# TWRP product for Xiaomi Pad 8 Pro (piano)
#

DEVICE_PATH := device/xiaomi/piano

# Inherit from device.mk configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)

## Device identifier
PRODUCT_DEVICE := piano
PRODUCT_NAME := twrp_piano
PRODUCT_BRAND := Xiaomi
PRODUCT_MANUFACTURER := Xiaomi

# Theme
TW_STATUS_ICONS_ALIGN := center
