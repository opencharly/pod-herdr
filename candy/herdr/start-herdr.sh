#!/bin/sh
# herdr-server: run the headless herdr server (default session) in the
# foreground for supervisord. The api socket lands at
# $HOME/.config/herdr/herdr.sock; herdr-bridge relays it to TCP:8095.
set -e
HOME_DIR="${HOME:-/home/user}"
export HOME="$HOME_DIR"
mkdir -p "$HOME_DIR/.config/herdr"
# A named default session keeps the socket path stable and the session
# disposable (the R10 bed re-provisions it on every fresh update).
if [ -n "${HERDR_SESSION:-}" ]; then
    exec herdr --session "$HERDR_SESSION" server
fi
exec herdr server
