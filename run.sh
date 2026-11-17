#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
echo 'MintClub: http://localhost:8600'
python3 -m http.server 8600 --bind 127.0.0.1
