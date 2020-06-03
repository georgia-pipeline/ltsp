#!/bin/sh -e
/etc/init.d/nbd-server start
PID=$(cat /var/run/nbd-server.pid)

if ps -o pid= -p "$PID" 2>/dev/null; then
    trap '/etc/init.d/nbd-server stop' INT HUP TERM EXIT
    echo "nbd-server was started" >&2
    tail -f --follow --pid "$PID" /dev/null & wait $!
else
    echo "can not start nbd-server" >&2
    exit 1
fi
