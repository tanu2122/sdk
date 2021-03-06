#!/usr/bin/env bash
# Uploads a new version of the checked in SDK CIPD packages
set -e
set -x

if [ -z "$1" ]; then
  echo "Usage: update.sh version"
  exit 1
fi

channel="stable"
case "$1" in
*-dev.*) channel="dev";;
esac

tmpdir=$(mktemp -d)
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT HUP INT QUIT TERM PIPE
pushd "$tmpdir"

gsutil cp "gs://dart-archive/channels/$channel/release/$1/sdk/dartsdk-linux-x64-release.zip" .
unzip -q dartsdk-linux-x64-release.zip -d sdk
cipd create \
  -name dart/dart-sdk/linux-amd64 \
  -in sdk \
  -install-mode copy \
  -tag version:$1 \
  -ref $channel
rm -rf sdk

gsutil cp "gs://dart-archive/channels/$channel/release/$1/sdk/dartsdk-linux-arm-release.zip" .
unzip -q dartsdk-linux-arm-release.zip -d sdk
cipd create \
  -name dart/dart-sdk/linux-armv6l \
  -in sdk \
  -install-mode copy \
  -tag version:$1 \
  -ref $channel
rm -rf sdk

gsutil cp "gs://dart-archive/channels/$channel/release/$1/sdk/dartsdk-linux-arm64-release.zip" .
unzip -q dartsdk-linux-arm64-release.zip -d sdk
cipd create \
  -name dart/dart-sdk/linux-arm64 \
  -in sdk \
  -install-mode copy \
  -tag version:$1 \
  -ref $channel
rm -rf sdk

gsutil cp "gs://dart-archive/channels/$channel/release/$1/sdk/dartsdk-macos-x64-release.zip" .
unzip -q dartsdk-macos-x64-release.zip -d sdk
cipd create \
  -name dart/dart-sdk/mac-amd64 \
  -in sdk \
  -install-mode copy \
  -tag version:$1 \
  -ref $channel
rm -rf sdk

# We currently use the ia32 SDK on x64 Windows as well, see also README.
gsutil cp "gs://dart-archive/channels/$channel/release/$1/sdk/dartsdk-windows-ia32-release.zip" .
unzip -q dartsdk-windows-ia32-release.zip -d sdk
cipd create \
  -name dart/dart-sdk/windows-amd64 \
  -in sdk \
  -install-mode copy \
  -tag version:$1 \
  -ref $channel
rm -rf sdk

gsutil cp "gs://dart-archive/channels/$channel/release/$1/sdk/dartsdk-windows-ia32-release.zip" .
unzip -q dartsdk-windows-ia32-release.zip -d sdk
cipd create \
  -name dart/dart-sdk/windows-386 \
  -in sdk \
  -install-mode copy \
  -tag version:$1 \
  -ref $channel
rm -rf sdk

popd
