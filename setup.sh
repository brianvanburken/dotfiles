# Ask for the administrator password upfront
sudo -v

sh setup/dotfile.sh
sh setup/osx.sh
sh setup/packages.sh

echo "Done. Note that some of these changes require a logout/restart to take effect."
