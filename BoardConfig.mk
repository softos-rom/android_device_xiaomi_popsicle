#
# Copyright (C) 2023 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/popsicle
KERNEL_PATH := $(DEVICE_PATH)-kernel

# Inherit from sm8850-common
include device/xiaomi/sm8850-common/BoardConfigCommon.mk

# Display
TARGET_SCREEN_DENSITY := 480

# Boot animation size (vendor/lineage/bootanimation only picks its prebuilt when the screen size is set)
TARGET_SCREEN_HEIGHT := 2608
TARGET_SCREEN_WIDTH := 1200

# Kernel — popsicle_tr: stok OS4.0.5 ön-derlenmiş çekirdek (6.12.69-android16-6).
# Yöntem: xiaomi17-pudding-dev sm8850-common kernel/kernel-platform.mk. Çekirdek derlenmez;
# TARGET_KERNEL_SOURCE yalnız Qualcomm HAL'ları için kurulu UAPI başlıklarını verir.
TARGET_NO_KERNEL_OVERRIDE := true
TARGET_KERNEL_SOURCE := $(KERNEL_PATH)/kernel-headers
# Ortak ağaç Bazel/Kleaf hedefi tanımlıyor; başlıklar "make headers_install" yolundan gelsin
TARGET_KERNEL_PLATFORM_TARGET :=

# DTB ve DTBO (stok)
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_PREBUILT_DTBIMAGE_DIR := $(KERNEL_PATH)/dtb
BOARD_PREBUILT_DTBOIMAGE := $(KERNEL_PATH)/dtbo.img

# Kernel modülleri: stok vendor_boot ramdisk, vendor_dlkm ve system_dlkm takımları, stok yükleme ve
# engel listeleriyle (ortak ağacın OS4.0.0.20 listelerinin yerine). Tekrarlanan satırlarda ilki kalır.
KERNEL_MODULES_LOAD = $(strip $(shell awk '!seen[$$0]++' $(1)))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES := $(wildcard $(KERNEL_PATH)/vendor_ramdisk/*.ko)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(call KERNEL_MODULES_LOAD,$(KERNEL_PATH)/vendor_ramdisk/modules.load)
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := $(call KERNEL_MODULES_LOAD,$(KERNEL_PATH)/vendor_ramdisk/modules.load.recovery)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_BLOCKLIST_FILE := $(KERNEL_PATH)/vendor_ramdisk/modules.blocklist
BOARD_VENDOR_KERNEL_MODULES := $(wildcard $(KERNEL_PATH)/vendor_dlkm/*.ko)
BOARD_VENDOR_KERNEL_MODULES_LOAD := $(call KERNEL_MODULES_LOAD,$(KERNEL_PATH)/vendor_dlkm/modules.load)
BOARD_VENDOR_KERNEL_MODULES_BLOCKLIST_FILE := $(KERNEL_PATH)/vendor_dlkm/modules.blocklist
BOARD_SYSTEM_KERNEL_MODULES := $(wildcard $(KERNEL_PATH)/system_dlkm/*.ko)
BOARD_SYSTEM_KERNEL_MODULES_LOAD := $(call KERNEL_MODULES_LOAD,$(KERNEL_PATH)/system_dlkm/modules.load)
BOARD_SYSTEM_KERNEL_MODULES_BLOCKLIST_FILE := $(KERNEL_PATH)/vendor_dlkm/system_dlkm.modules.blocklist
BOOT_KERNEL_MODULES := $(BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD)

# Properties
TARGET_ODM_PROP += $(DEVICE_PATH)/configs/properties/odm.prop

# Inherit from the proprietary version
include vendor/xiaomi/popsicle/BoardConfigVendor.mk

# SELinux: stock Xiaomi vibratorfeature HAL label/permissions, log noise suppression
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# OTA payload partitions
#  - recovery: our own recovery image (its vbmeta chain is verified via recovery:1). If it is not
#    written, the target slot keeps the previous ROM's recovery without AVB data and the bootloader
#    marks the slot unbootable after the first OTA.
#  - Optional: the 5 stock firmware images WITHOUT anti-rollback (bluetooth dsp imagefv modem
#    modemfirmware), taken from the supported stock HyperOS release. They are not part of this
#    repository; they are added only when vendor/xiaomi/popsicle-firmware provides them.
#    Anti-rollback firmware (xbl, tz, abl, hyp, aop ...) and IMEI/modem data partitions
#    (modemst1/2, fsg, fsc, persist, efs*, sec*, devinfo) are NEVER written.
AB_OTA_PARTITIONS += recovery
SOFTOS_OTA_FIRMWARE := bluetooth dsp imagefv modem modemfirmware
ifneq ($(wildcard vendor/xiaomi/popsicle-firmware/Android.mk),)
AB_OTA_PARTITIONS += $(SOFTOS_OTA_FIRMWARE)
endif

# Optional closed SoftOS layer (separate private repository, not part of this tree)
-include vendor/softos/popsicle/BoardConfigSoftOS.mk
