#!/bin/bash
set -x

# Pep8 tests
set +e
echo -e "\e[33m"
flake8 --config=ci/flake8.config --statistics --count .
echo -e "\e[0m"
set -e

# Vrep start test
if [[ "$BUILD" == "test-vrep" ]]; then
    set +e
    pushd $VREP_ROOT_DIR/
        sudo apt-get install --yes xvfb
        xvfb-run --auto-servernum --server-num=1 ./vrep.sh -h  &
        sleep 10
    popd

    pip install poppy-humanoid
    cat << EOF | python -
    from poppy.creatures import PoppyHumanoid
    from pypot.vrep import from_vrep
    poppy = PoppyHumanoid(simulator='vrep')
    EOF


fi



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



