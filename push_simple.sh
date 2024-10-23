# Run by entering the command './push_simple.sh "commit message"'
# The commit message must be a string.
# Adds, commits, pulls, merges, pushes, and then checks out
# the branch you started in just one command.
#
# Likely a nano merge message screen will appear.
# Just press ctrl + x to continue.
#
# A more simple and slightly less automated version of 'push.sh'
#
# Note: this script may not work if there is a merge conflict,
# which would have to be handled separately.

git_status=$(git status)
read -r branch_name <<< "$git_status"
echo "$branch_name"
branch_name=${branch_name:10}

if [ ${#branch_name} -gt 0 ]; then
    git add . \
    && git commit -m "$1" \
    && git checkout main \
    && git pull origin main \
    && git merge "$branch_name --no-edit" \
    && git push -u origin main \
    && (git checkout -b "$branch_name" &> /dev/null \
            || git checkout "$branch_name") \
    && echo "Script successful" || echo "Script unsuccessful"
else
    echo "Script unsuccessful. Current branch name was not read."
fi
