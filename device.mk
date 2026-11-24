
#
# Copyright (C) 2023 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Optional closed SoftOS layer (separate private repository, not part of this tree).
# Without it this tree builds a complete LineageOS device configuration.
SOFTOS_LAYER := $(wildcard vendor/softos/popsicle/softos.mk)

# Vibrator: stock Xiaomi vibratorfeature HAL (Cirrus CS40L26). The QTI HAL does not drive cs40l26_input,
# this flag drops it from sm8850-common and must be set before inheriting common.mk.
TARGET_USE_CIRRUS_VIBRATOR := true

# Inherit from sm8850-common
$(call inherit-product, device/xiaomi/sm8850-common/common.mk)

# Get non-open-source specific aspects
$(call inherit-product, vendor/xiaomi/popsicle/popsicle-vendor.mk)

# Camera
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator-V1-ndk.vendor \
    vendor.qti.hardware.camera.offlinecamera-V2-ndk.vendor

# Overlays
PRODUCT_PACKAGES += \
    ApertureOverlayPopsicle \
    FrameworksResPopsicle \
    SettingsOverlayPopsicle \
    SystemUIResPopsicle \
    UwbResPopsicle

# Touch
PRODUCT_COPY_FILES += \
   $(LOCAL_PATH)/configs/keylayout/Xiaomi_Touch_Input_1.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/Xiaomi_Touch_Input_1.idc

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# UWB
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.uwb.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.uwb.xml

# Kernel: stock HyperOS OS4.0.5 prebuilt kernel (device/xiaomi/popsicle-kernel, not compiled)
PRODUCT_COPY_FILES += \
    device/xiaomi/popsicle-kernel/kernel:kernel

# Audio: Dolby Atmos controller (XiaomiDolby, Paranoid Android, Apache-2.0; dolby/). The Dolby effect,
# vendor.dolby.dms.service and dax-default.xml come from the stock blobs. It overrides MusicFX/AudioFX.
PRODUCT_PACKAGES += \
    XiaomiDolby

# Audio: Android spatializer (the effect is in the stock blobs; the speaker route has no spatial_out yet)
PRODUCT_VENDOR_PROPERTIES += \
    ro.audio.spatializer_enabled=true

# Vibrator: init script filtered from the stock one (cs40l26 calibration nodes + service only,
# no writes to /mnt/vendor/persist). HAL binaries, VINTF and waveforms: proprietary-files.txt
PRODUCT_COPY_FILES += \
    device/xiaomi/popsicle/vibrator/vendor.xiaomi.hardware.vibratorfeature.service.rc:$(TARGET_COPY_OUT_ODM)/etc/init/vendor.xiaomi.hardware.vibratorfeature.service.rc

# NFC (NXP SN300) and sensors (QSH sub-HAL sensors.qsh.so): stock OS4.0.5 blobs, see proprietary-files.txt

# SoftOS layer (optional, see above)
ifneq ($(SOFTOS_LAYER),)
$(call inherit-product, $(SOFTOS_LAYER))
endif
