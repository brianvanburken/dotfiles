#!/usr/bin/env zsh

set -e
set -o pipefail

# Set XDG config
export XDG_CONFIG_HOME="${HOME}/.config"

# Location where to store code
readonly DEV_DIR="${HOME}/Developer"

# Location where to store configurations. Fixed, because nix/home/default.nix
# links app-written configs to this checkout.
readonly DOT_DIR="${DEV_DIR}/personal/dotfiles"

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
    if ! sudo -n true &> /dev/null; then
        input "We will need admin permissions for the next steps. Please enter your password and press <ENTER>"
    fi
    sudo -v
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

action "Creating special directories"
mkdir -p "${DEV_DIR}/personal"
mkdir -p "${DEV_DIR}/oss"
mkdir -p "${DEV_DIR}/work"

if [ ! -d "$DOT_DIR" ]; then
    action "Cloning configurations"
    git clone "https://github.com/${DOT_REPO}.git" "$DOT_DIR"
    ok "Created configurations directory at ${DOT_DIR}"
else
    ok "Dotfiles already present"
fi

# Each nix/machines file is a profile named after the hostname it sets
profiles=("${DOT_DIR}"/nix/machines/*.nix(N:t:r))
if (( ${#profiles} == 0 )); then
    error "No profiles found. Create ${DOT_DIR}/nix/machines/<hostname>.nix, git add it and re-run this script."
    exit 1
fi
input "Pick the profile for this machine"
PS3="> "
select machine_hostname in "${profiles[@]}"; do
    [[ -n "$machine_hostname" ]] && break
done
if [[ -z "$machine_hostname" ]]; then
    error "No profile picked."
    exit 1
fi
readonly machine_hostname
ok "Using the ${machine_hostname} profile"

softwareupdates="$(softwareupdate -l 2> /dev/null)"
if [[ "$softwareupdates" =~ "Recommended: YES" ]]; then
    warning "There are recommended OS updates, please install them and re-run this script."
    require_manual_actions=1
    echo "$softwareupdates"
else
    ok "Your system is up to date"
fi

notice "Verify Find My Mac is enabled via System Settings > Apple ID > iCloud"

if ! csrutil status | grep -q "enabled"; then
    warning "System Integrity Protection is DISABLED."
    require_manual_actions=1
else
    ok "System Integrity Protection is enabled"
fi

if ! fdesetup isactive &> /dev/null; then
    warning "FileVault is not enabled"
    action "Enabling FileVault"
    input "Save the recovery key printed below, it is shown only once"
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

# Only set the items below for mobile Macs
if [[ "$APPLE_COMPUTER_TYPE" =~ "MacBook" ]]; then
    powernap_status=$(pmset -g | awk '/powernap/ {print $2}')
    if [[ ${powernap_status} -eq 1 ]]; then
        action "Disabling Power Nap"
        cached_sudo pmset -a powernap 0
    else
        ok "Power Nap is disabled"
    fi

    hibernatemode=$(pmset -g | awk '/hibernatemode/ {print $2}')
    standbymode=$(pmset -g | awk '/standby / {print $2}')
    if pmset -g batt | grep Battery &> /dev/null; then
        if [[ ${hibernatemode} -ne 3 || ${standbymode} -ne 1 ]]; then
            action "Reverting to the default sleep behavior"
            cached_sudo pmset -a standby 1
            cached_sudo pmset -a hibernatemode 3
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

action "Setting secure permissions for ssh directory"
mkdir -p "${HOME}/.ssh"
find "${HOME}/.ssh" -type d -exec chmod 700 {} +
find "${HOME}/.ssh" -type f -exec chmod 600 {} +
ok "Permissions for ssh directory are secure"

readonly ssh_key="${HOME}/.ssh/id_ed25519"
if [[ ! -f "$ssh_key" ]]; then
    action "Generating an SSH key for this machine"
    input "Choose a passphrase for the key, it is stored in the keychain"
    ssh-keygen -t ed25519 -C "$machine_hostname" -f "$ssh_key"
    /usr/bin/ssh-add --apple-use-keychain "$ssh_key" || warning "Could not add the key to the SSH agent"
    ok "Generated ${ssh_key}"
else
    ok "SSH key found."
fi
ssh_public_key="$(cut -d ' ' -f 1,2 "${ssh_key}.pub")"
readonly ssh_public_key

if [[ ! -x /nix/var/nix/profiles/default/bin/nix ]]; then
    action "Installing Nix"
    # The installer calls sudo itself
    cached_sudo
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm
    ok "Nix installed"
else
    ok "Nix binary found."
fi
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

action "Activating the nix-darwin configuration"
system_path="$(nix build --no-link --print-out-paths "${DOT_DIR}#darwinConfigurations.${machine_hostname}.config.system.build.toplevel")"
# nix-darwin refuses to replace /etc files it doesn't know, such as those the Nix installer edits
etc_backup_dir="${HOME}/Downloads/backup_install_$(date +%Y-%m-%d)/etc"
managed_etc_files=(${(f)"$(cd "${system_path}/etc" && find . \( -type f -o -type l \) | sed 's|^\./||')"})
for name in "${managed_etc_files[@]}"; do
    if [[ -f "/etc/${name}" && ! -h "/etc/${name}" ]]; then
        cached_sudo mkdir -p "${etc_backup_dir}/${name:h}"
        cached_sudo mv "/etc/${name}" "${etc_backup_dir}/${name}"
        ok "Moved /etc/${name} to ${etc_backup_dir}/${name}"
    fi
done
cached_sudo "${system_path}/sw/bin/darwin-rebuild" switch --flake "${DOT_DIR}#${machine_hostname}"
export PATH="/run/current-system/sw/bin:${PATH}"
killall Dock Finder SystemUIServer 2>/dev/null || true
ok "System, dotfiles, casks and macOS preferences are configured"

action "Setting up fish as default shell"
readonly fish_command="/run/current-system/sw/bin/fish"
current_shell=$(dscl . -read "/Users/$(whoami)" UserShell | awk '{print $2}')
if [[ "$current_shell" != "$fish_command" ]]; then
    cached_sudo chsh -s "$fish_command" "$(whoami)"
fi
ok "Fish is now the default"

action "Creating local fish file"
touch "${XDG_CONFIG_HOME}/fish/conf.d/config.local.fish"

action "Registering the SSH key with GitHub"
readonly github_key_scopes="admin:public_key,admin:ssh_signing_key"
if ! gh auth status --hostname github.com &> /dev/null; then
    gh auth login --hostname github.com --git-protocol ssh --skip-ssh-key --web --scopes "$github_key_scopes"
fi
# Listing needs the key scopes, which an existing login may lack
if ! gh api user/keys --silent &> /dev/null || ! gh api user/ssh_signing_keys --silent &> /dev/null; then
    gh auth refresh --hostname github.com --scopes "$github_key_scopes"
fi
for key_type in authentication signing; do
    if [[ "$key_type" == "authentication" ]]; then
        endpoint="user/keys"
    else
        endpoint="user/ssh_signing_keys"
    fi
    if gh api "$endpoint" --paginate --jq '.[].key' | grep -qxF "$ssh_public_key"; then
        ok "SSH key is registered on GitHub for ${key_type}"
    else
        gh ssh-key add "${ssh_key}.pub" --title "$machine_hostname" --type "$key_type"
        ok "Registered the SSH key on GitHub for ${key_type}"
    fi
done

# Kept out of the repo. Lists every machine's signing key so their commits verify.
action "Writing allowed signers from GitHub"
git_email="$(git config --file "${DOT_DIR}/config/git/config" user.email)"
gh api user/ssh_signing_keys --paginate --jq '.[] | "\(.title)\t\(.key)"' |
    while IFS=$'\t' read -r key_title key; do
        printf '# %s\n%s %s\n' "$key_title" "$git_email" "$key"
    done > "${HOME}/.ssh/allowed_signers.tmp"
# Only replace the old file once the full list arrived
mv "${HOME}/.ssh/allowed_signers.tmp" "${HOME}/.ssh/allowed_signers"
ok "Wrote ~/.ssh/allowed_signers"

# Switch to SSH last, once GitHub knows this machine's key
action "Switching dotfiles remote to SSH"
git -C "$DOT_DIR" remote set-url origin "git@github.com:${DOT_REPO}.git"

echo "🍺 Your Mac is configured!"
if [[ ${require_manual_actions} -eq 1 ]]; then
    echo "🔎 But some items require manual actions. Check the output above for more info."
fi
echo "🍿 Your Mac may also need to reboot to apply the final changes."

exit 0
