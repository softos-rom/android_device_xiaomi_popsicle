#
# Copyright (C) 2024 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from popsicle device.
$(call inherit-product, device/xiaomi/popsicle/device.mk)

## Device identifier
PRODUCT_DEVICE := popsicle
PRODUCT_NAME := lineage_popsicle
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := 2509FPN0BC
PRODUCT_MANUFACTURER := xiaomi

BUILD_FINGERPRINT := Xiaomi/popsicle/popsicle:16/BQ2A.260225.001-BP2A.250705.008/OS4.0.6.0.XPBCN:user/release-keys

# GMS
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
# Google uygulamaları: MindTheGapps (popsicle_tr kararı 2026-11-17). SOFTOS_VANILLA=true → Google'sız derleme.
# inherit-product-if-exists KULLANILMAZ: vendor/gapps eksikse derleme sessizce Google'sız çıkmasın.
ifneq ($(SOFTOS_VANILLA),true)
$(call inherit-product, vendor/gapps/arm64/arm64-vendor.mk)
endif

