#!/bin/bash
set -x
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