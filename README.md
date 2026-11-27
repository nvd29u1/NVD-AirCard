# NVD AirCard

> **Bản cá nhân hoá NVD** từ [AirCard-iOS](https://github.com/Mak5er/AirCard-iOS) của [@mak5er](https://github.com/mak5er) (giấy phép MIT). Đổi tên/bundle ID/icon/giao diện sang thương hiệu NVD; mọi tính năng và ghi công tác giả gốc được giữ nguyên.

# AirCard-iOS

<p align="center">
  <img src="ios-app/Assets.xcassets/AppIcon.appiconset/AppIcon.png" width="128" height="128" alt="NVD AirCard Icon" style="border-radius: 28px; box-shadow: 0 8px 24px rgba(0,0,0,0.18);" />
</p>

<p align="center">
  Apple Wallet card skins, lock screen passcode themes, and PosterBoard wallpapers directly on iOS (18.0 – 27.2 beta 2).
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%2018.0%E2%80%9327.2%20b2-blue?style=flat-square&logo=apple" alt="Platform" />
  <img src="https://img.shields.io/badge/Swift-5.0-orange?style=flat-square&logo=swift" alt="Swift" />
  <img src="https://img.shields.io/badge/Rust-FFI%20Core-red?style=flat-square&logo=rust" alt="Rust" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License" />
  <a href="https://www.paypal.com/donate/?hosted_button_id=98QRTC2HFRA4Y"><img src="https://img.shields.io/badge/Donate-PayPal-00457C?style=flat-square&logo=paypal" alt="Donate with PayPal" /></a>
</p>

## Overview

NVD AirCard customizes Apple Wallet card artwork, lock screen passcode dialers, and lock screen wallpapers on device without a jailbreak.

The app communicates with internal system services over a local loopback tunnel (`10.7.0.1` or `127.0.0.1`) provided by LocalDevVPN. File operations are handled by `AirliftFFI`, a Rust library that interfaces with the AirTraffic service.

## Compatibility

| iOS Version | Status | Pairing Method | Features Supported |
| :--- | :--- | :--- | :--- |
| **iOS 27.0 – 27.0.1** | ✅ Supported | On-device Settings or imported pairing file | Wallet skins, Passcode themes, Tendies wallpapers |
| **iOS 27.2 beta 1 – beta 2** | ✅ Supported | On-device Settings or imported pairing file | Tested and working |
| **iOS 18.0 – 26.x** | ✅ Supported | Imported pairing file only | Wallet skins & Passcode themes (via SideStore / LiveContainer / AltStore pairing file) |
| **iOS 27.2 beta 3+** | ❌ Patched | None | Apple patched the underlying `airlift` exploit. Does not work. |

> [!IMPORTANT]
> **Do not update past iOS 27.2 beta 2:** Apple patched the AirTraffic sync exploit in iOS 27.2 beta 3. If you update past beta 2, file injection will no longer work.

## Features

### Apple Wallet card skins
- Writes custom card artwork to Passbook caches (`cardBackgroundCombined@3x.png`, `@2x.png`, and `cardBackgroundCombined.pdf` for transit cards like Suica).
- Flushes front-face and thumbnail caches so new artwork appears immediately when Wallet opens.
- Detects card identifiers in real time when you bring up Apple Pay.
- Apply artwork to individual cards or batch-flash every detected card.

### Passcode dialer themes
- Live dialer preview with touch panning and zoom framing.
- Full poster layout across all ten buttons, or individual circular button cutouts.
- Targets system dialer caches (`TelephonyUI-10`).
- Localized number subtext options, including Ukrainian and Russian Cyrillic layouts.
- Import and export themes as `.passthm` files.

### PosterBoard wallpapers (.tendies)
- Import and unpack `.tendies` wallpaper archives directly from the Files app.
- Auto-detects PosterBoard wallpaper containers and active descriptor UUIDs.
- Injects wallpaper configurations and assets into PosterBoard storage.
- Automatically triggers a NeoSpring respring after flashing to apply wallpapers without rebooting your iPhone.

### Pairing options
- **Import pairing file**: Supports pairing files (`.mobiledevicepairing`, `.plist`, `.mobilepair`) from **SideStore**, **LiveContainer**, **iLoader**, **AltStore**, **Jitterbug**, or exported from Mac/PC.
- **On-device pairing (iOS 27+)**: Advertises locally over Bonjour so the phone can pair with itself via Settings > Privacy & Security > Developer Mode > Pair with NVD AirCard.
- **Safe unpairing**: Easily delete the active pairing file to re-pair or switch pairing credentials at any time.

## Prerequisites

1. **iOS 18.0 – 27.2 beta 2** (iOS 27.0+ for on-device Settings pairing, or imported pairing file on iOS 18–26). Note: iOS 27.2 beta 3+ is patched.
2. **LocalDevVPN / WireGuard**: Running in loopback mode (`10.7.0.1` or `127.0.0.1`) so local connections can reach internal device services.
3. **Pairing record**: Either on-device pairing or an imported pairing file.

## Pairing Setup Guide

NVD AirCard requires a pairing record to communicate with device lockdown services. Choose the method that best matches your setup:

### Option A: SideStore (Recommended)
If you already use SideStore on your device, it has already created a valid pairing file:
1. Open **NVD AirCard** and go to the **Pairing** tab.
2. Tap **Import Pairing File…**.
3. In the Files document picker, navigate to:
   ```text
   On My iPhone › SideStore › ALTPairingFile.mobiledevicepairing
   ```
4. Select `ALTPairingFile.mobiledevicepairing`. The app will load it immediately (`Pairing file loaded ✅`).

### Option B: LiveContainer (with SideStore inside)
If you run SideStore inside LiveContainer:
1. Open **NVD AirCard** › **Pairing** tab › tap **Import Pairing File…**.
2. In the Files document picker, navigate to:
   ```text
   On My iPhone › LiveContainer › SideStore › Documents › ALTPairingFile.mobiledevicepairing
   ```
   *(depending on your LiveContainer version, you can also check `On My iPhone › LiveContainer › Data › App › ... › SideStore › Documents`)*
3. Select `ALTPairingFile.mobiledevicepairing`.

### Option C: iLoader / Jitterbug / AltStore / Computer
- **iLoader / Jitterbug**: In the respective app, export your pairing file (`<UDID>.mobiledevicepairing`) into the Files app, then import it in NVD AirCard.
- **Mac / PC**: Generate a pairing record using `jitterbugpair`, `pymobiledevice3`, or copy it from your computer (`/var/db/lockdown/<UDID>.plist` on macOS or `%ProgramData%\Apple\Lockdown\<UDID>.plist` on Windows), AirDrop/transfer it to your device, and import it into NVD AirCard.
- **Manual placement**: You can also drop any `.mobiledevicepairing` or `.plist` directly into `On My iPhone › NVD AirCard` via the Files app; it will appear under *Discovered in Documents* ready to use.

### Option D: On-Device Pairing (iOS 27+ only)
On devices running iOS 27 or newer:
1. In the **Pairing** tab, tap **Pair This iPhone**.
2. Note the 6-digit PIN displayed on screen.
3. Open **Settings › Privacy & Security › Developer Mode › Pair with NVD AirCard**.
4. Enter the PIN to approve the pairing. NVD AirCard will complete the handshake and save the credentials.

## Installation

Install `NVD-AirCard.ipa` using your preferred sideloading method:

- SideStore or AltStore
- TrollStore
- LiveContainer
- Xcode or iOS App Signer

## Building from source

### Requirements
- macOS 14.0 or newer with Xcode 16 or newer
- XcodeGen (`brew install xcodegen`)
- Rust toolchain (only needed if rebuilding `rust-core`)

### Build the IPA
```bash
git clone https://github.com/mak5er/AirCard-iOS.git
cd AirCard-iOS
./build-ipa.sh
```

The completed package is written to `build/NVD-AirCard.ipa`.

### Rebuilding the Rust framework
To compile changes in `rust-core`:
```bash
./build-ios.sh
```

## Repository structure

```
AirCard-iOS/
├── ios-app/                   # SwiftUI application
│   ├── AirCardApp.swift       # App entry point and lifecycle
│   ├── AppViewModel.swift     # State management and exploit orchestration
│   ├── ContentView.swift      # Main UI views
│   ├── TendiesView.swift      # PosterBoard wallpaper view
│   ├── TendiesEngine.swift    # Tendies extraction and injection logic
│   ├── RespringHelper.swift   # NeoSpring WebKit respring implementation
│   ├── Models.swift           # Image slicing, theme layout, archive packing
│   ├── PairingController.swift# Bonjour host and pairing sync
│   ├── NetworkStatus.swift    # VPN loopback detection
│   ├── Utilities.swift        # Background keep-alive and helper functions
│   ├── GrappaHelper.[h,m]     # ATC protocol helpers
│   ├── Info.plist             # Bundle configuration
│   └── Assets.xcassets/       # App icons and image sets
├── AirliftFFI.xcframework/    # Compiled arm64 Rust static library and headers
├── rust-core/                 # Rust core source code
├── project.yml                # XcodeGen project definition
├── build-ipa.sh               # IPA build script
├── build-ios.sh               # Rust framework build script
├── LICENSE                    # MIT License
└── README.md                  # Project documentation
```

## Credits

- **[@mak5er](https://github.com/mak5er)**: Lead developer, UI, passcode theming, Tendies engine, on-device pairing.
- **[@merybist](https://github.com/merybist)**: Initial base port.
- **[AirLift](https://github.com/0xjohnnydev/airlift)** by **[0xjohnny (@0xjohnnydev)](https://github.com/0xjohnnydev)**: AirTraffic and ATAirlock sandbox escape research underlying `AirliftFFI`.
- **[NeoSpring](https://github.com/rooootdev/neospring)**: Swift implementation by **[@skadz108](https://github.com/skadz108)** and **[@rooootdev](https://github.com/rooootdev)**, and **[@neonmodder123](https://github.com/neonmodder123)** for the WebKit GPU process respring technique.
- Built upon concepts from the **AirCard** project.

## Support & Donations

If you want to support AirCard-iOS development by **[@mak5er](https://github.com/mak5er)**:

- **Twitter / X**: [@mak5er](https://x.com/mak5er)
- **GitHub**: [@mak5er](https://github.com/mak5er)
- **PayPal**: [Donate via PayPal (Maksym Reva)](https://www.paypal.com/donate/?hosted_button_id=98QRTC2HFRA4Y)
- **TON**: `UQBm9KPhtMw-XVVjirUoa09wzrlyWsbeZhKfefl1Uw-qNZ-r`
- **USDT (TRC20)**: `TDkDMCyjYxgvkWUnQiF5Erk2RyPQMT6G1n`
- **USDT / BNB (BEP20)**: `0x0954dc491c502849d04956ef74634aa5931a08e8`

## License

MIT License. See [LICENSE](LICENSE) for details.

---

# Tiếng Việt

> **NVD AirCard** là bản cá nhân hoá NVD từ [AirCard-iOS](https://github.com/Mak5er/AirCard-iOS) của [@mak5er](https://github.com/mak5er) (giấy phép MIT). Đổi tên, bundle ID (`com.NVD.aircard`), icon và giao diện sang thương hiệu NVD; mọi tính năng và ghi công tác giả gốc được giữ nguyên.

## Mô tả

NVD AirCard đổi giao diện iPhone ngay trên máy, không cần jailbreak:

- **Đổi ảnh thẻ Apple Wallet** — thay artwork của thẻ trong Wallet (ghi vào Passbook caches, làm mới cache để hiện ngay khi mở Wallet).
- **Theme bàn phím passcode** — đổi giao diện bàn phím màn hình khoá, import/export theme dạng file `.passthm`.
- **Hình nền PosterBoard (.tendies)** — flash file `.tendies` vào PosterBoard, tự respring bằng NeoSpring (không cần khởi động lại máy).

Ứng dụng giao tiếp với dịch vụ hệ thống qua tunnel loopback nội bộ (`10.7.0.1` hoặc `127.0.0.1`) do app LocalDevVPN cung cấp; thao tác file do thư viện Rust `AirliftFFI` đảm nhiệm qua dịch vụ AirTraffic.

## Cài đặt

1. Tải file `NVD-AirCard-1.3.3.ipa` (bản cuối) trong mục Releases của repo này.
2. Cài bằng chứng chỉ cá nhân qua một trong các cách sau:
   - **SideStore** hoặc **AltStore**
   - **TrollStore**
   - **LiveContainer**
   - Xcode hoặc iOS App Signer
3. Cần **app LocalDevVPN** (trên App Store) chạy ở chế độ loopback.
4. Cần **pairing file** để app kết nối dịch vụ lockdown của máy — lấy từ SideStore (`ALTPairingFile.mobiledevicepairing`), LiveContainer, AltStore, iLoader, Jitterbug, hoặc xuất từ Mac/PC. Trên iOS 27+ có thể pairing trực tiếp trên máy: Cài đặt › Quyền riêng tư & Bảo mật › Chế độ nhà phát triển › Ghép đôi với NVD AirCard, nhập mã PIN 6 số hiện trên app.

## Cách dùng cơ bản

1. Mở **LocalDevVPN**, bật chế độ loopback.
2. Mở **NVD AirCard** › tab **Pairing**: import pairing file, hoặc bấm **Pair This iPhone** (iOS 27+) rồi nhập PIN trong Cài đặt.
3. Chọn tính năng muốn dùng:
   - **Wallet**: mở Apple Pay để app nhận diện thẻ theo thời gian thực, chọn thẻ rồi áp artwork mới.
   - **Passcode**: xem trước theme bàn phím trực tiếp, chỉnh khung hình rồi áp theme (hoặc import file `.passthm`).
   - **Tendies**: import file `.tendies` từ app Tệp, app tự flash vào PosterBoard và respring để áp hình nền.

## Hỗ trợ iOS

| Phiên bản iOS | Trạng thái |
| :--- | :--- |
| iOS 18.0 – 26.x | ✅ Hỗ trợ (chỉ pairing file import) |
| iOS 27.0 – 27.0.1 | ✅ Hỗ trợ (pairing trên máy hoặc import file) |
| iOS 27.2 beta 1 – beta 2 | ✅ Hỗ trợ |
| iOS 27.2 beta 3 trở lên | ❌ Không hỗ trợ |

> [!IMPORTANT]
> **Đừng cập nhật quá iOS 27.2 beta 2:** Apple đã vá lỗ hổng Airlift (AirTraffic sync exploit) từ iOS 27.2 beta 3, nên từ bản đó trở đi app không chèn file được nữa.
