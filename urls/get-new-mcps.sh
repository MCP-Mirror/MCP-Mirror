#!/bin/bash

./get-urls-MCP-Mirror.sh
./get-urls-glama-ai.sh
./get-urls-mcp-get-com.sh

cat urls-glama-ai.txt github-repos-* github-repos-*| sort | uniq -u |sed 's/^/.\/MCP-Mirror\/utils\/mirror-github-repos-to-MCP-Mirror.sh --directory \/Users\/kurt\/GitHub\/MCP-Mirror --repo /' > urls-to-get.sh
chmod +x urls-to-get.sh

cd ../..

./MCP-Mirror/urls/urls-to-get.sh

