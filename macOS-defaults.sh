#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `$0` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# System Settings                                                             #
###############################################################################

# Set standby delay to 24 hours (default is 1 hour)
sudo pmset -a standbydelay 86400

# Disable hibernation (speeds up entering sleep mode)
sudo pmset -a hibernatemode 0

# Change Login Screen Background
sudo defaults write /Library/Preferences/com.apple.loginwindow DesktopPicture "/Library/Desktop\ Pictures/Underwater.jpg"

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Menu bar: disable transparency
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

# Menu bar: show remaining battery time; hide percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
#defaults write com.apple.menuextra.battery ShowTime -string "YES"

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Disable opening and closing window animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Disable Resume system-wide
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Fix for the ancient UTF-8 bug in QuickLook (http://mths.be/bbo)
# Commented out, as this is known to cause problems when saving files in Adobe Illustrator CS5 :(
#echo "0x08000100:0" > ~/.CFUserTextEncoding

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

###############################################################################
# Trackpad, mouse, keyboard, input, and bluetooth                             #
###############################################################################

# Trackpad: swipe between pages with three fingers
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerHorizSwipeGesture -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 1

# Disable page swipe within apps
defaults write AppleEnableSwipeNavigateWithScrolls -bool FALSE

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
# Note:  MacOS Sierra seems to require setting InitialKeyRepeat now as well
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10


# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en" "nl"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
defaults write NSGlobalDomain AppleMetricUnits -bool false

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Disable auto-correct
#defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
if [ ! -f "$HOME/Desktop/screencaps" ]; then 
    mkdir -p "$HOME/Desktop/screencaps" 
fi
defaults write com.apple.screencapture location -string "$HOME/Desktop/screencaps"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "jpg"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2

###############################################################################
# Finder                                                                      #
###############################################################################

# Finder: new window location set to $HOME. Same as Finder > Preferences > New Finder Windows show
# For other path use "PfLo" and "file:///foo/bar/"
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show hidden files
defaults write com.apple.finder AppleShowAllFiles TRUE;killall Finder

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Enable text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool TRUE

# Show item info below desktop icons
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for desktop icons
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# disable automatic sorting desktops by recent use, set to true to enable
defaults write com.apple.dock mru-spaces -bool false

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Remove Dropbox’s green checkmark icons in Finder
#file=/Applications/Dropbox.app/Contents/Resources/check.icns
#[ -e "$file" ] && mv -f "$file" "$file.bak"
#unset file

###############################################################################
# Dock & hot corners                                                          #
###############################################################################

# Enable highlight hover effect for the grid view of a stack (Dock)
defaults write com.apple.dock mouse-over-hilte-stack -bool true

# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 76

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don’t animate opening applications from the Dock
#defaults write com.apple.dock launchanim -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Remove the auto-hiding Dock delay
defaults write com.apple.Dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
#defaults write com.apple.dock autohide-time-modifier -float 0

# Enable the 2D Dock
#defaults write com.apple.dock no-glass -bool true

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Enable iTunes track notifications in the Dock
defaults write com.apple.dock itunes-notifications -bool true

# turn off notif center
sudo defaults write /System/Library/LaunchAgents/com.apple.notificationcenterui KeepAlive -bool False

# Reset Launchpad
find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete

# Add a spacer to the left side of the Dock (where the applications are)
#defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
# Add a spacer to the right side of the Dock (where the Trash is)
#defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

# Hot corners
# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Mission Control
# Top left screen corner → Mission Control
#defaults write com.apple.dock wvous-tl-corner -int 2
#defaults write com.apple.dock wvous-tl-modifier -int 0
# Bottom right screen corner → Desktop
#defaults write com.apple.dock wvous-br-corner -int 4
#defaults write com.apple.dock wvous-br-modifier -int 0
# Top right screen corner → put display to sleep
defaults write com.apple.dock wvous-tr-corner -int 10
defaults write com.apple.dock wvous-tr-modifier -int 0

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Privacy: don't send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Press Tab to highlight each item on a web page
#defaults write com.apple.Safari WebKitTabToLinksPreferenceKey -bool true
#defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari's debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Hide Safari sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false

# Remove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true
# Don't allow websites to ask to not use autocompletion
defaults write com.apple.Safari AllowBypassOfAutocompleteOff -bool true

# Enable autofilling of passwords
defaults write com.apple.Safari AutoFillPasswords -bool true

###############################################################################
# Address Book, Dashboard, iCal, iTunes, Mail, and Disk Utility               #
###############################################################################

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable the debug menu in Address Book
defaults write com.apple.addressbook ABShowDebugMenu -bool true

# Enable Dashboard dev mode (allows keeping widgets on the desktop)
defaults write com.apple.dashboard devmode -bool true

# Enable the debug menu in iCal
defaults write com.apple.iCal IncludeDebugMenu -bool true

# Make the iTunes arrow links go to your library instead of the iTunes Store
defaults write com.apple.iTunes invertStoreLinks -bool true

# Disable the iTunes arrow links completely
defaults write com.apple.iTunes show-store-arrow-links -bool false

# Disable the Ping sidebar in iTunes
defaults write com.apple.iTunes disablePingSidebar -bool true

# Disable all the other Ping stuff in iTunes
defaults write com.apple.iTunes disablePing -bool true

# Make ⌘ + F focus the search input in iTunes
defaults write com.apple.iTunes NSUserKeyEquivalents -dict-add "Target Search Field" "@F"

# Disable send and reply animations in Mail.app
defaults write com.apple.Mail DisableReplyAnimations -bool true
defaults write com.apple.Mail DisableSendAnimations -bool true

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true

###############################################################################
# Address Book, Dashboard, iCal, iTunes, Mail, and Disk Utility               #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Terminal                                                                    #
###############################################################################

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Enable “focus follows mouse” for Terminal.app and all X11 apps
# This means you can hover over a window and start typing in it without clicking first
#defaults write com.apple.terminal FocusFollowsMouse -bool true
#defaults write org.x.X11 wm_ffm -bool true
# Use a modified version of the Solarized Dark theme by default in Terminal.app
#osascript <<EOD
#tell application "Terminal"
#    local allOpenedWindows
#    local initialOpenedWindows
#    local windowID
#    set themeName to "Solarized Dark xterm-256color"
#
#    (* Store the IDs of all the open terminal windows. *)
#    set initialOpenedWindows to id of every window
#
#    (* Open the custom theme so that it gets added to the list
#       of available terminal themes (note: this will open two
#       additional terminal windows). *)
#
#    do shell script "open '$HOME/init/" & themeName & ".terminal'"
#
#    (* Wait a little bit to ensure that the custom theme is added. *)
#    delay 1
#
#    (* Set the custom theme as the default terminal theme. *)
#    set default settings to settings set themeName
#
#    (* Get the IDs of all the currently opened terminal windows. *)
#    set allOpenedWindows to id of every window
#
#    repeat with windowID in allOpenedWindows
#
#        (* Close the additional windows that were opened in order
#        to add the custom theme to the list of terminal themes. *)
#        if initialOpenedWindows does not contain windowID then
#            close (every window whose id is windowID)
#        
#            (* Change the theme for the initial opened terminal windows
#               to remove the need to close them in order for the custom
#               theme to be applied. *)
#        else
#            set current settings of tabs of (every window whose id is windowID) to settings set themeName
#        end if
#    
#    end repeat
#    end tell
#EOD

###############################################################################
# Xcode & Local Development
###############################################################################
# Always use spaces for indenting
defaults write com.apple.dt.Xcode DVTTextIndentUsingTabs -bool false

# Show tab bar
defaults write com.apple.dt.Xcode AlwaysShowTabBar -bool true

# Add iOS & Watch Simulator to Launchpad
sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
#sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"

# Enable Dev Tools in WebKit-based apps
defaults write com.bundle.identifier WebKitDeveloperExtras -bool true

###############################################################################
# Time Machine                                                                #
###############################################################################

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Disable local Time Machine backups
# hash tmutil &> /dev/null && sudo tmutil disable # disablelocal

###############################################################################
# Sysadmin options (requires sudo) - show system info on login
###############################################################################
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in Finder Dock Mail Safari iTunes iCal Address\ Book SystemUIServer; do
	killall "$app" > /dev/null 2>&1
done
echo "Done. Note that some of these changes require a logout/restart to take effect."
