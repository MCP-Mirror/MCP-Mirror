#!/bin/bash

curl https://glama.ai/mcp/servers.json| jq -r '.servers[].githubUrl' > urls-glama-ai.txt

# Find any new URLs

cat github* urls-glama-ai.txt urls-glama-ai.txt| sort | uniq -c | grep " 2 " | grep githu | sed 's/^   2 /.\/MCP-Mirror\/utils\/mirror-github-repos-to-MCP-Mirror.sh --directory \/Users\/kurt\/GitHub\/MCP-Mirror --repo /' > ../../script.sh

