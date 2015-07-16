#!/bin/bash
set -x
set -e
# TODO :)
python --version

cat <<EOF | python -
import pypot
import pypot.robot
import pypot.dynamixel
EOF

set +x
set +e