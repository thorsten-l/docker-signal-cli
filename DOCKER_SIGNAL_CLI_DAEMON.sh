#!/bin/bash
docker run --name signal-cli -it --rm -p 7583:7583 -v "`pwd`/data:/root/.local" signal-cli daemon --tcp '*:7583'
