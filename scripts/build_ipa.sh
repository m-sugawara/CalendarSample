PROVISIONING_FILE_NAME= ios profiles:download -u "${IOS_DEV_EMAIL}" -p "${IOS_DEV_PASSWORD}" --team "${IOS_DEV_TEAM}" "${IOS_DEV_PROVISIONING_NAME}" | sed -e "s/Successfully downloaded: '\(.*\)'/\1/g"

ipa build --embed ${PROVISIONING_FILE_NAME} --configuration ${BUILD_CONFIG} --scheme ${SCHEME} CODE_SIGN_IDENTITY='iPhoneDevelper'
ipa distribute:crashlytics -c ./Pods/Crashlytics/Crashlytics.framework -a "${FABRIC_API_TOKEN}" -s "${FABRIC_BUILD_SECRET}"