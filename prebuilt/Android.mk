#
# Copyright (C) 2025 The Android Open Source Project
# Copyright (C) 2025 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#
# Bundles prebuilt artifacts into the recovery ramdisk:
#  - lib/firmware/   -> /lib/firmware  (kernel request_firmware lookup dir)
#                    -> /odm/firmware  (stock Novatek NT36532 firmware path)
# Touch panel (Novatek NT36532) needs its firmware in the ramdisk because
# TW_LOAD_PREBUILT_MODULES_AT_FIRST loads nt36532_touch.ko before vendor/odm
# are mounted.
#

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
    LOCAL_MODULE := prebuilt
    LOCAL_MODULE_TAGS := optional
    LOCAL_MODULE_CLASS := ETC
    LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)
    LOCAL_POST_INSTALL_CMD += \
        mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/lib/firmware; \
        cp -rf $(LOCAL_PATH)/lib/firmware/* $(TARGET_RECOVERY_ROOT_OUT)/lib/firmware/; \
        mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/odm/firmware; \
        cp -rf $(LOCAL_PATH)/lib/firmware/* $(TARGET_RECOVERY_ROOT_OUT)/odm/firmware/;
include $(BUILD_PHONY_PACKAGE)
