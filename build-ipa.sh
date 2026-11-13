#!/bin/bash
set -euo pipefail

CONFIG="${1:-Release}"

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

echo "==> Building NVD AirCard ($CONFIG)..."
rm -rf build/DerivedData build/Payload build/*.app build/*.ipa
mkdir -p build

xcodebuild -project AirCard-iOS.xcodeproj \
    -scheme AirCard-iOS \
    -configuration "$CONFIG" \
    -derivedDataPath build/DerivedData \
    -destination 'generic/platform=iOS' \
    clean build \
    CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGN_ENTITLEMENTS="" CODE_SIGNING_ALLOWED="NO"

APP_PATH="$(find build/DerivedData/Build/Products -name "NVD AirCard.app" -type d | head -n 1)"
if [ -z "$APP_PATH" ] || [ ! -d "$APP_PATH" ]; then
    echo "Error: NVD AirCard.app not found in DerivedData"
    exit 1
fi

echo "==> Packaging IPA..."
cp -R "$APP_PATH" "build/NVD AirCard.app"

# Clean any existing signature
rm -rf "build/NVD AirCard.app/_CodeSignature"
rm -rf "build/NVD AirCard.app/embedded.mobileprovision"

mkdir -p build/Payload
cp -R "build/NVD AirCard.app" "build/Payload/NVD AirCard.app"

cd build
zip -qr "NVD-AirCard.ipa" Payload
rm -rf Payload "NVD AirCard.app"

echo "==> Done! IPA generated at: $ROOT/build/NVD-AirCard.ipa"
ls -lh "$ROOT/build/NVD-AirCard.ipa"
