#!/bin/bash
cd "$(dirname "$0")"
flutter build macos --debug 2>&1 | grep -v "resource fork\|CodeSign failed\|BUILD FAILED"
APP="build/macos/Build/Products/Debug/krishios.app"
if [ -d "$APP" ]; then
  find "$APP" -exec xattr -d com.apple.FinderInfo {} \; 2>/dev/null
  find "$APP" -exec xattr -d com.apple.provenance {} \; 2>/dev/null
  codesign --force --deep --sign - "$APP" 2>/dev/null
  open "$APP"
  echo "KrishiOS launched!"
else
  echo "Build failed."
fi
