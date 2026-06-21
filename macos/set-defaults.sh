#!/usr/bin/env bash
#
# set-defaults.sh — reasonable macOS system preferences.
#
# Run on its own (not from ./install, since it restarts apps):
#   ./macos/set-defaults.sh

if [ "$(uname -s)" != "Darwin" ]; then
  exit 0
fi

set +e

sudo -v

echo ""
echo "› System:"
echo "  › Holding a key should repeat it (for vim-style nav), not show the accent popup"
defaults write -g ApplePressAndHoldEnabled -bool false

echo "  › Let AirDrop work over Ethernet/USB, not just Wi-Fi and Bluetooth"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

echo "  › Fastest key repeat rate so held keys move/delete quickly"
defaults write NSGlobalDomain KeyRepeat -int 1
echo "  › Short delay before key repeat kicks in"
defaults write NSGlobalDomain InitialKeyRepeat -int 10

echo "  › Always show scrollbars so the scroll position is always visible"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

echo "  › Let window backgrounds pick up the wallpaper color for a cohesive look"
defaults write NSGlobalDomain AppleReduceDesktopTinting -bool false

echo "  › Make Cocoa window resize animations snappy instead of sluggish"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.1

echo "  › Keep straight quotes so code and Markdown aren't broken by curly quotes"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
echo "  › Keep -- and --- literal instead of turning them into en/em dashes"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
echo "  › Don't auto-capitalize, which mangles commands and identifiers"
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
echo "  › Don't insert a period when you double-space"
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
echo "  › Disable autocorrect that rewrites technical terms"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
echo "  › If any app still substitutes quotes, force straight ones (not curly)"
defaults write NSGlobalDomain NSUserQuotesArray -array '"' '"' "'" "'"

echo "  › Disable autocorrect inside web text fields too"
defaults write -g WebAutomaticSpellingCorrectionEnabled -bool false

echo "  › Use the Dark appearance system-wide"
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

echo "  › Use a blue accent (theme) color"
defaults write -g AppleAccentColor -int 4

echo "  › Default new-document saves to local disk instead of "
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo "  › Keep the menu bar always visible (don't auto-hide it)"
defaults write NSGlobalDomain _HIHideMenuBar -bool false

echo "  › Always show the Bluetooth icon in the menu bar (via Control Center)"
defaults -currentHost write com.apple.controlcenter Bluetooth -int 18

echo "  › Hide the Spotlight icon from the menu bar (Cmd+Space still works)"
defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1
defaults -currentHost write com.apple.controlcenter Spotlight -int 8

echo "  › Remove the delay before spring-loaded folders open while dragging"
defaults write -g "com.apple.springing.delay" -float 0.0

echo "  › Speed up trackpad tracking (Fast)"
defaults write -g com.apple.trackpad.scaling -int 2
echo "  › Speed up mouse tracking"
defaults write -g com.apple.mouse.scaling -float 2.5
echo "  › Enable tap-to-click (built-in + Bluetooth trackpad)"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
echo "  › Use a medium click pressure (light/medium/firm = 0/1/2)"
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 1
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad FirstClickThreshold -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad SecondClickThreshold -int 1
echo "  › Enable Force Click and haptic feedback"
defaults write com.apple.AppleMultitouchTrackpad ForceSuppressed -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad ForceSuppressed -bool false
echo "  › Look up & data detectors via Force Click with one finger"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerTapGesture -int 0
echo "  › Secondary click by clicking or tapping with two fingers"
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
echo "  › Disable natural scrolling (content moves opposite to fingers)"
defaults write -g com.apple.swipescrolldirection -bool false
echo "  › Enable pinch to zoom in/out"
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadPinch -bool true
echo "  › Enable smart zoom (two-finger double tap)"
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerDoubleTapGesture -bool true
echo "  › Enable two-finger rotate"
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRotate -bool true

echo "  › Lock the screen and require a password after sleep/screen saver"
defaults write com.apple.screensaver askForPassword -bool true
echo "  › Require that password immediately, with no grace period"
defaults write com.apple.screensaver askForPasswordDelay -int 0
echo "  › Turn the display off after 2 min on battery"
sudo pmset -b displaysleep 2
echo "  › Turn the display off after 5 min on power adapter"
sudo pmset -c displaysleep 5
echo "  › Login window shows name & password fields (not a user list)"
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true
echo "  › Never show password hints at the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0
echo "  › Show Sleep, Restart, and Shut Down buttons at the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow SleepDisabled -bool false
sudo defaults write /Library/Preferences/com.apple.loginwindow RestartDisabled -bool false
sudo defaults write /Library/Preferences/com.apple.loginwindow ShutDownDisabled -bool false

echo "  › Allow .DS_Store on network volumes so Finder view settings persist there"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool false

echo "  › Keep the 'are you sure you want to open this app?' prompt for downloads"
defaults write com.apple.LaunchServices LSQuarantine -bool true

echo "  › Always show the expanded Save panel so any folder is reachable"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

echo "  › Use medium sidebar icons"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

echo "  › Enable right-click Inspect Element in WebKit views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo "  › Reduce animations to feel faster and ease motion sensitivity"
defaults write com.apple.universalaccess reduceMotion -bool true

echo "  › Disable transparency for better contrast and performance"
defaults write com.apple.universalaccess reduceTransparency -bool true

#############################

echo ""
echo "› Finder:"
echo "  › Default Finder windows to list view"
defaults write com.apple.Finder FXPreferredViewStyle -string "Nlsv"

echo "  › Show all filename extensions to avoid opening disguised malicious files"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "  › Show the full POSIX path in the title so you always know where you are"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "  › Don't warn every time you change a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "  › Show hidden (dot)files in Finder"
defaults write com.apple.finder AppleShowAllFiles -bool true

echo "  › Show the status bar (item count and free space)"
defaults write com.apple.finder ShowStatusBar -bool true

echo "  › Show the path bar at the bottom for quick navigation"
defaults write com.apple.finder ShowPathbar -bool true

echo "  › Skip the confirmation prompt when emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false

#############################

echo ""
echo "› Photos:"
echo "  › Stop Photos from launching every time a device/camera is plugged in"
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

#############################

echo ""
echo "› Dock:"
echo "  › Auto-hide the Dock to maximize screen space"
defaults write com.apple.dock autohide -bool true

echo "  › Show the Dock instantly on hover (no reveal delay)"
defaults write com.apple.dock autohide-delay -float 0

echo "  › Keep the Dock anchored to the bottom of the screen"
defaults write com.apple.dock orientation -string "bottom"

echo "  › Use a moderate 42px Dock icon size"
defaults write com.apple.dock tilesize -int 42

echo "  › Dim hidden apps' icons so you can tell them apart"
defaults write com.apple.dock showhidden -bool true

echo "  › Show recently used apps in the Dock"
defaults write com.apple.dock show-recents -bool true

echo "  › Show the running-app indicator dot under Dock icons"
defaults write com.apple.dock show-process-indicators -bool true

echo "  › Speed up Mission Control animations"
defaults write com.apple.dock expose-animation-duration -float 0.1
echo "  › Group Mission Control windows by application"
defaults write com.apple.dock expose-group-apps -bool true

echo "  › Don't bounce/animate apps launching from the Dock"
defaults write com.apple.dock launchanim -bool false

echo "  › Use the faster scale effect when minimizing windows"
defaults write com.apple.dock mineffect -string "scale"

echo "  › Keep Spaces in a fixed order instead of reordering by recent use"
defaults write com.apple.dock mru-spaces -bool false

echo "  › Lock the Dock size so it can't be resized by accident"
defaults write com.apple.dock size-immutable -bool true

#############################

echo ""
echo "› Screenshots:"
echo "  › Save screenshots into ~/Screenshots to keep the desktop tidy"
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
echo "  › Use PNG (lossless) for screenshots"
defaults write com.apple.screencapture type -string "png"
echo "  › Drop the window drop-shadow so screenshots crop tightly"
defaults write com.apple.screencapture disable-shadow -bool true

#############################

echo ""
echo "› Terminal:"
echo "  › Remap 'Hide Ghostty' to F11 (so Super+H can be used for split navigation)"
defaults write com.mitchellh.ghostty NSUserKeyEquivalents -dict-add "Hide Ghostty" "\\UF70E"

#############################

echo ""
echo "› Safari:"
echo "  › Expose Safari's internal debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
echo "  › Show the Develop menu"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
echo "  › Enable the Web Inspector developer extras"
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
echo "  › Enable developer extras for WebKit2 pages too"
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

echo "  › Show the full URL instead of just the domain in the address bar"
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

echo "  › Don't auto-open 'safe' downloads (safer against drive-by files)"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

echo "  › Open a blank page at launch instead of a homepage"
defaults write com.apple.Safari HomePage -string ""

echo "  › Don't autofill credit card data"
defaults write com.apple.Safari AutoFillCreditCardData -bool false
echo "  › Don't autofill contact info from Address Book"
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
echo "  › Don't autofill miscellaneous forms"
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false
echo "  › Don't let Safari autofill passwords (use a dedicated password manager)"
defaults write com.apple.Safari AutoFillPasswords -bool false

echo "  › Reopen your previous tabs/session at launch"
defaults write com.apple.Safari AlwaysRestoreSessionAtLaunch -int 1
echo "  › But don't restore private windows when restoring the session"
defaults write com.apple.Safari ExcludePrivateWindowWhenRestoringSessionAtLaunch -int 1

echo "  › No background image on the Favorites page"
defaults write com.apple.Safari ShowBackgroundImageInFavorites -int 0
echo "  › Show frequently visited sites on the Favorites page"
defaults write com.apple.Safari ShowFrequentlyVisitedSites -int 1
echo "  › Show highlights on the Favorites page"
defaults write com.apple.Safari ShowHighlightsInFavorites -int 1
echo "  › Show the privacy report on the Favorites page"
defaults write com.apple.Safari ShowPrivacyReportInFavorites -int 1
echo "  › Show recently closed tabs on the Favorites page"
defaults write com.apple.Safari ShowRecentlyClosedTabsPreferenceKey -int 1

#############################

echo ""
echo "› Security:"
echo "  › Keep FileVault on (full-disk encryption); enable it if it's off"
if fdesetup status 2>/dev/null | grep -q "FileVault is On"; then
  echo "    · FileVault is already on."
else
  echo "    · FileVault is OFF — enabling now (you'll get a recovery key, keep it safe)…"
  sudo fdesetup enable
fi

echo "  › Disable Siri and hide it from the menu bar"
defaults write com.apple.assistant.support "Assistant Enabled" -bool false
defaults write com.apple.Siri StatusMenuVisible -bool false
defaults write com.apple.Siri UserHasDeclinedEnable -bool true
defaults write com.apple.assistant.support "Siri Data Sharing Opt-In Status" -int 2

echo "  › Turn the application firewall on"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on >/dev/null
echo "  › Enable stealth mode (don't answer pings or port scans)"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on >/dev/null
echo "  › Block all incoming connections"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on >/dev/null

echo "  › Disable the Guest user"
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false
sudo sysadminctl -guestAccount off 2>/dev/null

#############################

echo ""
echo "› Sharing (disable every service):"
echo "  › File Sharing (SMB) off"
sudo launchctl disable system/com.apple.smbd 2>/dev/null
echo "  › Screen Sharing off"
sudo launchctl disable system/com.apple.screensharing 2>/dev/null
echo "  › Remote Login (SSH) off"
sudo systemsetup -f -setremotelogin off 2>/dev/null
echo "  › Remote Management (ARD) off"
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop 2>/dev/null
echo "  › Remote Apple Events off"
sudo systemsetup -setremoteappleevents off 2>/dev/null
echo "  › Printer Sharing off"
sudo cupsctl --no-share-printers 2>/dev/null
echo "  › Internet Sharing off"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.nat NAT -dict Enabled -int 0
echo "  › Content Caching off"
sudo AssetCacheManagerUtil deactivate 2>/dev/null
echo "  › Media / Home Sharing off"
defaults write com.apple.amp.mediasharingd home-sharing-enabled -int 0
echo "  › Bluetooth Sharing off"
defaults -currentHost write com.apple.Bluetooth PrefKeyServicesEnabled -int 0

#############################

echo ""
echo "› Restart related apps"
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "ControlCenter" "Dock" "Finder" "Ghostty" "Mail" "Messages" "Safari" \
  "SystemUIServer" "Terminal" "Photos" "Image Capture"; do
  killall "$app" >/dev/null 2>&1
done
set -e

echo "Done. Some changes need a restart to take effect."
