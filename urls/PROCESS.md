# Process for mirroring urls

get recent data

Compare them and get new ones:

```
cat urls-glama-ai.txt github-repos-* github-repos-*| sort | uniq -u |sed 's/^/.\/MCP-Mirror\/utils\/mirror-github-repos-to-MCP-Mirror.sh --directory \/Users\/kurt\/GitHub\/MCP-Mirror --repo /' > urls-to-get.sh
```

