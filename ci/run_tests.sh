#!/bin/bash
set -x
set -e

# Pep8
flake8 --config=ci/flake8.config --show-pep8 .

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