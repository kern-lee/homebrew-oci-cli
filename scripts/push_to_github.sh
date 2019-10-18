#!/bin/bash

version=$(curl --silent "https://api.github.com/repos/oracle/oci-cli/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
git config credential.helper 'cache --timeout=120'
git config user.email "kernlee23@gmail.com"
git config user.name "kernleee"
git add .
git commit -m "Releasing version ${version} [ci skip]"
# Push quietly to prevent showing the token in log
git push -u origin master