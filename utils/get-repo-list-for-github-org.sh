#!/bin/bash

# Ensure the script exits on errors
set -e

# Function to print usage information
usage() {
    echo "Usage: $0 --org-name ORG_NAME --env-token-name ENV_TOKEN_NAME --output-file OUTPUT_FILE"
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --org-name)
            ORG_NAME="$2"
            shift 2
            ;;
        --env-token-name)
            ENV_TOKEN_NAME="$2"
            shift 2
            ;;
        --output-file)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        *)
            echo "Unknown argument: $1"
            usage
            ;;
    esac
done

# Validate arguments
if [[ -z "$ORG_NAME" ]] || [[ -z "$ENV_TOKEN_NAME" ]] || [[ -z "$OUTPUT_FILE" ]]; then
    echo "Error: --org-name, --env-token-name, and --output-file arguments are required."
    usage
fi

# Get the GitHub token from the specified environment variable
TOKEN=$(printenv "$ENV_TOKEN_NAME")
if [[ -z "$TOKEN" ]]; then
    echo "Error: Environment variable $ENV_TOKEN_NAME is not set or empty."
    exit 1
fi

# Initialize variables
PAGE=1
JSON_ARRAY="[]"

echo "Fetching repository list for organization: $ORG_NAME using token from $ENV_TOKEN_NAME"

# Fetch repositories until results are empty
while true; do
    echo "Fetching page $PAGE..."
    RESPONSE=$(curl -s -H "Authorization: token $TOKEN" \
        "https://api.github.com/orgs/$ORG_NAME/repos?per_page=100&page=$PAGE")

    # Check if the response contains any repositories
    if [[ $(echo "$RESPONSE" | jq length) -eq 0 ]]; then
        echo "No more results. Stopping."
        break
    fi

    # Append the new repositories to the JSON array
    JSON_ARRAY=$(echo "$JSON_ARRAY" "$RESPONSE" | jq -s 'add')

    # Increment page number
    PAGE=$((PAGE + 1))
done

# Write the JSON array to the output file
echo "$JSON_ARRAY" | jq '.' > "$OUTPUT_FILE"

echo "Repository list saved to $OUTPUT_FILE"
