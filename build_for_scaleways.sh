#!/bin/bash
#Build the binary for a debian scaleways server
set -e
(
    cd debian-buster-stack
    docker build -t debian-buster-stack .
)
docker run -v `pwd`:/opt/project -it debian-buster-stack
mv ipfs-video-tags-exe provision/roles/videotagloader/files