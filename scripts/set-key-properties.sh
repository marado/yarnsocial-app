#!/bin/sh

if [ -z "${ANDROID_KEY_STORE_PWD}" ]; then
  echo "ANDROID_KEY_STORE_PWD not found, abort"
  exit 1
else
  echo "ANDROID_KEY_STORE_PWD detected, proceeding..."
fi

if [ -z "${ANDROID_KEY_PWD}" ]; then
  echo "ANDROID_KEY_PWD not found, abort"
  exit 1
else
  echo "ANDROID_KEY_PWD detected, proceeding..."
fi

{
  echo "storePassword=${ANDROID_KEY_STORE_PWD}"
  echo "keyPassword=${ANDROID_KEY_PWD}"
  echo "keyAlias=upload"
  echo "storeFile=upload-keystore.jks"
} >> android/key.properties
