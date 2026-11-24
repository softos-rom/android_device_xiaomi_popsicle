# Xiaomi 17 Pro Max (`popsicle`) — LineageOS 24 device tree (SoftOS base)

**Türkçe** · [English](#english)

Xiaomi 17 Pro Max (`popsicle`, model `2509FPN0BC`, Qualcomm SM8850) için LineageOS 24
(`lineage-24.0`) cihaz ağacı. [SoftOS](https://t.me/softosrom) ROM'unun **açık kaynak tabanıdır**.
SoftOS, LineageOS 24 + MindTheGapps tabanlıdır (crDroid değildir). Resmî bir LineageOS derlemesi değildir.

## Emek
- [lolipuru](https://github.com/lolipuru/android_device_xiaomi_popsicle) — özgün popsicle ve
  [sm8850-common](https://github.com/lolipuru/android_device_xiaomi_sm8850-common) ağaçları (bu depo onun çatalıdır, geçmişi korunur).
- [xiaomi17-pudding-dev](https://github.com/xiaomi17-pudding-dev) — `hardware/xiaomi` parmak izi modülleri, çekirdek başlıkları ve ön-derlenmiş çekirdek yöntemi.
- [Paranoid Android](https://github.com/AOSPA) / [Evolution-X-Devices](https://github.com/Evolution-X-Devices/hardware_xiaomi) — Dolby denetleyicisi (`dolby/`, XiaomiDolby, Apache-2.0).
- [LineageOS](https://github.com/LineageOS) ve [MindTheGapps](https://github.com/MindTheGapps/vendor_gapps).

## lolipuru ağacına göre değişenler
- Blob listesi stok HyperOS **OS4.0.5.0.XPBCNXM** düzenine göre (`proprietary-files.txt`).
- Çekirdek derlenmez: stok OS4.0.5 çekirdeği, DTB/DTBO ve modüller `device/xiaomi/popsicle-kernel` üzerinden.
- Firmware hiçbir pakete girmez (`proprietary-firmware.txt` bilerek boş); OTA'ya kendi `recovery` imajımız girer.
- Aperture: yardımcı kameralar kapalı (HAL desteklemiyor), lens seçimi mantıksal zoom ile; eksik Türkçe metinler.
- NFC (NXP SN300 HAL) ve sensörler (QSH alt-HAL `sensors.qsh.so`, yakınlık dahil) stok OS4.0.5 blob'larıyla
  (`proprietary-files.txt`; ikili dosyalar depoda yoktur, stoktan çıkarılır).
- Titreşim: QTI HAL yerine stok Xiaomi vibratorfeature HAL'i (Cirrus CS40L26), persist'e yazmayan init betiği ve sepolicy.
- Ses: Dolby Atmos denetleyicisi (Türkçe) ve Android uzamsal ses.
- Parmak izi konumu, titreşim ve ses özellikleri stok OS4.0.5/OS4.0.6 değerleriyle.

## Derleme
```bash
repo init -u https://github.com/LineageOS/android.git -b lineage-24.0 --git-lfs
# local manifest: https://github.com/softos-rom/local_manifests
repo sync
# Blob'lar stok OS4.0.5.0.XPBCNXM fastboot paketinden (images/ klasörü) çıkarılır:
(cd device/xiaomi/popsicle && ./extract-files.py <stok>/images)
# Stok çekirdek/DTB/modüller: device/xiaomi/popsicle-kernel/extract-files.sh (kullanımı betiğin başında)
source build/envsetup.sh && breakfast popsicle && m bacon
```
Desteklenen tek taban stok **OS4.0.5.0.XPBCNXM**'dir. Firmware ve IMEI/modem bölümlerine
(`modemst1/2`, `fsg`, `fsc`, `persist`, `efs*`, `sec*`, `devinfo`) hiçbir zaman yazılmaz.
Bootloader'ı yeniden kilitlemeyin.

## Çekirdek kaynağı
Çekirdek derlenmez, stok ön-derlenmiş imaj kullanılır; çekirdekte değişikliğimiz yoktur.
Xiaomi'nin yayımladığı kaynak: [MiCode/Xiaomi_Kernel_OpenSource `popsicle-w-oss`](https://github.com/MiCode/Xiaomi_Kernel_OpenSource/tree/popsicle-w-oss)
(Xiaomi 17 / 17 Pro / 17 Pro Max, Android 16). GKI ortak çekirdek: [android16-6.12](https://android.googlesource.com/kernel/common/+/refs/heads/android16-6.12).

## Bu depoda olmayanlar
SoftOS'a özgü bileşenler (arka ekran uygulaması, Xiaomi kamera entegrasyonu, SoftOS arayüz/tema ve
Güncelleyici ekranları, açılış animasyonu ve diğer SoftOS özellikleri) ayrı, **kapalı kaynak** bir katmandadır
(`vendor/softos`) ve bu depoya girmez. Katman yoksa ağaç, yukarıdaki donanım parçalarının (NFC, sensörler,
titreşim, Dolby) hepsini içeren bir LineageOS cihaz yapılandırması üretir.

## Lisans
Apache License 2.0 (`LICENSE`; dosya başlıklarındaki telif ve SPDX satırları korunur).

---

## English

LineageOS 24 (`lineage-24.0`) device tree for the Xiaomi 17 Pro Max (`popsicle`, model `2509FPN0BC`,
Qualcomm SM8850). It is the **open source base** of the [SoftOS](https://t.me/softosrom) ROM.
SoftOS is based on LineageOS 24 + MindTheGapps (not crDroid). This is not an official LineageOS build.

**Credits:** [lolipuru](https://github.com/lolipuru/android_device_xiaomi_popsicle) (original popsicle and
sm8850-common trees; this repository is a fork and keeps their history),
[xiaomi17-pudding-dev](https://github.com/xiaomi17-pudding-dev) (`hardware/xiaomi` fingerprint modules,
kernel headers, prebuilt kernel approach), [Paranoid Android](https://github.com/AOSPA) /
[Evolution-X-Devices](https://github.com/Evolution-X-Devices/hardware_xiaomi) (Dolby controller `dolby/`),
[LineageOS](https://github.com/LineageOS),
[MindTheGapps](https://github.com/MindTheGapps/vendor_gapps).

**Changes vs. lolipuru:** blob list for stock HyperOS OS4.0.5.0.XPBCNXM; prebuilt stock kernel, DTB/DTBO and
modules via `device/xiaomi/popsicle-kernel`; firmware is never packaged (`proprietary-firmware.txt` is empty
on purpose) and our own `recovery` is part of the OTA; NFC (NXP SN300) and sensors (QSH sub-HAL, incl.
proximity) from the stock blobs (listed in `proprietary-files.txt`, no binaries in git); stock Xiaomi
vibratorfeature HAL (Cirrus CS40L26) with an init script that never writes persist, plus sepolicy; Dolby
Atmos controller and spatial audio; Aperture auxiliary cameras disabled (unsupported by the HAL);
fingerprint location, vibrator and audio properties from stock.

**Build:** see the commands above. The only supported base is stock **OS4.0.5.0.XPBCNXM**. Firmware and
IMEI/modem partitions are never written. Never relock the bootloader.

**Kernel source:** the kernel is not built; the stock prebuilt image is used unmodified. Xiaomi's published
source: [MiCode/Xiaomi_Kernel_OpenSource `popsicle-w-oss`](https://github.com/MiCode/Xiaomi_Kernel_OpenSource/tree/popsicle-w-oss);
GKI common kernel: [android16-6.12](https://android.googlesource.com/kernel/common/+/refs/heads/android16-6.12).

**Not in this repository:** SoftOS-specific components (rear display app, Xiaomi camera integration,
SoftOS UI/theme and updater screens, boot animation and other SoftOS features) live in a separate,
**closed source** layer (`vendor/softos`). Without it this tree builds a LineageOS configuration that still
includes all hardware parts listed above (NFC, sensors, vibration, Dolby).

**License:** Apache License 2.0 (`LICENSE`; copyright and SPDX headers in the files are kept).
