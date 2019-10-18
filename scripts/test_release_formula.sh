#!/bin/bash

# OCI CLI brew ormula directory
formula=/usr/local/Homebrew/Library/Taps/kern-lee/homebrew-oci-cli/oci-cli.rb
formula_directory=/usr/local/Homebrew/Library/Taps/kern-lee/homebrew-oci-cli
echo ${formula}
chmod -R 777 ${formula}

# Get latest CLI release from github and edit brew formula
version=$(curl --silent "https://api.github.com/repos/oracle/oci-cli/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
echo ${version}
sed -i '' "s@url.*@url \"https://github.com/oracle/oci-cli/archive/${version}.tar.gz\"@g" ${formula}
url=$(grep "url" ${formula})
echo ${url}
awk '/url.*$/ { printf("%s", $0); next } 1' ${formula} > tmp && mv tmp ${formula}
sed -i '' "s@.*url.*@${url}@g" ${formula}

# Get SHA256 of the tar and edit brew formula
SHA256=$(brew fetch oci-cli --build-from-source | grep "SHA256:" -m 1 | sed 's/^.*: //')
echo ${SHA256}
sed -i '' "s@.*url.*@${url}  sha256 \"${SHA256}\"@g" ${formula}
awk '{sub(/  sha256/,"\n  sha256");}1' ${formula} > tmp && mv tmp ${formula}

brew upgrade oci-cli
brew test oci-cli
brew audit --strict --online oci-cli