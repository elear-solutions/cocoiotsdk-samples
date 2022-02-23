#! /usr/bin/env bash

#  build-universal-framework.sh
#  IOTClientSDK
#
#  Created by rohan-elear on 12/01/21.
#  Copyright © 2021 Elear Solutions. All rights reserved.

# create folder where we place built frameworks
set -e

BUILD_DIR=build
DERIVED_DATA=DerivedData
FWMK_PATH=""

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

case "${CONAN_PKG_CHANNEL_NAME}" in
  master) FWMK_PATH=Production;;
  release) FWMK_PATH=Release;;
  develop) FWMK_PATH=Development;;
esac

NAME=IOTClientSDK
# clean build folders
rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}

rm -rf ${DERIVED_DATA}
mkdir ${DERIVED_DATA}

mkdir ${BUILD_DIR}/devices
mkdir ${BUILD_DIR}/simulator
mkdir ${BUILD_DIR}/universal

# iOS devices
TARGET=iOS
xcodebuild clean build \
  -project ${NAME}.xcodeproj \
  -scheme ${NAME}-${TARGET}-${CONAN_PKG_CHANNEL_NAME} \
  -sdk iphoneos \
  -derivedDataPath ${DERIVED_DATA}
cp -r ${DERIVED_DATA}/Build/Products/*/${NAME}.framework ${BUILD_DIR}/devices

# iOS simulators
TARGET=iOS
xcodebuild clean build \
  -project ${NAME}.xcodeproj \
  -scheme ${NAME}-${TARGET}-${CONAN_PKG_CHANNEL_NAME} \
  -sdk iphonesimulator \
  -derivedDataPath ${DERIVED_DATA}
cp -r ${DERIVED_DATA}/Build/Products/*/${NAME}.framework ${BUILD_DIR}/simulator

# copy device framework into universal folder
cp -r ${BUILD_DIR}/devices/${NAME}.framework ${BUILD_DIR}/universal/

lipo -create \
  ${BUILD_DIR}/simulator/${NAME}.framework/${NAME} \
  ${BUILD_DIR}/devices/${NAME}.framework/${NAME} \
  -output ${BUILD_DIR}/universal/${NAME}.framework/${NAME}

cp -r ${BUILD_DIR}/simulator/${NAME}.framework/Modules/${NAME}.swiftmodule/* ${BUILD_DIR}/universal/${NAME}.framework/Modules/${NAME}.swiftmodule
