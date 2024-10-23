# Run by entering the command './push.sh "commit message"'
# Adds, commits, pulls, merges, pushes, and then checks out
# the branch you started on.
#
# May not work if there is a merge conflict, which would
# then have to be handled separately.

if [ $# -eq 1 ]; then
    git_status=$(git status)
    read -r branch_name <<< "$git_status"
    echo "$branch_name"
    branch_name=${branch_name:10}
    
    git add . \
    && git commit -m "$1" \
    && git checkout main \
    && git pull origin main \
    && git merge $branch_name \
    && git push -u origin main \
    && (git checkout -b $branch_name &> /dev/null \
            || git checkout $branch_name) \
    && echo "Successful" || echo "Unsuccessful"
    
else
    echo "Please enter the commit message as a single string argument."
fi

