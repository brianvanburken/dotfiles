#!/bin/sh
sudo -v

sh setup/dotfile.sh
sh setup/osx.sh
sh setup/packages.sh
sh setup/software.sh

echo "Done. Note that some of these changes require a logout/restart to take effect."
