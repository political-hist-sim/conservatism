#!/usr/bin/env bash
# Package the built game for offline play: a zip of out/html, inside a
# "conservatism" folder, with instructions, saved as
# out/html/conservatism-offline.zip so the website offers it for download,
# plus out/html/conservatism-lite.zip without the music.
# Run after `npm run build`. Needs the `zip` command.
set -euo pipefail
cd "$(dirname "$0")/.."
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir "$work/conservatism"
# everything the game needs, except an old copy of the zip itself
cp -a out/html/. "$work/conservatism/"
rm -f "$work/conservatism/conservatism-offline.zip" "$work/conservatism/conservatism-lite.zip"
cp tools/PLAY_OFFLINE.txt "$work/conservatism/PLAY OFFLINE.txt"
rm -f out/html/conservatism-offline.zip
(cd "$work" && zip -qr -9 conservatism-offline.zip conservatism)
mv "$work/conservatism-offline.zip" out/html/conservatism-offline.zip

# a lite copy without the music (a few MB instead of 60), for slow or
# filtered connections; the game is told to keep the music off
rm -rf "$work/conservatism/music"
sed -i 's#<script src="game.js"#<script>window.NO_MUSIC = true;</script>\n        <script src="game.js"#' "$work/conservatism/index.html"
grep -q 'window.NO_MUSIC = true' "$work/conservatism/index.html"
rm -f out/html/conservatism-lite.zip
(cd "$work" && zip -qr -9 conservatism-lite.zip conservatism)
mv "$work/conservatism-lite.zip" out/html/conservatism-lite.zip
ls -l out/html/conservatism-offline.zip out/html/conservatism-lite.zip
