 #!/bin/bash

echo
echo Running before_install-osx.sh...
echo

# Update brew packages
brew update
brew outdated | grep -q <package-name> && brew upgrade <package-name>

# Upgrade pip
pip install pip --upgrade