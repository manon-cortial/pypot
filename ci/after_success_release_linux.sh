#!/bin/bash
echo "Running after_success-release.sh on $TRAVIS_OS_NAME"

echo "Installing wheel..."
pip install wheel || exit
echo "Installing twine..."
pip install twine || exit

echo "Creating distribution files..."
# This release build creates the source distribution. All other release builds
# should not.
python setup.py sdist bdist bdist_wheel || exit

echo "Created the following distribution files:"
ls -l dist
# These should get created on linux:
# ...-cp27-none-linux-x86_64.whl
# ....linux-x86_64.tar.gz
# ...-py2.7-linux-x86_64.egg
# ....tar.gz

echo "Uploading Linux egg to PyPi..."
twine upload dist/*.egg -u "${PYPI_USERNAME}" -p "${PYPI_PASSWD}"
echo "Uploading source package to PyPi..."
twine upload dist/*.tar.gz -u "${PYPI_USERNAME}" -p "${PYPI_PASSWD}"

# We can't upload the wheel to PyPi because PyPi rejects linux platform wheel
# files.
# See: https://bitbucket.org/pypa/pypi-metadata-formats/issue/15/enhance-the-platform-tag-definition-for

