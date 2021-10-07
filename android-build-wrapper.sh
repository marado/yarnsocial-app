#!/bin/sh

if ! test -f ./android/app/upload-keystore.jks
then
	if test -f ./android/key.properties; then rm ./android/key.properties; fi

	echo "**No keystore found, so we'll need to generate one.**"
	echo ""

	echo "Please enter a password for the keystore (a least 6 characters):"

	stty_orig=$(stty -g)
	stty -echo
	read STORE_KEY_STORE_PASS
	stty $stty_orig
	
	echo "Now please enter a password for the certificate key (at least 6 characters):"
	
	stty_orig=$(stty -g)
	stty -echo
	read STORE_KEY_PASS
	stty $stty_orig

	echo "Generating keystore... please follow the prompts"
	echo ""
	keytool -genkey -v -keystore ./android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload -storepass $STORE_KEY_STORE_PASS -keypass $STORE_KEY_PASS
fi


if ! test -f ./android/key.properties 
then 
	ANDROID_KEY_STORE_PWD=$STORE_KEY_STORE_PASS ANDROID_KEY_PWD=$STORE_KEY_PASS ./scripts/setenv.sh
fi

echo ""
echo "Now executing [flutter build apk]..."

flutter build apk

exit 0
