#!/bin/sh

# 証明書・Provisioning Profileを復号
openssl aes-256-cbc -k $DECORD_CERTS -in scripts/certs/cert.cer.enc -d -a -out scripts/certs/cert.cer
openssl aes-256-cbc -k $DECORD_CERTS -in scripts/certs/cert.p12.enc -d -a -out scripts/certs/cert.p12

# VM上にキーチェーンを作成
# なぜこんな手順を踏むかは↓を参照
# http://docs.travis-ci.com/user/common-build-problems/#Mac%3A-Code-Signing-Errors
security create-keychain -p travis ios-build.keychain
security default-keychain -s ios-build.keychain
security unlock-keychain -p travis ios-build.keychain
security set-keychain-settings -t 3600 -l ~/Library/Keychains/ios-build.keychain

# キーチェーンに証明書を追加する
security import ./scripts/certs/cert.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
security import ./scripts/certs/cert.p12 -k ~/Library/Keychains/ios-build.keychain -P $CERTS_PASS -T /usr/bin/codesign

# Provisioning Profileを保存する
#mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
#cp "./scripts/profile/Sample.mobileprovision" ~/Library/MobileDevice/Provisioning\ Profiles/
