# OrangeFox / TWRP 设备树 for Xiaomi Pad 8 Pro (piano)

**Xiaomi Pad 8 Pro** (`25091RP04C`, codename `piano`) 的 OrangeFox 与 TWRP 设备树。
平台 `sun` / `xiaomi_sm8750`，A/B + Virtual A/B (compressed)，boot header v4 (GKI)。

结构复刻 [adontoo/device_xiaomi_sm8750_OFRP](https://github.com/adontoo/device_xiaomi_sm8750_OFRP)。

## Features

- [x] ADB
- [x] 解密 (FBE v2, wrapped key, metadata 分区, QCOM `qcom_decrypt`)
- [x] 显示 (Novatek NT36532 触摸，固件内置 ramdisk)
- [x] Fastbootd
- [x] 刷机 (A/B + Virtual A/B 压缩)
- [x] MTP
- [x] Sideload
- [x] USB-OTG
- [x] 震动 (AIDL haptics, cs40l26 / qcom-hv-haptics)
- [x] WLAN (qca_cld3_peach_v2，模块拷贝 + 扫描/连接脚本)

## 结构

```
├── Android.mk              # TARGET_DEVICE=piano 守卫
├── AndroidProducts.mk      # twrp_piano.mk + fox_piano.mk
├── BoardConfig.mk          # 平台/内核/解密/TW 配置
├── device.mk               # 公共 product 配置 (base, virtual A/B, twrp common)
├── twrp_piano.mk           # TWRP 产品入口 (lunch twrp_piano)
├── fox_piano.mk            # OrangeFox 产品入口 (lunch fox_piano, 含 FOX_* 变量)
├── vendorsetup.sh          # OrangeFox FOX_* 环境变量 (等价于 fox_piano.mk)
├── recovery.fstab          # 分区 + FBE v2/wrappedkey keydirectory
├── system.prop             # 设备属性
├── recovery/root/
│   ├── odm/bin/prepdecrypt.sh      # 解密准备 (osver/patchlevel 同步)
│   ├── odm/bin/umountvendor.sh
│   └── system/bin/                 # cp-wifi-ko.sh, netscan.sh, netconnect.sh, netinfo.sh
└── prebuilt/
    ├── Android.mk                  # 固件拷入 ramdisk
    ├── kernel                       # GKI 内核 (自行提取, 见下)
    └── lib/firmware/                # Novatek NT36532 触摸固件
```

## 解密逻辑链 (piano)

1. `recovery.fstab` — `/data` 带 `fileencryption=aes-256-xts:aes-256-cts:v2+inlinecrypt_optimized+wrappedkey_v0`，
   `keydirectory=/metadata/vold/metadata_encryption`，`metadata_encryption=aes-256-xts:wrappedkey_v0`
2. `BoardConfig.mk` — `TW_INCLUDE_CRYPTO`、`TW_INCLUDE_CRYPTO_FBE`、
   `TW_INCLUDE_FBE_METADATA_DECRYPT`、`BOARD_USES_QCOM_FBE_DECRYPTION`、
   `BOARD_USES_METADATA_PARTITION`、`TW_USE_FSCRYPT_POLICY := 2`、
   `SOONG_CONFIG_ufsbsg_ufsframework := bsg` (UFS wrapped key v2)
3. `device.mk` — `qcom_decrypt` + `qcom_decrypt_fbe` 包
   (来自 `TeamWin/android_device_qcom_common`，见 `omni.dependencies`)
4. `recovery/root/odm/bin/prepdecrypt.sh` — 从挂载的 system/vendor `build.prop`
   同步 `ro.build.version.release` / `ro.build.version.security_patch` /
   `ro.vendor.build.security_patch` 到 `prop.default`（骗过 bootloader verified boot），
   最后置 `crypto.ready 1`

## 触摸固件

`prebuilt/lib/firmware/` 已放入原厂 `odm/firmware` 的 Novatek NT36532 固件：

- `novatek_nt36532_piano_fw_{csot,boe}.bin`
- `novatek_nt36532_piano_mp_{csot,boe}.bin`
- `piano_nova_{csot,boe}_thp_config.ini`

`prebuilt/Android.mk` 会把它们拷到 recovery ramdisk 的 `/lib/firmware` 与
`/odm/firmware`，保证 `nt36532_touch.ko` 在 vendor/odm 挂载前就能加载固件。

## 构建

### TWRP (TWRP-Test manifest)

```bash
repo init -u https://github.com/TWRP-Test/platform_manifest_twrp_aosp.git -b twrp-14.0
repo sync
rm -rf device/xiaomi/piano
git clone <本仓库> device/xiaomi/piano

source build/envsetup.sh
lunch twrp_piano-eng
mka recoveryimage
```

### OrangeFox (fox_14.1 manifest)

```bash
source build/envsetup.sh
lunch fox_piano-eng
mka recoveryimage
```

`vendorsetup.sh` 导出 FOX_* 设置（与 `fox_piano.mk` 内联变量等价）。

## 刷入

```bash
fastboot boot recovery.img          # 建议先临时启动
fastboot flash boot recovery.img    # 或永久刷入 (A/B 设备刷 boot)
```

## 提取内核

GKI 内核不在 ROM 包里 — 从设备的 `vendor_boot` 提取：

```bash
# 1. 从设备导出 vendor_boot
fastboot fetch vendor_boot_a vendor_boot.img
# (或: adb shell dd if=/dev/block/bootdevice/by-name/vendor_boot_a of=/sdcard/vendor_boot.img)

# 2. magiskboot 解包
magiskboot unpack vendor_boot.img
# -> kernel (GKI Image)

# 3. 放入设备树
cp kernel prebuilt/kernel
```

## 备注

- `TARGET_DEVICE=piano`；lunch 目标：`twrp_piano`、`fox_piano`
- `TW_LOAD_VENDOR_MODULES` 用 piano 模块表（含 `nt36532_touch.ko`；
  本机 **没有** `synaptics_tcm2.ko`）
- `cp-wifi-ko.sh` 的 WLAN 模块列表已对照原厂
  `vendor_dlkm/lib/modules/modules.load` 验证
- 屏幕：12.1" 3200x2136，竖屏 UI 转 270°，偏移量按需微调
  (`TW_X_OFFSET` / `TW_W_OFFSET` / `OF_SCREEN_H` / `OF_STATUS_H`)

## Credits

- [OrangeFox Recovery Project](https://orangefox.download)
- TeamWin TWRP
- Xiaomi
