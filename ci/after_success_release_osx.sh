#!/bin/bash
set -x

echo
echo "Running after_success-release.sh..."
echo

echo "Installing wheel..."
pip install wheel --user || exit
echo "Installing twine..."
pip install twine || exit

# Twine gets installed into /Users/travis/Library/Python/2.7/bin, which needs to
# be added to the PATH
export PATH=/Users/travis/Library/Python/2.7/bin:${PATH}

echo "Creating distribution files..."
# We are not creating sdist here, because it's being created and uploaded in the
# after_succes-release-linux.sh
python setup.py bdist bdist_wheel || exit

echo "Created the following distribution files:"
ls -l dist


echo "Uploading OS X egg to PyPi..."
twine upload dist/*.egg -u "${PYPI_USERNAME}" -p "${PYPI_PASSWD}"
echo "Uploading OS X Wheel package to PyPi..."
twine upload dist/*.whl -u "${PYPI_USERNAME}" -p "${PYPI_PASSWD}"

echo "Attempting to upload all distribution files to PyPi..."
twine upload dist/* -u "${PYPI_USERNAME}" -p "${PYPI_PASSWD}"
