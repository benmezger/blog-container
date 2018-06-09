#!/bin/sh
set -e

# Check if the sample rules file exists
if [ ! -e /etc/filtron/example_rules.json ]; then
    cp /go/src/github.com/asciimoo/filtron/example_rules.json /etc/filtron/
fi

# run filtron
/go/bin/filtron -target app:${APP_PORT} -rules ${RULES_FILE} -listen 0.0.0.0:4004
