#!/usr/bin/env bash

set -e
set -o pipefail

# Force specific PATH
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

# Location where to store dotfiles
export DOT_DIR=${DOT_DIR:=$HOME/Developer/personal/dotfiles}

# Directory for plugins
export PLUG_DIR=${XDG_DATA_HOME:=$HOME/.local/share}

# Set the download URL
readonly SOURCE_URL=${SOURCE_URL:=https://raw.githubusercontent.com/brianvanburken/dotfiles/master/}

# Determine macOS version
readonly OS_VERSION="$(sw_vers -productVersion)"

# Supported macOS versions
readonly SUPPORTED_MACOS_VERSIONS=("10.12" "10.13" "10.14" "10.15", "11.0", "11.1")

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

# Initially no reboot is required
require_reboot=0

action() {
  echo -e "${WHITE}--->${NO_COLOR} $1"
}
ok() {
  echo -e "${LIGHT_GREEN}[OK]${NO_COLOR} $1"
}
input() {
  echo -e "${WHITE}[INPUT]${NO_COLOR} $1"
}
notice() {
  echo -e "${LIGHT_CYAN}[NOTICE]${NO_COLOR} $1"
}
warning() {
  echo -e "${YELLOW}[WARNING]${NO_COLOR} $1"
}
error() {
  echo -e "${LIGHT_RED}[ERROR]${NO_COLOR} $1"
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
  if [[ ! -z $@ ]]; then
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

echo "Setting up macOS"
echo -e "================================================\n\n"
echo -e "If you see a notice don't be alarmed, it might be an intended one.\n\n"

if [[ "$(uname)" != "Darwin" ]]; then
  error "No, macOS setup does not work on non macOS machines.."
  cleanup_and_exit 1
fi

readonly OS_MAJOR_VERSION=$(echo ${OS_VERSION} | cut -f 1,2 -d '.')
# Stylewise the value we want to test should be on the left side. But checking
# for a value in an array does not work with the value on the left side. Other
# possibilities (looping over the array) are harder to read. Thus we decided to
# keep the value on the right hand side.
if [[ ! ${SUPPORTED_MACOS_VERSIONS[@]} =~ ${OS_MAJOR_VERSION} ]]; then
  error "You are running an unsupported version of macOS (${OS_MAJOR_VERSION}). Upgrade first and re-run this script. Or create an OPS ticket if you are running the latest version of macOS"
  cleanup_and_exit 1
fi

if [[ -z ${TERM_PROGRAM} ]]; then
  error "This command should be run from a Terminal whiled logged in to a graphical session on your Mac. Exiting..."
  cleanup_and_exit 1
fi

if [[ $(xcode-select -p 1>/dev/null) =~ 0 ]]; then
    action "Installing command line tools (without XCode)"
    xcode-select --install
    ok "Installing command line tools done. Rerun this script to install everything else."
    cleanup_and_exit 0
fi

# Get sudo credentials
cached_sudo

# Install Homebrew
if [[ ! -r /usr/local/bin/brew ]]; then
  notice " Need to install Homebrew..."
  action "Installing Homebrew and required components. This may take some time... ☕️ "

  /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" >/dev/null
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
curl -fsSL "$SOURCE_URL/macos/homebrew/Brewfile" | brew bundle --file=- | strip_colors
ok "Installing software done."

# Reload sudo
cached_sudo

softwareupdates="$(softwareupdate -l 2>/dev/null)"
if [[ "${softwareupdates}" =~ "recommended" ]]; then
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
if [[ "${APPLE_COMPUTER_TYPE}" =~ "MacBook" ]]; then
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

if [[ ! -d "${HOME}/.ssh" ]]; then
  action "Creating ssh directory and setting permissions"
  mkdir -p ${HOME}/.ssh
  chmod 700 ${HOME}/.ssh
elif [[ "$(stat -f "%A" ${HOME}/.ssh)" != "700" ]]; then
  action "Setting secure permissions for ssh directory"
  chmod 700 ${HOME}/.ssh
  find ${HOME}/.ssh -type f -exec chmod 600 {} \;
  find ${HOME}/.ssh -type d -exec chmod 700 {} \;
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

action "Creating $HOME/Developer/personal/"
mkdir -p $HOME/Developer/personal
action "Creating $HOME/.local/share/"
mkdir -p $HOME/.local/share/
action "Creating $HOME/.local/share/shell"
mkdir -p $HOME/.local/share/shell/
action "Creating $HOME/.config"
mkdir -p $HOME/.config/
action "Creating $HOME/.cache"
mkdir -p $HOME/.cache/
ok  "Done creating local directories"

action "Creating $HOME/.config/git/config.local"
mkdir -p $HOME/.config/git/
touch $HOME/.config/git/config.local
action "Creating $HOME/.hushlogin"
touch $HOME/.hushlogin
ok  "Done creating local files"

if [ ! -d $DOT_DIR ]; then
    action "Cloning dotfiles"
    git clone https://github.com/brianvanburken/dotfiles.git $DOT_DIR
    cd $DOT_DIR
    git remote remove origin
    git remote add origin git@github.com:brianvanburken/dotfiles.git
    cd -
    ok "Created dotfiles directory at $DOT_DIR"
else
    ok "Dotfiles already present"
fi

NVIM_DIR=$PLUG_DIR/nvim
if [ ! -d $NVIM_DIR ]; then
    action "Installing neovim plugins"
    curl -fLo $NVIM_DIR/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    nvim +PlugInstall +qall
    ok "Neovim plugins installed"
fi

action "Linking dotfiles in $HOME to $DOT_DIR"
files=(
    "config/ag"
    "config/asdf"
    "config/editorconfig"
    "config/git"
    "config/hammerspoon"
    "config/ideavim"
    "config/nvim"
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

action "Linking $HOME/Developer/.editorignore"
rm -f $HOME/Developer/.editorconfig
ln -s $DOT_DIR/config/editorconfig/config $HOME/Developer/.editorconfig

action "Linking $HOME/.default-gems"
rm -f $HOME/.default-gems
ln -s $DOT_DIR/config/asdf/default-gems $HOME/.default-gems

action "Linking $HOME/Library/ApplicationSupport/iTerm2/Scripts/AutoLaunch/auto_dark_mode.py"
rm -rf $HOME/Library/ApplicationSupport/iTerm2/Scripts/AutoLaunch/
mkdir -p $HOME/Library/ApplicationSupport/iTerm2/Scripts/AutoLaunch/
ln -s $DOT_DIR/macos/iterm/auto_dark_mode.py $HOME/Library/ApplicationSupport/iTerm2/Scripts/AutoLaunch/auto_dark_mode.py

ok "Done linking dotfiles"


action "Change hammerspoon directory to respect XDG"
defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"
ok "Done setting up hammerspoon"

if [[ -r /usr/local/bin/asdf ]]; then
    action "Adding asdf plugins"
    asdf plugin-add ruby || true
    asdf plugin-add nodejs || true
    asdf plugin-add elm || true
    asdf plugin-add erlang || true
    asdf plugin-add elixir || true
    asdf plugin-add python || true
    asdf plugin-add haskell || true
    asdf plugin-add java || true
    asdf plugin-add kotlin || true
    asdf plugin-add gradle || true
    ok "asdf plugins added"

    action "Installing asdf versions"
    cd ~
    asdf install
    cd - > /dev/null 2>&1
else
    warning "asdf plugin manager not found"
fi

if [[ ${INSTALL_MINICONDA} = true ]]; then
    export PATH="$MINICONDA_PATH/bin:$PATH"
    export MINICONDA_PATH="$XDG_DATA_HOME/miniconda"

    if [ ! -d "$MINICONDA_PATH" ]; then
        action "Installing miniconda"
        wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
        chmod +x ./Miniconda3-latest-MacOSX-x86_64.sh
        ./Miniconda3-latest-MacOSX-x86_64.sh -b -p "$MINICONDA_PATH"
        rm ./Miniconda3-latest-MacOSX-x86_64.sh

        conda install pip -y
        ok "Miniconda installed"
    else
        ok "Minicond is already installed"
    fi
fi

# Prolong sudo
cached_sudo

if [ ! -d ~/Developer/personal/oss/hosts/ ]; then
    action "Setup blacklist hostfile"
    HOST_DIR=~/Developer/personal/oss/hosts
    rm -rf $HOST_DIR
    git clone https://github.com/StevenBlack/hosts.git --depth=1 $HOST_DIR
    ln -s $DOT_DIR/macos/myhosts $HOST_DIR/myhosts
    cd $HOST_DIR
    pip3 install --user -r requirements.txt
    python3 updateHostsFile.py -b -a -f -r -c -e fakenews gambling porn social
    cd -
    ok "Done setup hostfile"
fi

cached_sudo

if [ -d /Applications/Alfred\ 4.app ]; then
    action "Setup Alfred"
    # Disable spotlight on cmd-space so Alfred can use it
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "{ enabled = 0; value = { parameters = ( 32, 49, 1048576); type = standard; }; }"
    # Disable spotlight window shortcut
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "{ enabled = 0; value = { parameters = ( 32, 49, 1048576); type = standard; }; }"
    # Set sync prefs
    defaults write com.runningwithcrayons.Alfred-Preferences syncfolder "$DOT_DIR/macos/alfred"
    ok "Done setting up Alfred"
fi

action "Disabling animations to speed up macOS"
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
require_reboot=1
ok "Done disabling animations"

action "Setting macOS preferences"
# Hide Desktop icons
defaults write com.apple.finder CreateDesktop false
ok "Done setting preferences"

action "Writing default screenshot location to $HOME/Pictures/Screenshots"
mkdir -p $HOME/Pictures/Screenshots/
defaults write com.apple.screencapture location $HOME/Pictures/Screenshots/
ok "Done writing default screenshot location"

if [[ ${require_manual_actions} -eq 1 ]]; then
  echo "🔎   Setup completed, but some items require manual actions. Check the output above for more info."
  cleanup_and_exit
elif [[ ${require_reboot} -eq 1 ]]; then
  echo "🍿   Your MacBook needs to reboot to apply the final changes."
  cleanup_and_exit
else
  echo "🍺    Your MacBook is configured!"
  cleanup_and_exit
fi
