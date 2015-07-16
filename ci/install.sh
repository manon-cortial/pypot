#!/bin/bash

echo
echo Running install.sh...
echo

# Verify python version
python --version

cd ${TRAVIS_BUILD_DIR}
python setup.py install --user

python -c 'import sys;import os;import pypot;sys.stdout.write(os.path.abspath(os.path.join(pypot.__file__, "../..")))' || exit
