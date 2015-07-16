 #!/bin/bash
set -x
set -e
echo "Running before_install-osx.sh on $TRAVIS_OS_NAME"

# # Display os with more verbose than $TRAVIS_OS_NAME
# lsb_release -a

# Update brew packages
# brew update
echo $HOME
# Use miniconda python (provide binaries for scipy and numpy on Linux)
if [[ "$PYTHON_VERSION" == "2.7" ]]; then
    curl -o miniconda.sh http://repo.continuum.io/miniconda/Miniconda-latest-MacOSX-x86_64.sh
    export PATH=/Users/travis/miniconda/bin:$PATH
else
    curl -o miniconda.sh http://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
    export PATH=/Users/travis/miniconda3/bin:$PATH
fi
chmod +x miniconda.sh
./miniconda.sh -b
conda update --yes -q conda

# Thre is no need to install atlas
conda install --yes pip python=$PYTHON_VERSION numpy scipy matplotlib

# Upgrade pip
pip install pip --upgrade

# Show config
which python
which pip
python --version


# Download V-REP
wget http://coppeliarobotics.com/V-REP_PRO_EDU_V${VREP_VERSION}_Mac.zip
unzip V-REP_PRO_EDU_V${VREP_VERSION}_Mac.zip
mv ./V-REP_PRO_EDU_V${VREP_VERSION}_Mac $VREP_ROOT_DIR

set +x