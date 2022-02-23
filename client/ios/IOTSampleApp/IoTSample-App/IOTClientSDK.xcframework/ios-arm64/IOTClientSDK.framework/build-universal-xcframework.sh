#! /usr/bin/env bash

#  build-universal-xcframework.sh
#  IOTClientSDK
#
#  Created by rohan-elear on 10/01/21.
#
set -e

BUILD_DIR=build
OUTPUT_DIR=DerivedData

# parse options
while [ $# -gt 0 ]
do
  case "$1" in
    --channel | -c) CONAN_PKG_CHANNEL_NAME="$2" ; shift ;;
  esac
shift
done

if [ "$CONAN_PKG_CHANNEL_NAME" == "" ]; then
  CONAN_PKG_CHANNEL_NAME=master
fi

sh ./CIOTClientSDK/fetch-conan-libs.sh --channel ${CONAN_PKG_CHANNEL_NAME}

NAME=IOTClientSDK

# clean build folders
if [ -d ${BUILD_DIR} ]; then
  rm -rf ${BUILD_DIR}
fi

if [ -d ${OUTPUT_DIR} ]; then
  rm -rf ${OUTPUT_DIR}
fi

if [ -d "${NAME}.xcframework" ]; then
  rm -rf "${NAME}.xcframework"
fi

mkdir ${BUILD_DIR}
mkdir ${OUTPUT_DIR}

# iOS devices
TARGET=iOS
xcodebuild archive \
  -workspace ${NAME}.xcworkspace \
  -scheme ${NAME}-${TARGET}-${CONAN_PKG_CHANNEL_NAME} \
  SYMROOT=$(PWD)/build \
  -archivePath "./${OUTPUT_DIR}/${NAME}-iphoneos-${CONAN_PKG_CHANNEL_NAME}.xcarchive" \
  -sdk iphoneos \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# iOS simulator
TARGET=iOS
xcodebuild archive \
  -workspace ${NAME}.xcworkspace \
  -scheme ${NAME}-${TARGET}-${CONAN_PKG_CHANNEL_NAME} \
  SYMROOT=$(PWD)/build \
  -archivePath "./${OUTPUT_DIR}/${NAME}-iphonesimulator-${CONAN_PKG_CHANNEL_NAME}.xcarchive" \
  -sdk iphonesimulator \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# macOS devices
TARGET=macOS
xcodebuild archive \
  -workspace ${NAME}.xcworkspace \
  -scheme ${NAME}-${TARGET}-${CONAN_PKG_CHANNEL_NAME} \
  SYMROOT=$(PWD)/build \
  -archivePath "./${OUTPUT_DIR}/${NAME}-macosx-${CONAN_PKG_CHANNEL_NAME}.xcarchive" \
  -sdk macosx \
  SKIP_INSTALL=NO \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES

# packing .framework to .xcframework
FWMK_FILES=$(find "./${OUTPUT_DIR}" -name "*.framework")
for FWMK_FILE in ${FWMK_FILES}
do
  FWMK_FILES_CMD="-framework ${FWMK_FILE} ${FWMK_FILES_CMD}"
done

xcodebuild -create-xcframework \
  ${FWMK_FILES_CMD} \
  -output "${NAME}.xcframework"
