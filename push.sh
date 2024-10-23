# Run by entering the command './push.sh "commit message"'
# The commit message must be a string.
# Adds, commits, pulls, merges, pushes, and then checks out
# the branch you started in just one command.
#
# Note: this script may not work if there is a merge conflict,
# which would have to be handled separately.

if [ $# -eq 1 ]; then
    git_status=$(git status)
    read -r branch_name <<< "$git_status"
    echo "$branch_name"
    branch_name=${branch_name:10}
    
    
    if [ "$branch_name" = "main" ]; then
        git add . \
        && git commit -m "$1" \
        && git pull origin main \
        && git push -u origin main \
        && echo -e "\nScript successful. Please checkout a non-main branch for the future" \
        || echo -e "\nScript unsuccessful"
    elif [ ${#branch_name} -gt 0 ]; then
        git add . \
        && git commit -m "$1" \
        && git checkout main \
        && git pull origin main \
        && git merge "$branch_name" \
        && git push -u origin main \
        && echo "Push successful" \
        && branch_letters=$(echo "$branch_name" | grep -o '[a-zA-Z]*') \
        && echo "$branch_letters" \
        && branch_number=$(echo "$branch_name" | grep -o '[0-9]*') \
        && echo "$branch_number" \
        && new_branch_number=$((branch_number + 1)) \
        && echo "$new_branch_number" \
        && new_branch_name="$branch_letters$new_branch_number" \
        && echo "$new_branch_name" \
        && git checkout -b "$new_branch_name" \
        && echo "Checkout successful" \
        && echo -e "Original branch: $branch_name\nNew branch: $new_branch_name (checked out)" \
        || echo -e "\nScript unsuccessful"
        
    else
        echo "Branch name not received from git status. Failure"
    fi
    : '
    if [ ${#branch_name} -gt 0 ]; then
        git add . \
        && git commit -m "$1" \
        && git checkout main \
        && git pull origin main \
        && git merge "$branch_name" \
        && git push -u origin main \
        # && (git checkout -b "$branch_name" &> /dev/null \
        #        || git checkout "$branch_name") \
        # && 
        && echo "Script successful" || echo "Script unsuccessful"
        
        
        $branch_name -eq "main" && echo "Please checkout a non-main branch for the future" \
        || 
    else
        echo "Script unsuccessful. Current branch name was not read."
    fi
    '
else
    echo "Please enter the commit message as a single string argument."
fi
