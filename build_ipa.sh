PROVISIONING_FILE_NAME= ios profiles:download --team "${IOS_DEV_TEAM}" -u "${IOS_DEV_EMAIL}" -p "${IOS_DEV_PASSWORD}" "${IOS_DEV_PROVISIONING_NAME}" | sed -e "s/Successfully downloaded: '\(.*\)'/\1/g"
chown :wheel /Library/Developer/CoreSimulator/Profiles/Runtimes/iOS\ *.simruntime/Contents/Resources/RuntimeRoot/usr/lib/dyld_sim
xcode-select --print-path
xcode-select --switch /Applications/XCode.app/Contents/Developer
ipa build --configuration ${BUILD_CONFIG} --scheme ${SCHEME} CODE_SIGN_IDENTITY='iPhoneDevelper'
ipa distribute:crashlytics -c ./Pods/Crashlytics/Crashlytics.framework -a "${FABRIC_API_TOKEN}" -s "${FABRIC_BUILD_SECRET}"
