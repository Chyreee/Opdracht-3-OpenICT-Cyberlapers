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
    plattegrond.html
    floor-data.js
)

for FILE in "${FILES[@]}"; do
    sudo cp "$SOURCE/$FILE" "$DEST/$FILE"
done

sudo mkdir -p "$DEST/assets"
sudo cp "$SOURCE"/assets/* "$DEST/assets/"

echo "Website deployed successfully!"