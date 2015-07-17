#!/bin/bash
set -x

# Pep8
set +e
flake8 --config=ci/flake8.config --statistics --count .
set -e

# TODO :)
which python
which pip
python --version

python -c 'import sys;import os;import pypot;sys.stdout.write(os.path.abspath(os.path.join(pypot.__file__, "../..")))'

cat <<EOF | python -
import pypot
import pypot.robot
import pypot.dynamixel
EOF

set +x
set +e