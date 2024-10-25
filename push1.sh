#!/bin/bash

# Run with './push.sh "commit message"'
# Adds, commits, pulls, merges, pushes, checks out a new branch, and deletes the fifth oldest branch.

if [ $# -ne 1 ]; then
    echo "Please enter the commit message as a single string argument"
    exit 1
fi

commit_message="$1"
branch_name=$(git branch --show-current)  # More reliable branch name retrieval

if [ -z "$branch_name" ]; then
    echo "Error: Unable to retrieve the current branch name."
    exit 1
fi

if [ "$branch_name" = "main" ]; then
    git add . \
    && git commit -m "$commit_message" \
    && git pull origin main --no-edit \
    && git push -u origin main \
    && echo -e "\nPush successful. Please checkout a non-main branch for future work." \
    || echo -e "\nScript unsuccessful"
else
    # Proceed if on a non-main branch
    git add . \
    && git commit -m "$commit_message" \
    && git checkout main \
    && git pull origin main \
    && git merge "$branch_name" --no-edit \
    && git push -u origin main \
    && echo -e "\nPush and merge successful."

    # Generate new branch name based on current branch
    branch_letters=$(echo "$branch_name" | grep -o '[a-zA-Z]*')
    branch_number=$(echo "$branch_name" | grep -o '[0-9]*')
    new_branch_number=$((branch_number + 1))
    new_branch_name="$branch_letters$new_branch_number"

    # Create or checkout new branch
    git checkout "$new_branch_name" 2>/dev/null || git checkout -b "$new_branch_name"
    echo "Checked out new branch: $new_branch_name"

    # Calculate and delete the fifth oldest branch if it exists
    fifth_old_branch_number=$((new_branch_number - 5))
    fifth_old_branch_name="$branch_letters$fifth_old_branch_number"

    if git show-ref --quiet "refs/heads/$fifth_old_branch_name"; then
        git branch -d "$fifth_old_branch_name" &> /dev/null \
        && echo "Deleted fifth oldest branch: $fifth_old_branch_name" \
        || echo "Unable to delete branch $fifth_old_branch_name (might be checked out or protected)."
    else
        echo "No fifth oldest branch found to delete."
    fi
fi
