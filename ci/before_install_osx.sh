 #!/bin/bash
set -x
echo "Running before_install-osx.sh on $TRAVIS_OS_NAME"

# Display os with more verbose than $TRAVIS_OS_NAME
lsb_release -a


# Update brew packages
brew update
brew outdated | grep -q <package-name> && brew upgrade <package-name>

# Upgrade pip
pip install pip --upgrade

pip install scipy -q

# Download V-REP
wget http://coppeliarobotics.com/V-REP_PRO_EDU_V${VREP_VERSION}_Mac.zip
unzip V-REP_PRO_EDU_V${VREP_VERSION}_Mac.zip
mv ./V-REP_PRO_EDU_V${VREP_VERSION}_Mac $VREP_ROOT_DIR

set +x