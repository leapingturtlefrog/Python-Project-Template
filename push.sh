# Run by entering the command './push.sh "commit message"'
# The commit message must be a string.
# Adds, commits, pulls, merges, pushes, and then checks out
# a new branch in one command.
#
# Likely a nano merge message screen will appear.
# Just press ctrl + x to continue.
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
        && git pull origin main --no-edit \
        && git push -u origin main \
        && echo -e "\nScript successful. Please checkout a non-main branch for the future" \
        || echo -e "\nScript unsuccessful"
    elif [ ${#branch_name} -gt 0 ]; then
        git add . \
        && git commit -m "$1" \
        && git checkout main \
        && git pull origin main \
        && git merge "$branch_name" --no-edit \
        && git push -u origin main \
        && echo -e "\nPush successful" \
        && branch_letters=$(echo "$branch_name" | grep -o '[a-zA-Z]*') \
        && branch_number=$(echo "$branch_name" | grep -o '[0-9]*') \
        && new_branch_number=$((branch_number + 1)) \
        && new_branch_name="$branch_letters$new_branch_number" \
        && git checkout -b "$new_branch_name" > /dev/null \
        && echo "Checkout successful from $branch_name to $new_branch_name" \
        && fifth_old_branch_number=$((new_branch_number - 5)) \
        && fifth_old_branch_name="$branch_letters$fifth_old_branch_number" \
        && git branch -d "$fifth_old_branch_name" \
        && echo "Fifth oldest branch ($fifth_old_branch_name) successfully deleted" \
        || echo "Branch $fifth_old_branch_name not found and not deleted" \
        && echo "Script successful" \
        || echo -e "\nScript unsuccessful"
    else
        echo "Branch name not received from git status. Failure"
    fi
else
    echo "Please enter the commit message as a single string argument"
fi
