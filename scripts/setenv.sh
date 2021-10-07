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

## Below has been commented out by eldersnake@yarn.andrewjvpowell.com
## as we're generating the keystore in the android-build-wrapper.sh script
## Uncomment out the below if running this script on its own (and if you know how to set the below variables!)

#echo "${RELEASE_KEYSTORE}" > release.keystore.asc
#gpg -d --passphrase "${RELEASE_KEYSTORE_PASSPHRASE}" --batch release.keystore.asc > android/app/key.jks

#mkdir -p keys/android
#echo "${RELEASE_SERVICE_ACCOUNT_KEYSTORE}" > service_account.keystore.asc
#gpg -d --passphrase "${RELEASE_KEYSTORE_PASSPHRASE}" --batch service_account.keystore.asc > keys/android/service_account.json