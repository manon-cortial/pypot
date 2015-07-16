 #!/bin/bash
echo "Running before_install-osx.sh on $TRAVIS_OS_NAME"

# Update brew packages
brew update
brew outdated | grep -q <package-name> && brew upgrade <package-name>

# Upgrade pip
pip install pip --upgrade

pip install scipy -q
