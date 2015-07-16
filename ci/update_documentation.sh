#!/bin/bash
set -x

# Install Sphinx
pip install Sphinx[all]
pip install sphinxjp.themes.basicstrap


curl -O https://gist.githubusercontent.com/pierre-rouanet/f296ea65a2dbf913ce78/raw/788e4b0433c1dac61aac681562dc59bb333e5e7e/make-doc.py
python make-doc.py pypot
