#!/bin/bash
set -x
set -e

# TODO parse online doc to see if it is the last version or not
pypot_src_version=$(python -c "import pypot; print (pypot.__version__)")
pypi_package_version=$(python ci/get_pypi_last_version.py pypot)
echo "Pypi version: "$pypi_package_version
echo "Source version: "$pypot_src_version

git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_NAME
git_url=https://$GH_TOKEN@github.com/$GH_USERNAME/$GH_REPO.git
# Configure Git to push with GitHub Oauth token
git remote set-url origin $git_url

# check the git config
cat .git/config

# Install Sphinx
pip install -q Sphinx sphinxjp.themes.basicstrap
pip install -q bottle zmq zerorpc 

# Build the doc
pushd ..
    doc_src=./"$GH_REPO"/doc
    tmp_repo=/tmp/$GH_REPO-doc

    make -C $doc_src clean
    make -C $doc_src html

    if [ -d $tmp_repo ]; then
       rm -rf $tmp_repo/
    fi
    mkdir $tmp_repo

    git clone -b gh-pages $git_url $tmp_repo 
    cp -r $doc_src/_build/html/ $tmp_repo

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

    # Exit if Pypi is up to date (need to check online doc instead)
    if [[ "$pypi_package_version" == "$pypot_src_version" ]]; then
        echo "Already up to date"
        exit 0
    fi

    # Push the new documentation only if it is not a pull request and we are on master
    pushd $tmp_repo
        git add -A
        git commit -m "doc updates"
        git push origin gh-pages
    popd
popd
