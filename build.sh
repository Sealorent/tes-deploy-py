#!/bin/bash

# Update package list and install CMake
apt-get update
apt-get install -y cmake

# Install pipenv if it's not already installed
pip install pipenv

# Install Python dependencies
pipenv install --deploy --ignore-pipfile
