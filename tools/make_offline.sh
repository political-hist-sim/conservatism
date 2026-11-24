#!/usr/bin/env bash
# Package the built game for offline play: a zip of out/html, inside a
# "conservatism" folder, with instructions, saved as
# out/html/conservatism-offline.zip so the website offers it for download.
# Run after `npm run build`. Needs the `zip` command.
set -euo pipefail
cd "$(dirname "$0")/.."
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir "$work/conservatism"
# everything the game needs, except an old copy of the zip itself
cp -a out/html/. "$work/conservatism/"
rm -f "$work/conservatism/conservatism-offline.zip"
cp tools/PLAY_OFFLINE.txt "$work/conservatism/PLAY OFFLINE.txt"
rm -f out/html/conservatism-offline.zip
(cd "$work" && zip -qr -9 conservatism-offline.zip conservatism)
mv "$work/conservatism-offline.zip" out/html/conservatism-offline.zip
ls -l out/html/conservatism-offline.zip
