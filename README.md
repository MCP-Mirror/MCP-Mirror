# MCP-Mirror

This is a collection of tools to mirror MCP related GitHub repos so that if they are deleted or taken down we still have a copy (in the first 4 eeks of MCP being available 4 MCP server repos have already disapeared).

## Repo mirroring

We mirror the MCP related repos to https://github.com/MCP-mirror/ using a repo naming convention of [organization or username]_[repo name], thus giving each repo a unique name, and since underscores are not allowed in organization or usernames (as far as I know) it makes an easy to read and safe character to deliminate what is the organization or username, and what is the repo name.

We use the script utils/mirror-github-repos-to-MCP-Mirror.sh to pull down the repo, and create a new repo and push the contents up.

## Repo updating

The script sets the origin to the origin URL and sets mirror to the mirror URL:

```
git remote -v
mirror	git@github.com:mcp-mirror/modelcontextprotocol_servers.git (fetch)
mirror	git@github.com:mcp-mirror/modelcontextprotocol_servers.git (push)
origin	https://github.com/modelcontextprotocol/servers (fetch)
origin	https://github.com/modelcontextprotocol/servers (push)
```

So to update it simply:

```
cd /path/to/mirrors/modelcontextprotocol_servers
git fetch -p origin
git push --mirror mirror
```

Which can be done via utils/update-github-repos-to-MCP-Mirror.sh
