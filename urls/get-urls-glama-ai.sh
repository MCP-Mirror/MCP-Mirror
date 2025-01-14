#!/bin/bash

curl https://glama.ai/mcp/servers.json| jq -r '.servers[].githubUrl' > urls-glama-ai.txt

