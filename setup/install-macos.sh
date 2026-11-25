#!/usr/bin/env zsh

set -e
set -o pipefail

# Set XDG config
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"

# The flake only targets Apple Silicon
readonly HOMEBREW_PREFIX="/opt/homebrew"

# Location where to store code
export DEV_DIR="${DEV_DIR:=${HOME}/Developer}"

# Location where to store configurations
export DOT_DIR="${DOT_DIR:=${DEV_DIR}/personal/dotfiles}"

# Name of dotfiles repo
readonly DOT_REPO="brianvanburken/dotfiles"

# Determine macOS version
OS_VERSION="$(sw_vers -productVersion)"
readonly OS_VERSION

# Supported macOS versions
readonly SUPPORTED_MACOS_VERSIONS=("15" "26" "27")

# Determine Mac model
APPLE_COMPUTER_TYPE="$(system_profiler SPHardwareDataType | awk -F': ' '/Model Name/ {print $2}')"
readonly APPLE_COMPUTER_TYPE

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

cached_sudo() {
    if sudo -n true &> /dev/null; then
        sudo -v
    else
        input "We will need admin permissions for the next steps. Please enter your password and press <ENTER>"
        sudo -v
    fi
    if (( $# > 0 )); then
        sudo "${@}"
    fi
}

drop_sudo_credentials() {
    sudo -K
}

# Make sure we always cleanup whenever this script exits, no matter how it exits
trap drop_sudo_credentials EXIT

action "Setting up macOS"

if [[ "$(uname)" != "Darwin" || "$(uname -m)" != "arm64" ]]; then
    error "This setup only supports macOS on Apple Silicon."
    exit 1
fi

OS_MAJOR_VERSION="$(echo "$OS_VERSION" | cut -f 1,1 -d '.')"
if (( ! ${SUPPORTED_MACOS_VERSIONS[(Ie)$OS_MAJOR_VERSION]} )); then
    error "You are running an unsupported version of macOS (${OS_MAJOR_VERSION})."
    error "Upgrade first and re-run this script."
    exit 1
fi

if [[ ! -d "$(xcode-select -p)" ]]; then
    action "Installing command line tools (without XCode)"
    xcode-select --install
    ok "Installing command line tools done. Rerun this script to install everything else."
    exit 0
else
    ok "Command line tools are installed."
fi

# Get sudo credentials
cached_sudo

# nix-darwin manages the casks and formulae but needs Homebrew itself
if [[ ! -r "${HOMEBREW_PREFIX}/bin/brew" ]]; then
    notice " Need to install Homebrew..."
    action "Installing Homebrew and required components. This may take some time... ☕️ "

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ok "Installing Homebrew done"
else
    ok "Homebrew binary found."
fi

# Reload sudo
cached_sudo

softwareupdates="$(softwareupdate -l 2> /dev/null)"
if [[ "$softwareupdates" =~ "Recommended: YES" ]]; then
    warning "There are recommended OS updates, please install them and re-run this script."
    require_manual_actions=1
    echo "$softwareupdates"
else
    ok "Your system is up to date"
fi

notice "Verify Find My Mac is enabled via System Settings > Apple ID > iCloud"

if cached_sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate | grep disabled &> /dev/null; then
    action "Firewall is disabled, enabling..."
    cached_sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
else
    ok "Firewall is enabled"
fi

if ! spctl --status 2>&1 | grep -q "enabled"; then
    warning "Gatekeeper is disabled, enabling..."
    cached_sudo spctl --master-enable
else
    ok "Gatekeeper is enabled"
fi

if ! csrutil status | grep -q "enabled"; then
    warning "System Integrity Protection is DISABLED."
    require_manual_actions=1
else
    ok "System Integrity Protection is enabled"
fi

# Prolong sudo
cached_sudo

if ! fdesetup isactive &> /dev/null; then
    warning "FileVault is not enabled"
    action "Enabling FileVault"
    cached_sudo fdesetup enable -user "$(whoami)"
else
    ok "Filevault is enabled"
fi

# AutoBackup is absent when Time Machine was never configured
time_machine_auto_backup=$(defaults read /Library/Preferences/com.apple.TimeMachine AutoBackup 2> /dev/null || echo 0)
if [[ ${time_machine_auto_backup} -eq 1 ]]; then
    action "Disabling Time Machine"
    cached_sudo tmutil disable
else
    ok "Time Machine is disabled"
fi

# Prolong sudo
cached_sudo

# Only set the items below for mobile Macs
if [[ "$APPLE_COMPUTER_TYPE" =~ "MacBook" ]]; then
    powernap_status=$(pmset -g | awk '/powernap/ {print $2}')
    if [[ ${powernap_status} -eq 1 ]]; then
        action "Disabling Power Nap"
        cached_sudo pmset -a powernap 0
    else
        ok "Power Nap is disabled"
    fi

    # Keys missing on Apple Silicon yield empty output, so default to the desired value
    filevault_destroykeysonstandby=$(pmset -g | awk '/DestroyFVKeyOnStandby/ {print $2}')
    filevault_destroykeysonstandby="${filevault_destroykeysonstandby:-0}"
    hibernatemode=$(pmset -g | awk '/hibernatemode/ {print $2}')
    hibernatemode="${hibernatemode:-3}"
    standbymode=$(pmset -g | awk '/standby / {print $2}')
    standbymode="${standbymode:-1}"
    autopoweroff=$(pmset -g | awk '/autopoweroff / {print $2}')
    autopoweroff="${autopoweroff:-0}"
    if pmset -g batt | grep Battery &> /dev/null; then
        if [[ ${filevault_destroykeysonstandby} -eq 1 || ${hibernatemode} -eq 25 || ${standbymode} -eq 0 || ${autopoweroff} -eq 1 ]]; then
            action "Reverting to default sleep behavior to address stability issues with Secure Deep Sleep"
            cached_sudo pmset -a destroyfvkeyonstandby 0
            cached_sudo pmset -a standby 1
            cached_sudo pmset -a standbydelay 10800
            cached_sudo pmset -a hibernatemode 3
            cached_sudo pmset -a autopoweroff 0
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

# Prolong sudo
cached_sudo

action "Setting secure permissions for ssh directory"
mkdir -p "${HOME}/.ssh"
find "${HOME}/.ssh" -type d -exec chmod 700 {} +
find "${HOME}/.ssh" -type f -exec chmod 600 {} +
ok "Permissions for ssh directory are secure"

# Prolong sudo
cached_sudo

action "Creating special directories"
mkdir -p "${DEV_DIR}/personal"
mkdir -p "${DEV_DIR}/oss"
mkdir -p "${DEV_DIR}/work"

if [ ! -d "$DOT_DIR" ]; then
    action "Cloning configurations"
    git clone "https://github.com/${DOT_REPO}.git" "$DOT_DIR"
    git -C "$DOT_DIR" config --local user.name "Brian van Burken"
    git -C "$DOT_DIR" config --local user.email "brianvanburken@users.noreply.github.com"
    ok "Created configurations directory at ${DOT_DIR}"
else
    ok "Dotfiles already present"
fi

# Prolong sudo
cached_sudo

if [[ ! -x /nix/var/nix/profiles/default/bin/nix ]]; then
    action "Installing Nix"
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm
    ok "Nix installed"
else
    ok "Nix binary found."
fi
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Prolong sudo
cached_sudo

action "Activating the nix-darwin configuration"
system_path="$(nix build --no-link --print-out-paths "${DOT_DIR}#darwinConfigurations.mac.config.system.build.toplevel")"
# nix-darwin refuses to replace /etc files it doesn't know, such as those the Nix installer edits
managed_etc_files=(${(f)"$(cd "${system_path}/etc" && find . \( -type f -o -type l \) | sed 's|^\./||')"})
for name in "${managed_etc_files[@]}"; do
    if [[ -f "/etc/${name}" && ! -h "/etc/${name}" ]]; then
        cached_sudo mkdir -p "/tmp/etc/${name:h}"
        cached_sudo mv "/etc/${name}" "/tmp/etc/${name}"
        ok "Moved /etc/${name} to /tmp/etc/${name}"
    fi
done
cached_sudo "${system_path}/sw/bin/darwin-rebuild" switch --flake "${DOT_DIR}#mac"
export PATH="/run/current-system/sw/bin:${PATH}"
killall Dock Finder SystemUIServer 2>/dev/null || true
ok "System, dotfiles, casks and macOS preferences are configured"

# Prolong sudo
cached_sudo

action "Setting up fish as default shell"
readonly fish_command="/run/current-system/sw/bin/fish"
current_shell=$(dscl . -read "/Users/$(whoami)" UserShell | awk '{print $2}')
if [[ "$current_shell" != "$fish_command" ]]; then
    cached_sudo chsh -s "$fish_command" "$(whoami)"
fi

action "Setting up fish"
"$fish_command" -i -c 'setup_fish; exit;'

action "Creating local fish file"
touch "${XDG_CONFIG_HOME}/fish/conf.d/config.local.fish"
ok "Fish is now the default"

# Prolong sudo
cached_sudo

if [[ -x "$(command -v mise)" ]]; then
    eval "$(mise activate zsh)"
    action "Installing mise plugins and versions"
    mise install
    ok "Mise versions installed"
else
    warning "Mise not found, skipping tool installation"
fi

# Switch to SSH last: a fresh machine has no SSH key during install
action "Switching dotfiles remote to SSH"
git -C "$DOT_DIR" remote set-url origin "git@github.com:${DOT_REPO}.git"
notice "Restore ~/.ssh/id_ed25519 and ~/.ssh/allowed_signers to push and sign commits"

echo "🍺 Your MacBook is configured!"
if [[ ${require_manual_actions} -eq 1 ]]; then
    echo "🔎 But some items require manual actions. Check the output above for more info."
fi
echo "🍿 Your MacBook may also need to reboot to apply the final changes."

exit 0
