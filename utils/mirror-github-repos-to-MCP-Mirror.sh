#!/bin/bash

# Function to show usage
show_usage() {
    echo "Usage: $0 --repo <github_repo_url> --directory <local_directory>"
    echo "Example: $0 --repo https://github.com/modelcontextprotocol/servers --directory /path/to/mirror"
    echo "Note: Requires GITHUB_MIRROR_TOKEN environment variable to be set"
    exit 1
}

# Function to extract org/user and repo name from URL
parse_github_url() {
    local url=$1
    # Remove .git extension if present and https://github.com/
    local path=${url#https://github.com/}
    path=${path%.git}
    
    # Split into org and repo
    local org=${path%/*}
    local repo=${path#*/}
    
    # Create the new repository name format
    REPO_NAME="${org}_${repo}"
    echo "Repository will be mirrored as: $REPO_NAME"
}

# Function to create repository in MCP-Mirror organization
create_mirror_repo() {
    local repo_name=$1
    echo "Creating repository in MCP-Mirror organization: $repo_name"
    
    # Check for specific environment variable
    if [ -z "$GITHUB_MIRROR_TOKEN" ]; then
        echo "Error: GITHUB_MIRROR_TOKEN environment variable is not set"
        echo "Please set it with: export GITHUB_MIRROR_TOKEN=your_token_here"
        echo "This token needs 'repo' and organization repository creation permissions"
        exit 1
    fi
    
    # Create the repository using GitHub API
    curl -s -H "Authorization: token $GITHUB_MIRROR_TOKEN" \
         -H "Accept: application/vnd.github.v3+json" \
         https://api.github.com/orgs/mcp-mirror/repos \
         -d "{
              \"name\": \"$repo_name\",
              \"private\": false,
              \"description\": \"Mirror of $REPO_URL\",
              \"has_issues\": false,
              \"has_projects\": false,
              \"has_wiki\": false
            }" || {
        echo "Failed to create repository. If it already exists, continuing..."
    }
}

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --repo) REPO_URL="$2"; shift ;;
        --directory) BASE_DIR="$2"; shift ;;
        *) echo "Unknown parameter: $1"; show_usage ;;
    esac
    shift
done

# Validate required parameters
if [ -z "$REPO_URL" ] || [ -z "$BASE_DIR" ]; then
    echo "Error: Missing required parameters"
    show_usage
fi

# Create base directory if it doesn't exist
mkdir -p "$BASE_DIR"

# Parse the GitHub URL
parse_github_url "$REPO_URL"

# Create the mirror repository in MCP-Mirror organization
create_mirror_repo "$REPO_NAME"

# Full path for the clone
MIRROR_DIR="$BASE_DIR/${REPO_NAME}"

# Check if directory already exists
if [ -d "$MIRROR_DIR" ]; then
    echo "Directory already exists: $MIRROR_DIR"
    echo "Updating existing mirror..."
    cd "$MIRROR_DIR"
    git fetch -p origin
else
    echo "Creating new mirror in: $MIRROR_DIR"
    # Clone the repository normally (not as a mirror)
    git clone "$REPO_URL" "$MIRROR_DIR"
    cd "$MIRROR_DIR"
    # Add the mirror remote
    MIRROR_REPO="git@github.com:mcp-mirror/${REPO_NAME}.git"
    git remote add mirror "$MIRROR_REPO"
    # Push all branches and tags to mirror
    git push --mirror mirror
fi

echo "Mirror operation completed successfully"
