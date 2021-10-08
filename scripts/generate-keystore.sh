#!/bin/sh

random_string() {
  n="${1:-32}"
  tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w "$n" | head -n 1
}

if ! [ -f ./android/app/upload-keystore.jks ]; then
  [ -f ./android/key.properties ] && rm ./android/key.properties

  echo "No keystore found, generating a new one..."
  echo

  ANDROID_KEY_STORE_PWD="$(random_string 12)"
  ANDROID_KEY_PWD="$(random_string 12)"

  echo "Generating keystore... "
  echo

  keytool -v -alias upload -genkey -keyalg RSA -keysize 2048 -validity 10000 \
    -keypass "$ANDROID_KEY_PWD" -storepass "$ANDROID_KEY_STORE_PWD" \
    -keystore ./android/app/upload-keystore.jks

  echo "Generating .envrc ..."
  echo

  {
    printf "export ANDROID_KEY_STORE_PWD=%s\n" "$ANDROID_KEY_STORE_PWD"
    printf "export ANDROID_KEY_PWD=%s\n" "$ANDROID_KEY_PWD"
  } > .envrc

  echo "Settings up key.properties ..."
  echo
  (
    export ANDROID_KEY_STORE_PWD ANDROID_KEY_PWD
    ./scripts/set-key-properties.sh
  ) || exit 1
fi
