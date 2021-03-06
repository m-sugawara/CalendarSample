# deployment/testブランチにコミットした時だけIPAを作成します。
#!/bin/sh
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
	exit 0
fi
if [[ "$TRAVIS_BRANCH" != "deployment/test" ]]; then
	exit 0
fi

# Provisioning ProfileをDLして保存する
PROVISIONING_FILE_NAME= ios profiles:download -u "${IOS_DEV_EMAIL}" -p "${IOS_DEV_PASSWORD}" --team "ZAPPALLAS, INC." "${IOS_DEV_PROVISIONING_NAME}" | sed -e "s/Successfully downloaded: '\(.*\)'/\1/g"
PROVISIONING_FILE_NAME=${IOS_DEV_PROVISIONING_NAME}".mobileprovision"
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp "./"${PROVISIONING_FILE_NAME} ~/Library/MobileDevice/Provisioning\ Profiles/

# 前のビルド結果を消去
rm -rf ./build/*
# ipaファイルを作成
ipa build --embed ${PROVISIONING_FILE_NAME} --configuration ${BUILD_CONFIG} --scheme ${SCHEME} CODE_SIGN_IDENTITY='iPhoneDevelper'
# Crashlyticsにて配布
ipa distribute:crashlytics -c ./Pods/Crashlytics/Crashlytics.framework -a "${FABRIC_API_TOKEN}" -s "${FABRIC_BUILD_SECRET}"
