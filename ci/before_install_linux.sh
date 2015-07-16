 #!/bin/bash
set -x

echo "Running before_install-linux.sh on $TRAVIS_OS_NAME"

# Use miniconda to install scipy and numpy packages (need to be compiled)
wget http://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh -O miniconda.sh
chmod +x miniconda.sh
./miniconda.sh -b
export PATH=/home/travis/miniconda/bin:$PATH
conda update --yes conda
conda install --yes -n condaenv pip
source activate condaenv
conda install --yes python=$TRAVIS_PYTHON_VERSION atlas numpy scipy matplotlib


# Upgrade pip
pip install pip --upgrade


