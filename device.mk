#
# Copyright (C) 2025 The Android Open Source Project
# Copyright (C) 2025 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#
# Common product configuration for Xiaomi Pad 8 Pro (piano)
# Used by both twrp_piano.mk (TWRP) and fox_piano.mk (OrangeFox)
#

DEVICE_PATH := device/xiaomi/piano

# Configure base.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Configure core_64_bit_only.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)

# Configure virtual_ab_ota compression_with_xor.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression_with_xor.mk)

# Configure emulated_storage.mk
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Configure twrp config common.mk
$(call inherit-product, vendor/twrp/config/common.mk)

# API
BOARD_SHIPPING_API_LEVEL := 34
PRODUCT_SHIPPING_API_LEVEL := 34
PRODUCT_TARGET_VNDK_VERSION := 34

# Dynamic partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Enable Fuse Passthrough
PRODUCT_PROPERTY_OVERRIDES += persist.sys.fuse.passthrough.enable=true

# QCOM decryption chain (FBE v2 / wrappedkey)
# qcom_decrypt + qcom_decrypt_fbe come from device/qcom/common
PRODUCT_PACKAGES += \
    qcom_decrypt \
    qcom_decrypt_fbe

# EROFS support (stock system/vendor are erofs)
PRODUCT_PACKAGES += \
    fsck.erofs \
    mkfs.erofs

# Required modules
TWRP_REQUIRED_MODULES += \
    prebuilt

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)
