# To run krishiOS on mac:
cd "/Users/biswyaa/Documents/krishios(mobile app)/krishios_app"
./run_macos.sh


# How to Run KrishiOS on iOS Simulator

## 1. Boot the Simulator

```sh
xcrun simctl boot "iPhone 17 Pro"
open -a Simulator
```

## 2. Build the App

```sh
cd "/Users/biswyaa/Documents/krishios(mobile app)/krishios_app/ios"
xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Debug \
  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  build -quiet
```

## 3. Install & Launch

```sh
xcrun simctl install booted \
  "/Users/biswyaa/Library/Developer/Xcode/DerivedData/Runner-fsabsmcauybigobhfflcwnrkhbrv/Build/Products/Debug-iphonesimulator/Runner.app"
xcrun simctl launch booted com.krishios.krishios
```

## All-in-One Command

```sh
cd "/Users/biswyaa/Documents/krishios(mobile app)/krishios_app" && \
xcrun simctl boot "iPhone 17 Pro" 2>/dev/null; \
open -a Simulator && \
sleep 5 && \
cd ios && \
xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Debug \
  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17 Pro' \
  build -quiet && \
APP=$(find ~/Library/Developer/Xcode/DerivedData -path "*/Debug-iphonesimulator/Runner.app" \
  -not -path "*/Index.noindex/*" -type d | head -1) && \
xcrun simctl install booted "$APP" && \
xcrun simctl launch booted com.krishios.krishios
```
