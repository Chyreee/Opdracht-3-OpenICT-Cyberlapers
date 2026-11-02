#!/bin/bash
set -e

SOURCE="/home/ephraim/Opdracht-3-OpenICT-Cyberlapers"
DEST="/var/www/codesharing"

FILES=(
    homescreen.html
    homescreen.css
    homescreen.js
    login.html
    login.css
    login.js
    profile.html
    profile.js
    style.css
)

for FILE in "${FILES[@]}"; do
    sudo cp "$SOURCE/$FILE" "$DEST/$FILE"
done

echo "Website deployed successfully!"