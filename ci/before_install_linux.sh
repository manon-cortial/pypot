 #!/bin/bash
set -x
echo
echo Running before_install-linux.sh...
echo

# Update travis Ubuntu repos
sudo apt-get -qq update

# Install Scipy dependancies
sudo apt-get install -qq --force-yes libblas3gf libc6 libgcc1 libgfortran3 liblapack3gf libstdc++6 build-essential gfortran python-all-dev libatlas-base-dev

# Upgrade pip
pip install pip --upgrade