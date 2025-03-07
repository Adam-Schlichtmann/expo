#!/usr/bin/env bash

set -xeuo pipefail

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../../.. && pwd )"
export PATH="$ROOT_DIR/bin:$PATH"

notify_slack() {
  if [[ ! -z "$SLACK_HOOK" ]]; then
    curl \
      -X POST \
      -H 'Content-type: application/json' \
      --data "{ \"text\": \"$1\", \"attachments\": [ { \"text\": \"$2\", \"color\": \"good\" } ] }" \
      $SLACK_HOOK
  else
    echo "SLACK_HOOK is not defined, skip sending slack notification."
    echo "TITLE: $1"
    echo "MESSAGE: $2"
  fi
}

upload_crashlytics_symbols() {
  pushd $ROOT_DIR/apps/eas-expo-go/android
  ./gradlew :app:uploadCrashlyticsSymbolFile$1
  popd
}

if [[ "$EAS_BUILD_PROFILE" == "release-client" ]]; then
  if [[ "$EAS_BUILD_PLATFORM" == "android" ]]; then
    upload_crashlytics_symbols "VersionedRelease"
  fi

  SLUG="release-client"
  COMMIT_HASH="$(git rev-parse HEAD)"
  COMMIT_AUTHOR="$(git log --pretty=format:"%an - %ae" | head -n 1)"

  EAS_BUILD_MESSAGE_PART="EAS Build: <https://expo.dev/accounts/expo-ci/projects/$SLUG/builds/$EAS_BUILD_ID|$EAS_BUILD_ID>"
  GITHUB_MESSAGE_PART="GitHub: <https://github.com/expo/expo/commit/$COMMIT_HASH|$COMMIT_HASH>"

  TITLE=""
  if [[ "$EAS_BUILD_PLATFORM" = "android" ]]; then
    TITLE="Successfull Expo Go release build. Submitting build to the Play Store."
  elif [[ "$EAS_BUILD_PLATFORM" = "ios" ]]; then
    TITLE="Successfull Expo Go release build. Submitting build to the TestFlight."
  fi
  MESSAGE="Release triggered by: $EAS_BUILD_USERNAME\\nCommit author: $COMMIT_AUTHOR\\n$EAS_BUILD_MESSAGE_PART\\n$GITHUB_MESSAGE_PART"

  notify_slack "$TITLE" "$MESSAGE"
fi
