#!/bin/bash
# Start the service via stack exec
set -e
cd "$(dirname "$0")"
if [ -e /opt/ipfs-video-tags ]; then
    export PATH=/opt/ipfs-video-tags/.local/bin:$PATH
fi
stack build
stack exec ipfs-video-tags-exe

