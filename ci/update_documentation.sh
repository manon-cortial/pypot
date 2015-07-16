#!/bin/bash
set -x

# Install Sphinx
pip install Sphinx[all]
pip install sphinxjp.themes.basicstrap

# TODO
# sphinx-build -b html . ..