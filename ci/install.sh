#!/bin/bash
set -x
echo "Running install.sh on $TRAVIS_OS_NAME"

# Verify python version
python --version

cd ${SETUP_DIR}
python setup.py install

python -c 'import sys;import os;import pypot;sys.stdout.write(os.path.abspath(os.path.join(pypot.__file__, "../..")))' || exit
