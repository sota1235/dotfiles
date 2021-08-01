#!/bin/sh

##
# Trackpad
##

## ポイントとクリック

# 副ボタンのクリックを2本指でクリック、またはタップ
defaults write -globalDomain ContextMenuGesture -integer 1
defaults write -globalDomain TrackpadRightClick -integer 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -integer 1

# タップでクリック
defaults write com.apple.AppleMultitouchTrackpad Clicking -integer 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -integer 1

# 軌跡の速さ
defaults write -globalDomain com.apple.trackpad.scaling -integer 3

## スクロールとズーム

# スクロールの方向をナチュラルに
defaults delete -globalDomain com.apple.swipescrolldirection

# 2本指で拡大・縮小
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -integer 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -integer 1

# スマートズーム
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -integer 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -integer 1

# 2本指で回転
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -integer 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -integer 1

##
# Keyboard
##
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# Done
echo "Done. Note that some of these changes require a logout/restart to take effect."
