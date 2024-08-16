#!/bin/bash

# Set the name of the framework and paths
FRAMEWORK_NAME="DogImageLibrary"
BUILD_DIR="build"
CONFIGURATION="Release"

# Clean previous builds
rm -rf "${BUILD_DIR}"
xcodebuild clean

# Build the framework for iOS devices
xcodebuild archive \
  -scheme "${FRAMEWORK_NAME}" \
  -configuration ${CONFIGURATION} \
  -destination "generic/platform=iOS" \
  -archivePath "${BUILD_DIR}/iOS" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Build the framework for iOS simulators
xcodebuild archive \
  -scheme "${FRAMEWORK_NAME}" \
  -configuration ${CONFIGURATION} \
  -destination "generic/platform=iOS Simulator" \
  -archivePath "${BUILD_DIR}/iOS-Simulator" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Build the framework for macOS
xcodebuild archive \
  -scheme "${FRAMEWORK_NAME}" \
  -configuration ${CONFIGURATION} \
  -destination "generic/platform=macOS" \
  -archivePath "${BUILD_DIR}/macOS" \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# Create the XCFramework
xcodebuild -create-xcframework \
  -framework "${BUILD_DIR}/iOS.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
  -framework "${BUILD_DIR}/iOS-Simulator.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
  -framework "${BUILD_DIR}/macOS.xcarchive/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework" \
  -output "${BUILD_DIR}/${FRAMEWORK_NAME}.xcframework"

# Optionally, clean up the build directory
rm -rf "${BUILD_DIR}/iOS.xcarchive"
rm -rf "${BUILD_DIR}/iOS-Simulator.xcarchive"
rm -rf "${BUILD_DIR}/macOS.xcarchive"

echo "XCFramework has been created at ${BUILD_DIR}/${FRAMEWORK_NAME}.xcframework"
