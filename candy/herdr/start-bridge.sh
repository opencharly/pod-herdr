#!/bin/sh
# herdr-bridge: relay the herdr server's NDJSON unix socket to TCP:8095 so
# host-side `herdr:` check verbs and `charly herdr --endpoint` reach the venue
# (the check engine's ResolveEndpoint / ${HOST_PORT:8095} machinery).
set -e
HOME_DIR="${HOME:-/home/user}"
# The server socket path honors HERDR_SESSION (the candy sets it to "base"):
# a named session keeps its socket under sessions/<name>/herdr.sock.
if [ -n "${HERDR_SESSION:-}" ]; then
    SOCK="${HERDR_SOCKET_PATH:-${HOME_DIR}/.config/herdr/sessions/${HERDR_SESSION}/herdr.sock}"
else
    SOCK="${HERDR_SOCKET_PATH:-${HOME_DIR}/.config/herdr/herdr.sock}"
fi
# Wait for the server socket (supervisord start order is not guaranteed).
i=0
while [ ! -S "$SOCK" ] && [ "$i" -lt 60 ]; do
    sleep 0.5
    i=$((i + 1))
done
if [ ! -S "$SOCK" ]; then
    echo "herdr-bridge: socket $SOCK not found after 30s" >&2
    exit 1
fi
exec socat TCP-LISTEN:8095,fork,reuseaddr UNIX-CONNECT:"$SOCK"
