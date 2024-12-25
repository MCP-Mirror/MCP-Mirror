#!/bin/bash

# Function to show usage
show_usage() {
    echo "Usage: $0 --directory <base_directory>"
    echo "Example: $0 --directory /path/to/mirrors"
    exit 1
}

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --directory) BASE_DIR="$2"; shift ;;
        *) echo "Unknown parameter: $1"; show_usage ;;
    esac
    shift
done

# Validate required parameters
if [ -z "$BASE_DIR" ]; then
    echo "Error: Missing required directory parameter"
    show_usage
fi

# Ensure the base directory exists
if [ ! -d "$BASE_DIR" ]; then
    echo "Error: Directory $BASE_DIR does not exist"
    exit 1
fi

# Store the original directory
ORIGINAL_DIR=$(pwd)

# Function to check if a remote exists
has_remote() {
    local dir=$1
    local remote=$2
    cd "$dir" && git remote | grep -q "^$remote$"
    return $?
}

# Process each directory
for dir in "$BASE_DIR"/*/; do
    if [ ! -d "$dir" ]; then
        continue
    fi

    # Remove trailing slash from directory name
    dir=${dir%/}
    dir_name=$(basename "$dir")
    
    echo "Checking directory: $dir_name"

    # Check if this is a git repository
    if [ ! -d "$dir/.git" ]; then
        echo "  Skipping: Not a git repository"
        continue
    fi

    # Check for both origin and mirror remotes
    if has_remote "$dir" "origin" && has_remote "$dir" "mirror"; then
        echo "  Found both origin and mirror remotes, updating..."
        cd "$dir"
        
        # Show the remotes for verification
        echo "  Remotes:"
        git remote -v
        
        # Perform the update
        echo "  Fetching from origin..."
        if git fetch -p origin; then
            echo "  Pushing to mirror..."
            if git push --mirror mirror; then
                echo "  Successfully updated $dir_name"
            else
                echo "  Error: Failed to push to mirror for $dir_name"
            fi
        else
            echo "  Error: Failed to fetch from origin for $dir_name"
        fi
    else
        echo "  Skipping: Missing required remotes (needs both origin and mirror)"
    fi

    # Return to base directory
    cd "$ORIGINAL_DIR"
done

echo "Update operation completed"

