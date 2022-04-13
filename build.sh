#!/bin/bash
set -eE
trap 'printf "\e[31m%s: %s\e[m\n" "ERROR($?): $BASH_SOURCE:$LINENO $BASH_COMMAND"' ERR

TARGET="Lottie"
BUILD="build"
ARCHIVES="$BUILD/archives"
XCF="$BUILD/xcf"
BINDINGS="$BUILD/bindings"

xcodebuild archive \
 -project "Lottie.xcodeproj" \
 -scheme "Lottie" \
 -archivePath "$ARCHIVES/macCatalyst.xcarchive" \
 -sdk iphoneos \
 -destination 'platform=macOS,variant=Mac Catalyst' \
 -configuration Release \
 SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES SUPPORTS_MACCATALYST=YES

xcodebuild archive \
 -project "Lottie.xcodeproj" \
 -scheme "Lottie" \
 -archivePath "$ARCHIVES/iOS-simulator.xcarchive" \
 -sdk iphonesimulator \
 -destination 'generic/platform=iOS Simulator' \
 -configuration Release \
 SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild archive \
 -project "Lottie.xcodeproj" \
 -scheme "Lottie" \
 -archivePath "$ARCHIVES/iOS.xcarchive" \
 -sdk iphoneos \
 -destination 'generic/platform=iOS' \
 -configuration Release \
 SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild archive \
 -project "Lottie.xcodeproj" \
 -scheme "Lottie_tvOS" \
 -archivePath "$ARCHIVES/tvOS-simulator.xcarchive" \
 -sdk appletvsimulator \
 -destination 'generic/platform=tvOS Simulator' \
 -configuration Release \
 SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild archive \
 -project "Lottie.xcodeproj" \
 -scheme "Lottie_tvOS" \
 -archivePath "$ARCHIVES/tvOS.xcarchive" \
 -sdk appletvos \
 -destination 'generic/platform=tvOS' \
 -configuration Release \
 SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild archive \
 -project "Lottie.xcodeproj" \
 -scheme "Lottie_macOS" \
 -archivePath "$ARCHIVES/macOS.xcarchive" \
 -sdk macosx \
 -destination 'generic/platform=macOS' \
 -configuration Release \
 SKIP_INSTALL=NO BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

xcodebuild -create-xcframework \
 -framework "$ARCHIVES/tvOS-simulator.xcarchive/Products/Library/Frameworks/$TARGET.framework" \
 -framework "$ARCHIVES/tvOS.xcarchive/Products/Library/Frameworks/$TARGET.framework" \
 -framework "$ARCHIVES/iOS-simulator.xcarchive/Products/Library/Frameworks/$TARGET.framework" \
 -framework "$ARCHIVES/iOS.xcarchive/Products/Library/Frameworks/$TARGET.framework" \
 -framework "$ARCHIVES/macCatalyst.xcarchive/Products/Library/Frameworks/$TARGET.framework" \
 -framework "$ARCHIVES/macOS.xcarchive/Products/Library/Frameworks/$TARGET.framework" \
 -output "$XCF/$TARGET.xcframework"

sharpie bind -sdk iphoneos -o "$BINDINGS/ios" -n Airbnb.Lottie -scope $XCF/$TARGET.xcframework/ios-arm64_armv7/$TARGET.framework/Headers $XCF/$TARGET.xcframework/ios-arm64_armv7/$TARGET.framework/Headers/$TARGET.h
sharpie bind -sdk macosx -o "$BINDINGS/mac" -n Airbnb.Lottie -scope $XCF/$TARGET.xcframework/macos-arm64_x86_64/$TARGET.framework/Headers $XCF/$TARGET.xcframework/macos-arm64_x86_64/$TARGET.framework/Headers/$TARGET.h
