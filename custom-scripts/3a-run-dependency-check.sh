#!/bin/bash

sudo find /tmp -amin +10 -exec rm -rf {} +

./dependency-check/bin/dependency-check.sh -s ./artifacts -o ./report-dependency-check --format ALL --proxyserver 127.0.0.1 --proxyport 3128