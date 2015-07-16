#!/bin/bash
set -x
set -e

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

    if [ -d $tmp_repo ] then
       rm -rf $tmp_repo/
    fi
    mkdir $tmp_repo

    git clone -b gh-pages $git_url $tmp_repo 
    cp -r $doc_src/_build/html/ $tmp_repo
    pushd $tmp_repo
        git add -A
        git commit -m "doc updates"
        git push origin gh-pages
    popd
popd
