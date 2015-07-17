#!/bin/bash
set -x

# Pep8
set +e
flake8 --config=ci/flake8.config --show-pep8 .
set -e

# TODO :)
which python
which pip
python --version

cat <<EOF | python -
import pypot
import pypot.robot
import pypot.dynamixel
EOF

set +x
set +e