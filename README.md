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

# MCP-Resources

## MCP Server Lists

* [Glama](https://glama.ai/mcp/servers?attributes=)
* [mcp.so](https://mcp.so/)
* [mcp-get.com](https://mcp-get.com/)
* [mcpservers.ai](https://www.mcpservers.ai/)
* [Smithery](https://smithery.ai/)
* https://mcpserver.cloud
* https://mcpservers.org/

## MCP Building Articles

* [Building MCP with LLMs](https://modelcontextprotocol.io/tutorials/building-mcp-with-llms)
* [How to Build MCP Servers with FastMCP: Step-by-Step Tutorial for Beginners](https://medium.com/@pedro.aquino.se/how-to-build-mcp-servers-with-fastmcp-step-by-step-tutorial-for-beginners-0a6ddd1d3f95)
* 

## MCP Resource Listing Standards

* [Service Discovwr for MCP](https://github.com/modelcontextprotocol/specification/discussions?discussions_q=is%3Aopen+well-known)
* [llms.txt](https://llmstxt.org/) (Note: should be moved to /.well-known/)
  
