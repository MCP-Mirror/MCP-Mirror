#!/bin/bash

rm github-repos-mcp-mirrored.txt

../utils/get-repo-list-for-github-org.sh --org-name MCP-Mirror --env-token-name GITHUB_MIRROR_TOKEN --output-file repos.json

jq -r '.[].html_url' repos.json | sort > github-repos-mcp-mirrored.txt

jq -r '.[].name' repos.json | sed 's/_/\//' | sed 's/^/https:\/\/github.com\//' | sort > github-repos-upstream-mirrored.txt
