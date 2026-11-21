#!/bin/bash

set -u
export TZ="Europe/Helsinki"
SRC="ubuntu@192.168.1.110:/var/www/html/"
DEST=/srv/backups/website
LOG=/var/log/website-backup.log
KEY=/root/.ssh/backup_ed25519
TS=$(date +%Y-%m-%d_%H%M)

mkdir -p "$DEST"
if rsync -a -e "ssh -i $KEY -o BatchMode=yes" \
     --link-dest="$DEST/latest" "$SRC" "$DEST/$TS/"; then
  ln -sfn "$DEST/$TS" "$DEST/latest"
  echo "$(date -Is) OK   $TS" >> "$LOG"
  ls -1dt "$DEST"/20* | tail -n +25 | xargs -r rm -rf
else
  echo "$(date -Is) FAIL $TS" >> "$LOG"
  rm -rf "$DEST/$TS"
  exit 1
fi
