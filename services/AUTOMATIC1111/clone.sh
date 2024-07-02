#!/bin/bash

set -Eeuox pipefail

echo "Creating folder..."
mkdir -p /repositories/"$1"
cd /repositories/"$1"

echo "Cloning repository..."
git init
git remote add origin "$2"

echo "Updating repository..."
git fetch origin "$3" --depth=1

echo "Set repository to specific version..."
git reset --hard "$3"

echo "Removing .git folder..."
rm -rf .git
