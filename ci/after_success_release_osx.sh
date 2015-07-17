#!/bin/bash
set +e
set -x
echo "Running after_success-release.sh on $TRAVIS_OS_NAME"

echo "Installing wheel..."
pip install -q wheel || exit
echo "Installing twine..."
pip install -q twine || exit

# Twine gets installed into /Users/travis/Library/Python/2.7/bin, which needs to
# be added to the PATH
# export PATH=/Users/travis/Library/Python/2.7/bin:${PATH}

echo "Creating distribution files..."
# We are not creating sdist here, because it's being created and uploaded in the
# after_succes-release-linux.sh
python setup.py bdist bdist_wheel || exit

echo "Created the following distribution files:"
ls -l dist

# Exit if commit is untrusted
if [[ "$TRAVIS" == "true" ]]; then
    if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
    echo "This is a pull request. No deployment will be done."
    exit 0
    fi
    if [[ "$TRAVIS_BRANCH" != "master" ]]; then
    echo "Testing on a branch other than master. No deployment will be done."
    exit 0
fi



set +x
set +e
echo "Uploading OS X egg to PyPi..."
twine upload dist/*.egg -u "${PYPI_USERNAME}" -p "${PYPI_PASSWD}"
echo "Uploading OS X Wheel package to PyPi..."
twine upload dist/*.whl -u "${PYPI_USERNAME}" -p "${PYPI_PASSWD}"

echo "Attempting to upload all distribution files to PyPi..."
twine upload dist/* -u "${PYPI_USERNAME}" -p "${PYPI_PASSWD}"
