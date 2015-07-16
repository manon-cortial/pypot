#!/bin/bash
set -x
set -e

git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_NAME

# Configure Git to push with GitHub Oauth token
git remote set-url origin https://$GH_TOKEN@github.com/$GH_USERNAME/$GH_REPO.git

# Install Sphinx
pip install -q Sphinx sphinxjp.themes.basicstrap
pip install -q bottle zmq zerorpc 

# Call @pierre-rouanet python snippet to build the doc
cd ..
curl -O https://gist.githubusercontent.com/pierre-rouanet/f296ea65a2dbf913ce78/raw/788e4b0433c1dac61aac681562dc59bb333e5e7e/make-doc.py
# For the tests, to be removed
sed -e s/poppy-project/show0k/g make-doc.py
python make-doc.py pypot
