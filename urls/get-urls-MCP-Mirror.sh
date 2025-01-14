#!/bin/bash

rm urls-github-MCP-Mirror.txt

../utils/get-repo-list-for-github-org.sh --org-name MCP-Mirror --env-token-name GITHUB_MIRROR_TOKEN --output-file repos.json

jq -r '.[].html_url' repos.json > github-repos-mcp-mirrored.txt

jq -r '.[].name' repos.json | sed 's/_/\//' | sed 's/^/https:\/\/github.com\//' > github-repos-upstream-mirrored.txt
