# NVD AirCard — bản cá nhân hoá từ Mak5er/AirCard-iOS v1.3.2

Chuẩn bị ngày 13/11/2026 (anh Dũng chốt "thử xem"). Thư mục làm việc:
`~/workspace/aircard-check/nvd/` — copy từ `~/workspace/aircard-check/repo/`
(HEAD gốc `40640c4`, Mak5er/AirCard-iOS v1.3.2, MIT). Repo gốc KHÔNG bị sửa.
Tổng dung lượng thư mục: 154 MB (chủ yếu là `AirliftFFI.xcframework`).

## Đã sửa gì

### 1. Tên app + bundle ID (project.yml, project.pbxproj)
- `PRODUCT_NAME`: `AirCard-iOS` → `NVD AirCard` (cả Debug + Release, cả 2 file).
- `PRODUCT_BUNDLE_IDENTIFIER`: `com.mak5er.aircard` → `com.NVD.aircard`;
  tests: `com.mak5er.aircard.tests` → `com.NVD.aircard.tests`.
- `bundleIdPrefix` trong project.yml: `com.mak5er` → `com.NVD`.
- `TEST_HOST` trong project.pbxproj (2 chỗ): `$(BUILT_PRODUCTS_DIR)/AirCard-iOS.app/AirCard-iOS`
  → `$(BUILT_PRODUCTS_DIR)/NVD AirCard.app/NVD AirCard`.
- `MARKETING_VERSION` giữ nguyên **1.3.2** (cả 2 file).
- `CFBundleName` trong Info.plist là `$(PRODUCT_NAME)` nên tự theo;
  `CFBundleDisplayName` đổi tay thành `NVD AirCard` (tên hiện trên màn hình chính).

### 2. Icon lợn xanh nền mận (5 file, ghi đè trong AppIcon.appiconset)
Nguồn: `~/workspace/user/files/minion-pig01_96760.ico` (MD5
`498cd8f27d49cabcfc28615ca0a3482f`, 128×128 RGBA trong suốt — đúng file chuẩn).
Lợn chiếm 88% khung trên nền mận RGB(121,26,60), resize LANCZOS, không bo tròn
(iOS tự bo). Nguồn 128px nên upscale lên 1024 hơi mềm — chấp nhận như bản
LiveContainer trước. `Contents.json` giữ nguyên.
- `AppIcon.png` 1024×1024, `AppIcon-60@3x.png` 180×180, `AppIcon-60@2x.png`
  120×120, `AppIcon-76@2x.png` 152×152, `AppIcon-83.5@2x.png` 167×167.
  Đã kiểm tra kích thước từng file bằng PIL — đủ 5/5.

### 3. Màu mận
- Mới: `ios-app/Assets.xcassets/AccentColor.colorset/Contents.json`,
  màu RGB(121,26,60) (red 0.475, green 0.102, blue 0.235).
- `ContentView.swift` dòng 173: gradient header xanh
  `[Color.blue, Color(red: 0.05, green: 0.35, blue: 0.85)]` →
  gradient mận `[Color(red: 121/255, green: 26/255, blue: 60/255),
  Color(red: 90/255, green: 18/255, blue: 45/255)]`.
- Các `.blue` khác KHÔNG đụng (accent, badge, nút…), tránh rủi ro.

### 4. Chuỗi thương hiệu hiển thị ("AirCard-iOS" → "NVD AirCard")
- `ContentView.swift`: 13 dòng — "Welcome to NVD AirCard!",
  "Continue to NVD AirCard", 2 tiêu đề header, "Thank you so much for
  supporting NVD AirCard development!", hướng dẫn import pairing file,
  "On My iPhone › NVD AirCard" (2 chỗ), "Pair with NVD AirCard",
  `.navigationTitle("NVD AirCard")`, "Return to NVD AirCard",
  Section "Themes in App Folder (On My iPhone › NVD AirCard)".
- `PairingController.swift`: 3 dòng — `hostName = "NVD AirCard"` (tên Bonjour
  hiện trong Settings › Developer Mode khi pairing), thông báo lỗi Local
  Network ("Settings › NVD AirCard › Local Network"), hướng dẫn nhập PIN
  ("Pair with NVD AirCard").
- `TendiesView.swift`: 1 dòng — hướng dẫn copy wallpaper vào
  "On My iPhone › NVD AirCard".
- `Info.plist`: 3 dòng — `CFBundleDisplayName`, `NSLocalNetworkUsageDescription`,
  `NSPhotoLibraryUsageDescription`.
- `README.md`: 12 dòng hướng dẫn (mô tả app, pairing, import file, "Pair with
  NVD AirCard", tên file IPA `NVD-AirCard.ipa`, đường dẫn build) + khối ghi chú
  đầu file (xem §6).

### 5. KHÔNG dịch tiếng Việt ở bản này
Repo ~7.590 dòng Swift, không có localisation sẵn — để bản v2. Ghi rõ để khỏi quên.

### 6. Ghi công tác giả gốc — giữ nguyên
- `LICENSE` (MIT) giữ nguyên, không sửa.
- Đầu `README.md` thêm: "Bản cá nhân hoá NVD từ AirCard-iOS của @mak5er
  (giấy phép MIT). Đổi tên/bundle ID/icon/giao diện sang thương hiệu NVD;
  mọi tính năng và ghi công tác giả gốc được giữ nguyên." + link repo gốc.
- Credit trong app giữ nguyên: "Developed by @mak5er", "Support @mak5er
  Development", link github.com/mak5er / x.com/mak5er trong ContentView
  (không xoá).

### 7. Build script + workflow CI
- `build-ipa.sh` (đã có sẵn, dùng xcodebuild, ký unsigned): cập nhật theo tên
  mới — tìm `NVD AirCard.app`, đóng gói ra `build/NVD-AirCard.ipa`
  (tên file không dấu cách). Scheme vẫn là `AirCard-iOS`, project vẫn là
  `AirCard-iOS.xcodeproj` (tên nội bộ, xem § "Còn lại"). `bash -n` kiểm tra
  cú pháp OK.
- Mới: `.github/workflows/build-ipa.yml` — chạy trên `xcode-27` +
  `maxim-lobanov/setup-xcode@v1` (Xcode 27.2), đúng cấu hình đã chạy thành
  công cho LiveContainer; trigger `workflow_dispatch` + push lên `main`;
  chạy `./build-ipa.sh Release`, upload artifact tên `NVD-AirCard-ipa`
  (đường dẫn `build/NVD-AirCard.ipa`). Chỉ build, không ký, không publish
  release. YAML đã kiểm tra bằng `yaml.safe_load` (lưu ý: PyYAML đọc key
  `on` thành `True` — đó là quirk của PyYAML, workflow vẫn hợp lệ trên
  GitHub Actions).

## Còn lại "AirCard-iOS" / "AirCard" — có lý do, KHÔNG phải sót

- **Tên project/target/scheme nội bộ** (`AirCard-iOS.xcodeproj`,
  `AirCard-iOS.xcscheme`, target `AirCard-iOS`/`AirCard-iOSTests` trong
  project.yml + project.pbxproj, `BlueprintName` trong scheme): giữ nguyên
  để khỏi vỡ reference; người dùng không nhìn thấy. Chỉ `BuildableName`
  trong scheme đã đổi thành `NVD AirCard.app` cho khớp PRODUCT_NAME mới.
  `PBXFileReference path = "AirCard-iOS.app"` trong pbxproj cũng giữ nguyên
  — Xcode tự đồng bộ theo PRODUCT_NAME khi mở project.
- **Identifier nội bộ**: thread `"AirCard.SyslogScanner"`, service Bonjour
  probe `"AirCardProbe"`, tên file `"AirCard_Custom_...passthm"`,
  UTType `com.aircard.passthm` / `com.aircard.tendies` trong Info.plist,
  key UserDefaults `"mak5er.savedCards"`, struct `AirCardApp`.
  Đổi các thứ này không có lợi mà có thể vỡ file .passthm/.tendies đã có
  hoặc mất dữ liệu đã lưu.
- **Comment trong code** ("Authentic AirCard Style", "matching AirCard
  macOS", "AirCard pattern", header `// AirCard-iOS` ở 4 file): giữ nguyên.
- **README**: còn "AirCard-iOS" ở link repo gốc (dòng 3), tiêu đề gốc (dòng 5),
  lệnh `git clone https://github.com/mak5er/AirCard-iOS.git` + `cd AirCard-iOS`
  (dòng 127–128), cây thư mục (dòng 143), dòng donate cho @mak5er (dòng 177).
  Khi đẩy lên fork nvd29u1 thì lệnh clone sẽ đổi sang URL fork.
- **"com.mak5er"**: đã hết hoàn toàn trong toàn repo (grep = 0).

## Chưa kiểm chứng được (cần CI/Mac)
- Chưa build thử: máy Linux không chạy được xcodebuild. Lần chạy CI đầu tiên
  có thể lòi lỗi (vd: scheme BuildableName, AccentColor, PRODUCT_NAME có dấu
  cách trong TEST_HOST). Nếu CI lỗi, đọc log rồi sửa.
- Chưa chạy trên iPhone thật. Sau khi có IPA: ký qua SideStore (không cần
  App Group — AirCard không dùng entitlements), bật LocalDevVPN, import
  pairing file SideStore (`ALTPairingFile.mobiledevicepairing`) trong tab
  Pairing của app.
- Lưu ý cho máy anh Dũng (iOS 27.0 build 24A437): AirCard hỗ trợ 27.0–27.0.1,
  không có cổng chặn version kiểu EnsWilde; nhưng đừng lên quá iOS 27.2 beta 2
  (Apple vá Airlift từ beta 3).

## Bước tiếp theo cho agent chính
1. Fork Mak5er/AirCard-iOS về **nvd29u1** (tên repo gợi ý: `NVD-AirCard` hoặc
   giữ `AirCard-iOS` — nếu giữ tên cũ thì URL clone trong README vẫn đúng).
2. Đẩy toàn bộ nội dung `~/workspace/aircard-check/nvd/` lên fork (nhánh
   `main`), **không** đẩy thư mục `.git` cũ (đã xoá) và không đẩy file này
   (`NOTES.md` là ghi chú nội bộ — có thể giữ lại trong fork hoặc bỏ;
   nếu giữ thì không ảnh hưởng build).
   **CẢNH BÁO .gitignore (đã sửa sẵn, đọc kỹ):** `.gitignore` gốc chặn
   `*.xcodeproj/` và `AirliftFFI.xcframework/` — repo gốc chỉ có các file này
   vì đã force-add từ trước. Nếu đẩy bằng `git add .` mà không có ngoại lệ
   thì fork sẽ THIẾU `project.pbxproj` + toàn bộ xcframework → CI lỗi ngay.
   Đã thêm 2 dòng ngoại lệ (`!AirCard-iOS.xcodeproj/`,
   `!AirliftFFI.xcframework/`) vào cuối `.gitignore` và kiểm chứng bằng
   `git add -n` trên repo thử: sau khi sửa, `git add .` đã nhận đủ cả
   `.xcodeproj` và `xcframework`. Sau khi `git add`, kiểm tra lại bằng
   `git status` rằng `AirCard-iOS.xcodeproj/project.pbxproj` và
   `AirliftFFI.xcframework/ios-arm64/libairlift_ffi.a` có trong danh sách
   staged trước khi commit.
3. Vào repo fork trên GitHub → Settings → Actions → bật Actions (repo fork
   mặc định Actions tắt cho workflow từ fork — cần bật tay).
4. Chạy workflow "Build NVD AirCard IPA" (Actions → Run workflow).
5. Tải artifact `NVD-AirCard-ipa` → file `NVD-AirCard.ipa` (unsigned),
   kiểm tra SHA256 + bundle `com.NVD.aircard` + version 1.3.2 rồi gửi anh Dũng
   qua SideStore như mọi IPA khác.
6. Nếu CI lỗi: gửi log lỗi lại cho subagent để sửa (khả năng cao chỉ là lỗi
   nhỏ ở scheme/tên file, không phải lỗi logic).

## Danh sách file thay đổi so với gốc (để đẩy lên fork)
- Sửa: `project.yml`, `AirCard-iOS.xcodeproj/project.pbxproj`,
  `AirCard-iOS.xcodeproj/xcshareddata/xcschemes/AirCard-iOS.xcscheme`,
  `ios-app/ContentView.swift`, `ios-app/PairingController.swift`,
  `ios-app/TendiesView.swift`, `ios-app/Info.plist`, `README.md`,
  `build-ipa.sh`, `.gitignore` (thêm 2 dòng ngoại lệ để `git add .` không bỏ
  qua `.xcodeproj` + `xcframework` — xem cảnh báo dưới), 5 file icon trong
  `ios-app/Assets.xcassets/AppIcon.appiconset/` (giữ nguyên Contents.json).
- Mới: `ios-app/Assets.xcassets/AccentColor.colorset/Contents.json`,
  `.github/workflows/build-ipa.yml`.
- Không đổi: `LICENSE`, `AirliftFFI.xcframework`, `rust-core/`, `tests/`,
  các file Swift còn lại, `build-ios.sh`.

---

## v1.1 — Xoá bảng donate lúc mở app + màn Credits (13/11/2026, theo yêu cầu anh Dũng)

Anh Dũng đã cài bản 1.3.2 và gửi 2 ảnh: bảng "Support Creator" hiện lúc mở app và
màn "Credits" (banner Support @mak5er, thẻ @mak5er/@merybist, các dòng credit kỹ
thuật). Anh yêu cầu xoá cả hai — anh dùng nên không cần. Ghi công ở mức repo
(LICENSE MIT + README) giữ nguyên, chỉ xoá phần hiển thị trong app.

### Đã xoá (chỉ sửa ios-app/ContentView.swift, 2840 → 2370 dòng)
- `CryptoDonationRow` (dòng cũ 27–82): hàng donate crypto (TON/USDT/BEP20 + nút Copy).
- `DonateView` (dòng cũ 84–214): toàn bộ thẻ tác giả Maksym Reva, link Twitter/X +
  GitHub, nút Donate PayPal, 3 hàng crypto, dòng cảm ơn.
- `SupportPopupSheet` (dòng cũ 216–285): bảng "Support Creator" lúc mở app, gồm
  nút "Continue to NVD AirCard", toggle "Don't show this popup on startup".
- `CreditsSheet` (dòng cũ 287–537): màn Credits 2 tab (Credits / Donate ❤️),
  banner "Support @mak5er Development", thẻ "Lead & Core Developer @mak5er",
  thẻ "Base IPA Developer @merybist", các dòng "Core Exploit airlift",
  "Passcode Themes .passthm standard (Cowabunga / Nugget)",
  "NeoSpring & PosterBoard".
- Cơ chế hiện bảng lúc mở app trong `ContentView` (root): xoá
  `@AppStorage("aircard.dont_show_support_on_launch")`, `@State showSupportPopup`,
  `.sheet(isPresented: $showSupportPopup)` và khối trigger trong `.onAppear`
  (chỉ giữ 2 dòng reset `vm.showSuccessAlert` / `vm.successAlertMessage`).

### Thay bằng màn About tối giản
- Struct mới `AboutSheet` (dòng 27–75): chỉ còn icon, tên "NVD AirCard", dòng mô tả
  "Apple Wallet Skins & Passcode Themes (iOS 18.0 – 27.2 b2)", dòng "Version X"
  (lấy từ `CFBundleShortVersionString` trong Bundle, tự theo version build),
  navigationTitle "About", nút Done. Giữ `.presentationDetents([.medium, .large])`.
- 3 nút mở màn này giữ nguyên vị trí, đổi nhãn/icon:
  - PairingTab: nút capsule hồng "Credits & Donate" (heart.fill) → "About" (info.circle).
  - WalletCardsTab (menu …): `Label("Credits & Donate", heart.fill)` → `Label("About", info.circle)`.
  - PasscodeThemeTab: nút heart.fill hồng → info.circle.
  - State `showCredits` (3 chỗ) đổi tên → `showAbout`, sheet mở `AboutSheet()`.

### Version 1.3.2 → 1.3.3
- `project.yml` (MARKETING_VERSION + CURRENT_PROJECT_VERSION) và
  `AirCard-iOS.xcodeproj/project.pbxproj` (2 × CURRENT_PROJECT_VERSION,
  2 × MARKETING_VERSION, cả Debug + Release).

### Kiểm tra
- `swiftc -parse ios-app/ContentView.swift`: PASS (không lỗi). Lưu ý: chỉ kiểm tra
  cú pháp, không biên dịch/type-check được trên Linux (cần Xcode/macOS); bản build
  CI đầu tiên sẽ là kiểm chứng thật. (Trong lúc sửa từng gặp 1 lỗi cú pháp do
  ký tự en-dash viết thành `\u2013`, đã sửa thành ký tự – thật, parse lại sạch.)
- Cân bằng ngoặc `{}`/`()`/`[]` = 0/0/0.
- Grep toàn `ios-app/*.swift`: còn 0 kết quả cho "Support Creator",
  "dont_show_support", "showSupportPopup", "@mak5er", "@merybist", "Donate",
  "Credits", "CreditsSheet", "DonateView", "SupportPopupSheet", "CryptoDonationRow".
- Còn sót có chủ ý (không phải lỗi):
  - `AppViewModel.swift:112,624`: key UserDefaults nội bộ `"mak5er.savedCards"`
    (lưu hash thẻ Wallet đã quét). KHÔNG đổi vì đổi key sẽ làm mất danh sách thẻ
    đã lưu khi anh nâng cấp từ 1.3.2 lên 1.3.3; chuỗi này không hiển thị trong app.
  - `README.md` (dòng 3, 20, 127, 169–181): ghi công + link donate + link repo gốc
    của tác giả — giữ nguyên theo yêu cầu (ghi công mức repo).
  - `LICENSE` (MIT) giữ nguyên.

### File cần đẩy lên fork (so với bản 1.3.2 đã đẩy)
- Chỉ 3 file thay đổi: `ios-app/ContentView.swift`, `project.yml`,
  `AirCard-iOS.xcodeproj/project.pbxproj`. (Các file khác của bản 1.3.2 giữ nguyên;
  KHÔNG đẩy NOTES.md.) Sau khi đẩy, chạy workflow "Build NVD AirCard IPA" —
  artifact ra `build/NVD-AirCard.ipa`, version trong app sẽ là 1.3.3.
