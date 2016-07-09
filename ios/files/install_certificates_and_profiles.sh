#!/usr/bin/env bash

#==========================================================================================
# Originate iOS CircleCI Deployment
# install_certificates_and_profiles.sh
# (based on: https://github.com/thorikawa/CircleCI-iOS-TestFlight-Sample/tree/master/scripts)
#
# This is a script to import certs and install provisioning profiles into a
#    temporary keychain for Continuous Deployment on CircleCI.
#
# Relevant items :
#    Certificates :
#        apple.cer : Apple Worldwide Developer Relations Certification Authority
#        dist.cer  : iOS distribution certificate
#        dist.p12  : iOS distribution private key (locked with $KEY_PASSWORD on export)
#
#    Provisioning Profiles :
#        Mobile Provisioning Profiles for the project being deployed are installed from
#            ./scripts/CircleCI/profile/
#
# Certificates are imported into a temporary keychain, ios-build.keychain, locked with
#     the password $KEYCHAIN_PASSWORD
#
#==========================================================================================

# set password for ios-build.keychain
KEYCHAIN_PASSWORD=circleci

# create ios-build.keychain with $KEYCHAIN_PASSWORD
security create-keychain -p $KEYCHAIN_PASSWORD ios-build.keychain
# import Apple Worldwide Developer Relations Certification Authority to ios-build.keychain
security import ./scripts/CircleCI/apple.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
# import iOS distribution certificate to ios-build.keychain
security import ./scripts/CircleCI/dist.cer -k ~/Library/Keychains/ios-build.keychain -T /usr/bin/codesign
# import iOS distribution private key to ios-build.keychain
security import ./scripts/CircleCI/dist.p12 -k ~/Library/Keychains/ios-build.keychain -P $KEY_PASSWORD -T /usr/bin/codesign
# load the keychain
security list-keychain -s ~/Library/Keychains/ios-build.keychain
# unlock keychain with $KEYCHAIN_PASSWORD
security unlock-keychain -p $KEYCHAIN_PASSWORD ~/Library/Keychains/ios-build.keychain

# install provisioning profiles to system
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp ./scripts/CircleCI/profile/* ~/Library/MobileDevice/Provisioning\ Profiles/
