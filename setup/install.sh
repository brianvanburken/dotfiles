#!/usr/bin/env bash

set -e
set -o pipefail

# Set XDG config
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# Set Homebrew prefix
export HOMEBREW_PREFIX="/opt/homebrew";

# Force specific PATH
export PATH=$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH

# Location where to store code
export DEV_DIR=${DEV_DIR:=$HOME/Developer}

# Location where to store configrations
export DOT_DIR=${DOT_DIR:=$DEV_DIR/personal/dotfiles}

# Name of dotfiles repo
readonly DOT_REPO=brianvanburken/dotfiles

# Set the download URL
readonly SOURCE_URL=${SOURCE_URL:=https://raw.githubusercontent.com/$DOT_REPO/master/}

# Determine macOS version
readonly OS_VERSION="$(sw_vers -productVersion)"

# Supported macOS versions
readonly SUPPORTED_MACOS_VERSIONS=("11", "12")

# Determine Mac model
readonly APPLE_COMPUTER_TYPE="$(sysctl hw.model | awk '{print $2}')"

# ANSI color codes
readonly LIGHT_GREEN='\033[1;32m'
readonly WHITE='\033[1;37m'
readonly LIGHT_CYAN='\033[1;36m'
readonly YELLOW='\033[1;33m'
readonly LIGHT_RED='\033[1;31m'
readonly NO_COLOR='\033[0m'

# Initially no manual actions are required
require_manual_actions=0

action() {
    echo "${WHITE}--->${NO_COLOR} $1"
}
ok() {
    echo "${LIGHT_GREEN}[OK]${NO_COLOR} $1"
}
input() {
    echo "${WHITE}[INPUT]${NO_COLOR} $1"
}
notice() {
    echo "${LIGHT_CYAN}[NOTICE]${NO_COLOR} $1"
}
warning() {
    echo "${YELLOW}[WARNING]${NO_COLOR} $1"
}
error() {
    echo "${LIGHT_RED}[ERROR]${NO_COLOR} $1"
}
strip_colors() {
    sed $1 "s,\x1B\[[0-9;]*[a-zA-Z],,g"
}

cached_sudo() {
    if sudo -n true &>/dev/null; then
        sudo -v
    else
        input "We will need admin permissions for the next steps. Please enter your password and press <ENTER>"
        sudo -v
    fi
    if [[ -n $@ ]]; then
        sudo "$@"
    fi
}

cleanup_and_exit() {
    local exitcode=${1:-0}
    # Drop cached sudo credentials
    sudo -K
    exit ${exitcode}
}

# Make sure we always cleanup whenever this script exits, no matter how it exits
trap cleanup_and_exit EXIT

action "Setting up macOS"

if [[ "$(uname)" != "Darwin" ]]; then
    error "No, macOS setup does not work on non macOS machines.."
    cleanup_and_exit 1
fi

readonly OS_MAJOR_VERSION=$(echo ${OS_VERSION} | cut -f 1,1 -d '.')
# Stylewise the value we want to test should be on the left side. But checking
# for a value in an array does not work with the value on the left side. Other
# possibilities (looping over the array) are harder to read. Thus we decided to
# keep the value on the right hand side.
if [[ ! ${SUPPORTED_MACOS_VERSIONS[@]} =~ ${OS_MAJOR_VERSION} ]]; then
    error "You are running an unsupported version of macOS (${OS_MAJOR_VERSION}). Upgrade first and re-run this script."
    cleanup_and_exit 1
fi

readonly ARCHITECTURE=$(uname -m)
if [[ "arm64" =~ ${ARCHITECTURE} ]]; then
    error "You are running an unsupported architecture (${ARCHITECTURE}). Run with supported ARM64."
    cleanup_and_exit 1
fi

if [[ -z ${TERM_PROGRAM} ]]; then
    error "This command should be run from a Terminal whiled logged in to a graphical session on your Mac. Exiting..."
    cleanup_and_exit 1
fi

if [[ ! -d "$(xcode-select -p)" ]]; then
    action "Installing command line tools (without XCode)"
    xcode-select --install
    ok "Installing command line tools done. Rerun this script to install everything else."
    cleanup_and_exit
else
    ok "Command line tools are installed."
fi

# Get sudo credentials
cached_sudo

# Install Homebrew
if [[ ! -r $HOMEBREW_PREFIX/bin/brew ]]; then
    notice " Need to install Homebrew..."
    action "Installing Homebrew and required components. This may take some time... ☕️ "

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew doctor >/dev/null
    ok "Installing Homebrew done"
else
    ok "Homebrew binary found."
    action "Checking if we can brew..."
    brew doctor >/dev/null
    ok "Ready to brew"
fi

# After each install step, let's prolong our sudo credentials since some things may take a while
cached_sudo

# Install Brew Bundle
if ! brew tap | grep bundle >/dev/null; then
    notice " Need to install Homebrew Bundle"
    brew tap Homebrew/bundle >/dev/null
    ok "Installing Homebrew Bundle done"
else
    ok "Homebrew Bundle found. Proceeding..."
fi

# Reload sudo
cached_sudo

action "Installing some very nice apps and tools..."
cached_sudo
brew_file="$DOT_DIR/setup/Brewfile"
if [[ ! -f $brew_file ]]; then
  curl -fsSL "$SOURCE_URL/$brew_file" | brew bundle --file=- | strip_colors
else
  brew bundle --file=$brew_file
fi
ok "Installing software done."

# Reload sudo
cached_sudo

softwareupdates="$(softwareupdate -l 2>/dev/null)"
if [[ ${softwareupdates} =~ "recommended" ]]; then
    warning "There are recommended OS updates, please install them and re-run this script."
    require_manual_actions=1
    echo "${softwareupdates}"
else
    ok "Your system is up to date"
fi

if ! nvram -x -p | grep fmm-mobileme-token-FMM &>/dev/null; then
    warning "Find My Mac is not enabled, please configure with your AppleID account"
    require_manual_actions=1
else
    ok "Find My Mac is enabled"
fi

if sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate | grep disabled &>/dev/null; then
    action "Firewall is disabled, enabling..."
    sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
else
    ok "Firewall is enabled"
fi

# Prolong sudo
cached_sudo

if ! fdesetup isactive &>/dev/null; then
    warning "FileVault is not enabled"
    cached_sudo
    action "Enabling FileVault"
    sudo fdesetup enable -user "$(whoami)"
    require_reboot=1
else
    ok "Filevault is enabled"
fi

# Only set the items below for mobile Macs
if [[ ${APPLE_COMPUTER_TYPE} =~ "MacBook" ]]; then
    powernap_status=$(pmset -g | awk '/powernap/ {print $2}')
    if [[ ${powernap_status} -eq 1 ]]; then
        action "Disabling Power Nap"
        sudo pmset -a powernap 0
    else
        ok "Power Nap is disabled"
    fi

    filevault_destroykeysonstandby=$(pmset -g | awk '/DestroyFVKeyOnStandby/ {print $2}' || echo 1)
    hibernatemode=$(pmset -g | awk '/hibernatemode/ {print $2}' || echo "25")
    standbymode=$(pmset -g | awk '/standby / {print $2}' || echo "1")
    autopoweroff=$(pmset -g | awk '/autopoweroff / {print $2}' || echo "1")
    #standbydelay=$(pmset -g | awk '/standbydelay/ {print $2}' || echo "86400")
    if pmset -g batt | grep Battery &>/dev/null; then
        if [[ ${filevault_destroykeysonstandby} -eq 1 || ${hibernatemode} -eq 25 || ${standbymode} -eq 0 || ${autopoweroff} -eq 1 ]]; then
            action "Reverting to default sleep behavior to address stability issues with Secure Deep Sleep"
            sudo pmset -a destroyfvkeyonstandby 0
            sudo pmset -a standby 1
            sudo pmset -a standbydelay 10800
            sudo pmset -a hibernatemode 3
            sudo pmset -a autopoweroff 0
        else
            ok "Sleep mode correctly configured"
        fi
    else
        warning "No battery was found. Your MacBook battery may be dead"
        require_manual_actions=1
    fi
else
    notice "Skipping MacBook specific settings because detected model is ${APPLE_COMPUTER_TYPE:-empty}"
fi

if [[ ! -d $HOME/.ssh ]]; then
    action "Creating ssh directory and setting permissions"
    mkdir -p $HOME/.ssh
    chmod 700 $HOME/.ssh
elif [[ "$(stat -f "%A" $HOME/.ssh)" != "700" ]]; then
    action "Setting secure permissions for ssh directory"
    chmod 700 $HOME/.ssh
    find $HOME/.ssh -type f -exec chmod 600 {} \;
    find $HOME/.ssh -type d -exec chmod 700 {} \;
else
    ok "Permissions for ssh directory are secure"
fi

screensaver_askforpassworddelay=$(defaults read com.apple.screensaver askForPasswordDelay 2>/dev/null || echo "10")
if [[ ${screensaver_askforpassworddelay} -gt 5 ]]; then
    action "Setting screensaver password delay to 5 seconds"
    defaults write com.apple.screensaver askForPasswordDelay -int 5
else
    ok "Screensaver password delay set to 5 seconds or less"
fi

screensaver_idletime=$(defaults -currentHost read com.apple.screensaver idleTime 2>/dev/null || echo "500")
if [[ ${screensaver_idletime} -gt 300 ]]; then
    action "Setting screensaver to start after 5 minutes of idle time"
    defaults -currentHost write com.apple.screensaver idleTime -int 300
else
    ok "Screensaver set to start after 5 minutes of idle time or less"
fi

action "Creating special directories"
mkdir -p $DEV_DIR/{personal,oss,work}

action "Creating $HOME/.hushlogin"
touch $HOME/.hushlogin

if [ ! -d $DOT_DIR ]; then
    action "Cloning configurations"
    git clone https://github.com/$DOT_REPO.git $DOT_DIR
    cd $DOT_DIR
    git remote remove origin
    git remote add origin git@github.com:$DOT_REPO.git
    git fetch --all
    git branch -u origin/master master
    git config --local user.name "Brian van Burken"
    git config --local user.email "brianvanburken@users.noreply.github.com"
    cd -
    ok "Created configurations directory at $DOT_DIR"
else
    ok "Dotfiles already present"
fi

readonly NVIM_DIR=$XDG_DATA_HOME/nvim
if [ ! -d $NVIM_DIR ]; then
    action "Installing neovim plugins"
    git clone --depth 1 https://github.com/wbthomason/packer.nvim $NVIM_DIR/site/pack/packer/start/packer.nvim && \
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
    ok "Neovim plugins installed"
fi

action "Linking dotfiles in $HOME to $DOT_DIR"
mkdir -p $HOME/.config
files=(
    "config/alacritty"
    "config/asdf"
    "config/editorconfig"
    "config/git"
    "config/hammerspoon"
    "config/npm"
    "config/nvim"
    "config/ripgrep"
    "config/rsync"
    "config/tmux"
    "config/zsh"
)
for x in "${files[@]}"; do
    action "Linking $HOME/.$x"
    rm -rf $HOME/.$x
    ln -s $DOT_DIR/$x $HOME/.$x
done

action "Linking $HOME/.zshenv"
rm -f $HOME/.zshenv
ln -s $DOT_DIR/config/zsh/zshenv $HOME/.zshenv

action "Linking $HOME/.ctags"
rm -f $HOME/.ctags
ln -s $DOT_DIR/config/ctags/.ctags $HOME/.ctags

action "Linking $DEV_DIR/.editorignore"
rm -f $DEV_DIR/.editorconfig
ln -s $DOT_DIR/config/editorconfig/config $DEV_DIR/.editorconfig

action "Linking $DEV_DIR/.ignore"
rm -f $DEV_DIR/.ignore
ln -s $DOT_DIR/config/ripgrep/ignore $DEV_DIR/.ignore

readonly GNUPG_DIR="$XDG_CONFIG_HOME/gnupg"
action "Linking $GNUPG_DIR/gpg-agent.conf"
mkdir -p "$GNUPG_DIR"
chmod 700 "$GNUPG_DIR"
rm -f "$GNUPG_DIR/gpg-agent.conf"
ln -s "$DOT_DIR/config/gnupg/gpg-agent.conf" "$GNUPG_DIR/gpg-agent.conf"

ok "Done linking configurations"

action "Creating local .zshrc"
touch $XDG_CONFIG_HOME/zsh/.zshrc.local

action "Change hammerspoon directory to respect XDG"
defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME/hammerspoon/init.lua"
ok "Done setting up hammerspoon"

if [[ -r $HOMEBREW_PREFIX/bin/asdf ]]; then
    action "Adding asdf plugins"
    asdf plugin-add ruby || true
    asdf plugin-add nodejs || true
    asdf plugin-add elm || true
    asdf plugin-add python || true
    asdf plugin-add haskell || true
    ok "asdf plugins added"

    action "Installing asdf versions"
    asdf install
    ok "Installed asdf versions"
else
    warning "asdf plugin manager not found"
fi

# Prolong sudo
cached_sudo

action "Setting macOS preferences"
# Opening and closing windows and popovers
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

# Smooth scrolling
defaults write -g NSScrollAnimationEnabled -bool false

# Showing and hiding sheets, resizing preference windows, zooming windows
# float 0 doesn't work
defaults write -g NSWindowResizeTime -float 0.001

# Opening and closing Quick Look windows
defaults write -g QLPanelAnimationDuration -float 0

# Rubberband scrolling (doesn't affect web views)
defaults write -g NSScrollViewRubberbanding -bool false

# Resizing windows before and after showing the version browser
# also disabled by NSWindowResizeTime -float 0.001
defaults write -g NSDocumentRevisionsWindowTransformAnimation -bool false

# Showing a toolbar or menu bar in full screen
defaults write -g NSToolbarFullScreenAnimationDuration -float 0

# Scrolling column views
defaults write -g NSBrowserColumnAnimationSpeedMultiplier -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock autohide-delay -float 0

# Showing and hiding Mission Control, command+numbers
defaults write com.apple.dock expose-animation-duration -float 0

# Showing and hiding Launchpad
defaults write com.apple.dock springboard-show-duration -float 0
defaults write com.apple.dock springboard-hide-duration -float 0

# Changing pages in Launchpad
defaults write com.apple.dock springboard-page-duration -float 0

# Only active applications in Dock
defaults write com.apple.dock static-only -bool true

# At least AnimateInfoPanes
defaults write com.apple.finder DisableAllAnimations -bool true

# Sending messages and opening windows for replies
defaults write com.apple.Mail DisableSendAnimations -bool true
defaults write com.apple.Mail DisableReplyAnimations -bool true

# Disable tab preview in Safari
defaults write com.apple.Safari DebugDisableTabHoverPreview 1

# Hide Desktop icons
defaults write com.apple.finder CreateDesktop false

# Default screenshot location to $HOME/Downloads
defaults write com.apple.screencapture location $HOME/Downloads

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0

# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1 # Preferences lowest value = 2
defaults write NSGlobalDomain InitialKeyRepeat -int 10 # Preferences lowest value = 15

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Enable subpixel font rendering on non-Apple LCDs
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Reduce the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0.2

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`, `Nlsv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Disable send and reply animations in Mail.app
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true

# Kill affected apps
for app in "Dock" "Finder" "Mail"; do
  killall "${app}" > /dev/null 2>&1
done

ok "Done setting macOS preferences"

echo "🍺 Your MacBook is configured!"
if [[ ${require_manual_actions} -eq 1 ]]; then
    echo "🔎 But some items require manual actions. Check the output above for more info."
fi
echo "🍿 Your MacBook may also need to reboot to apply the final changes."
cleanup_and_exit
