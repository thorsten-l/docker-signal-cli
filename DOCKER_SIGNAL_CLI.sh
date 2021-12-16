#!/bin/bash
docker run --name signal-cli -it --rm -v "`pwd`/data:/root/.local" signal-cli "$@"
