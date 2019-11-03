#!/bin/bash
set -e
cp -r /opt/project ~/build
cd ~/build
stack install
mkdir -p /opt/project/bdist
cp -r ~/.local/bin/*-exe /opt/project/bdist