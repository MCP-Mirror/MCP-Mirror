#!/bin/bash

rm mcp-get-com.json

curl https://raw.githubusercontent.com/michaellatman/mcp-get/refs/heads/main/packages/package-list.json > mcp-get-com.json

jq -r '.[].sourceUrl' mcp-get-com.json | grep github | sed 's/\/$//' | grep -E '^https://github\.com/[^/]+/[^/]+$' > urls-mcp-get-com.txt
