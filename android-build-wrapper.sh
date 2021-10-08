#!/bin/sh

if ! test -f ./android/app/upload-keystore.jks
then
	if test -f ./android/key.properties; then rm ./android/key.properties; fi

	echo "**No keystore found, so we'll need to generate one.**"
	echo ""

	echo "Please enter a password for the keystore (a least 6 characters):"

	stty_orig=$(stty -g)
	stty -echo
	read ANDROID_KEY_STORE_PWD
	stty $stty_orig
	
	echo "Now please enter a password for the certificate key (at least 6 characters):"
	
	stty_orig=$(stty -g)
	stty -echo
	read ANDROID_KEY_PWD
	stty $stty_orig

	echo "Generating keystore... please follow the prompts"
	echo ""
	keytool -genkey -v -keystore ./android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload -storepass $ANDROID_KEY_STORE_PWD -keypass $ANDROID_KEY_PWD
fi


if ! test -f ./android/key.properties 
then 
	if test -z "${ANDROID_KEY_STORE_PWD}"
	then
		echo "Please enter keystore password:"
		
		stty_orig=$(stty -g)
		stty -echo
		read ANDROID_KEY_STORE_PWD
		stty $stty_orig
	fi

	if  test -z "${ANDROID_KEY_PWD}"
	then
		echo "Please enter certificate key password:"
		
		stty_orig=$(stty -g)
		stty -echo
		read ANDROID_KEY_PWD
		stty $stty_orig
	fi

	ANDROID_KEY_STORE_PWD=$ANDROID_KEY_STORE_PWD  ANDROID_KEY_PWD=$ANDROID_KEY_PWD ./scripts/setenv.sh || exit 1
fi

echo ""
echo "Now executing [flutter build apk]..."

flutter build apk

## Uncomment the below command if you wish for the file containing the passwords to be deleted post-build
## (requires re-entering keystore passwords when this script is run again)
#rm ./android/key.properties

exit 0
