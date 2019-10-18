#!/bin/bash

# Change our formula for GitHub
formula=~/project/oci-cli.rb
version=$(curl --silent "https://api.github.com/repos/oracle/oci-cli/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
sed -i '' "s@url.*@url \"https://github.com/oracle/oci-cli/archive/${version}.tar.gz\"@g" ${formula}
url=$(grep "url" ${formula})
awk '/url.*$/ { printf("%s", $0); next } 1' oci-cli.rb > tmp && mv tmp ${formula}
sed -i '' "s@.*url.*@${url}@g" ${formula}

SHA256=$(brew fetch oci-cli --build-from-source | grep "SHA256:" -m 1 | sed 's/^.*: //')
sed -i '' "s@.*url.*@${url}  sha256 \"${SHA256}\"@g" ${formula}
awk '{sub(/  sha256/,"\n  sha256");}1' oci-cli.rb > tmp && mv tmp ${formula}