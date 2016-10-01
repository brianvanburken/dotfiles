# This script is based on the script from Fabriquartz:
# https://github.com/Fabriquartz/laptop-install/blob/master/install.sh
fancy_echo() {
  local fmt="$1"; shift
  printf "\n$fmt\n" "$@"
}

brew_install() {
  if brew list -1 | grep -Fqx "$1"; then
    if ! brew outdated --quiet "$1" >/dev/null; then
      printf "Upgrading %s ... \n" "$1"
      brew upgrade "$@" >> out.log 2>&1
    else
      printf "Already installed %s\n" "$1"
    fi
  else
    printf "Installing %s ...\n" "$1"
    brew install "$@" >> out.log 2>&1
  fi
}

brew_cask_install() {
  if brew cask list -1 | grep -Fqx "$1"; then
    printf "Already installed %s\n" "$1"
  else
    printf "Installing %s ...\n" "$1"
    brew cask install "$@" >> out.log 2>&1
  fi
}

fancy_echo "This script will setup your laptop"

# Get name and email
fancy_echo "Before we start we need some basic details of you"
read -p "What is your full name? (e.g. Johny Appleseed): " full_name
read -p "What is your email address? (e.g. johny.appleseed@fabriquartz.com): " email_address

fancy_echo "Hello $full_name <$email_address>"

fancy_echo "Press any key to start the installation process, press <CTRL + C> to cancel"
read

fancy_echo "We need your sudo password to do a few things"
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Brew"
  source .profile
  brew_path=$HOME/.homebrew
  mkdir -p ${brew_path}
  chown -R $(whoami) ${brew_path}
  curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ${brew_path}
else
  fancy_echo "Updating Brew ..."
  brew update >> out.log
fi

fancy_echo "Installing Brew formulas!"

brew_install 'git'
brew_install 'git-flow'
brew_install 'tmux'
brew_install 'vim'
brew_install 'the_silver_searcher'
brew_install 'postgresql'
brew_install 'rabbitmq'
brew_install 'mongodb'
brew_install 'ctags'
brew_install 'heroku-toolbelt'
brew_install 'mas'

brew_install 'openssl'
brew_install 'readline'
brew_install 'gdbm'
brew_install 'libyaml'

brew link openssl readline gdbm libyaml --force

fancy_echo "Adding brew services"
brew services

fancy_echo "Updating misc Brew packages (if any)"
brew upgrade >> out.log 2>&1

fancy_echo "Cleaning up all the Brew spills"
brew cleanup >> out.log 2>&1
brew cask cleanup >> out.log 2>&1

fancy_echo "Create local shell file."
touch ~/.shell_local

fancy_echo "Symlinking dotfiles."
files=(.agignore .bash_aliases .bash_profile .bashrc .bundle .ctags .gemrc
       .gitconfig .gitignore_global .hammerspoon .hushlogin .profile .slate
       .tmux.conf .tool-versions .vimrc .zpreztorc .zsh_functions .zshrc)
dir="$PWD/"

for i in ${files[@]}; do
  ln -sFfv ${dir}${i} ~/${i}
done
fancy_echo "Done symlinking dotfiles."

fancy_echo "Installing asdf plugin manager."
git clone https://github.com/HashNuke/asdf.git ~/.asdf
source $HOME/.asdf/asdf.sh

fancy_echo "Adding node.js, ruby, erlang and elixir plugins to asdf plugin manager"
asdf plugin-add nodejs https://github.com/HashNuke/asdf-nodejs.git
asdf plugin-add ruby   https://github.com/HashNuke/asdf-ruby.git
asdf plugin-add elixir https://github.com/HashNuke/asdf-elixir.git

fancy_echo "Installing Node.js with asdf plugin."
asdf install nodejs $(cat ~/.tool-versions | grep nodejs | tr -dc '0-9\.')

fancy_echo "Installing Ruby with asdf plugin."
asdf install ruby $(cat ~/.tool-versions | grep ruby | tr -dc '0-9\.')

fancy_echo "Installing Elixir with asdf plugin."
asdf install elixir $(cat ~/.tool-versions | grep elixir | tr -dc '0-9\.')


fancy_echo "Update Ruby gem system."
gem update --system

fancy_echo "Installing bundler and Rails."
gem install bundler rails

fancy_echo "Disabling NPM progress for faster installs."
npm set progress=false

fancy_echo "Updating NPM."
npm install npm -g

fancy_echo "Creating folder ~/Developer"
mkdir -p ~/Developer

fancy_echo "Upgrading Hex."
mix local.hex

fancy_echo "Install Phoenix"
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez

if [ -f ~/.ssh/id_rsa ]
then
  fancy_echo "Skipping SSH key generation, you already have one"
else
  fancy_echo "Generating SSH key"
  ssh-keygen -q -t rsa -b 4096 -C "$email_address" -N "" -f ~/.ssh/id_rsa
fi

cat ~/.ssh/id_rsa.pub | pbcopy
fancy_echo "\nCopyied public key to clipboard, please add it to your Github account."

fancy_echo "Configuring name and email in .gitconfig"
git config --global user.name "$full_name"
git config --global user.email "$email_address"

fancy_echo "Installing vim plugins"
mkdir -p ~/.vim/
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall

fancy_echo 'Installing apps'

brew_cask_install "alfred"
brew_cask_install "hammerspoon"
brew_cask_install "flux"
brew_cask_install "omnifocus"
brew_cask_install "dash"
brew_cask_install "the-unarchiver"
brew_cask_install "franz"

fancy_echo 'Install MAS apps'

mas install 918858936 # Airmail
mas install 443987910 # 1Password
mas install 497799835 # Xcode

fancy_echo 'Setup OS X configuration'
# Original script by Mathias Bynens (http://mths.be/osx)

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Restart automatically if the computer freezes
systemsetup -setrestartfreeze on

# The keyboard react faster to keystrokes
defaults write NSGlobalDomain KeyRepeat -int 0

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Enable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

###############################################################################
# Screen                                                                      #
###############################################################################

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Hide icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: disallow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool false

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show the ~/Library folder
chflags nohidden ~/Library

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles YES

# Disable animations when opening and closing windows.
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Disable animations when opening a Quick Look window.
defaults write -g QLPanelAnimationDuration -float 0

# Disable animation when opening the Info window in OS X Finder (CMD⌘ + i).
defaults write com.apple.finder DisableAllAnimations -bool true

# Disable animations when you open an application from the Dock.
defaults write com.apple.dock launchanim -bool false

###############################################################################
# Dock & hot corners                                                          #
###############################################################################

# Set the icon size of Dock items to 45 pixels
defaults write com.apple.dock tilesize -int 55

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don’t show Dashboard as a Space and remove the dashboard
defaults write com.apple.dock dashboard-in-overlay -bool true
defaults write com.apple.dashboard mcx-disabled -boolean YES

# Remove the auto-hiding Dock delay
defaults write com.apple.Dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Show only running applications in the Dock
defaults write com.apple.dock static-only -bool TRUE

# Position dock on the left
defaults write com.apple.dock orientation left

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Disable the standard delay in rendering a Web page.
defaults write com.apple.Safari WebKitInitialTimedLayoutDelay 0.25

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Allow hitting the Backspace key to go to the previous page in history
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Address Book" "Calendar" "Contacts" "Dashboard" "Dock" "Finder" \
  "Mail" "Safari"  "SystemUIServer" "iCal"
do
  killall "$app" > /dev/null 2>&1
done

fancy_echo "Done configuring OSX"

fancy_echo "Changing system Bash to ZSH with Prezto"
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
ln -sFfv $HOME/.zprezto/runcoms/zlogin ~/.zlogin
ln -sFfv $HOME/.zprezto/runcoms/zlogout ~/.zlogout
ln -sFfv $HOME/.zprezto/runcoms/zprofile ~/.zprofile
ln -sFfv $HOME/.zprezto/runcoms/zshenv ~/.zshenv

fancy_echo "Reloading shell"
chsh -s $(which zsh)

fancy_echo "Done running script"
fancy_echo "Note that some of these changes require a logout/restart to take effect."
