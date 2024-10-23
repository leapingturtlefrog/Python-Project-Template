if [ $# -eq 1 ]; then
    git_status=$(git status)
    read -r branch_name <<< "$git_status"
    echo "$branch_name"
    branch_name=${branch_name:10}
    
    git add . \
    && git commit -m $1 \
    && git checkout main \
    && git pull origin main \
    && git merge $branch_name \
    && git push -u origin main \
    && git checkout -b $branch_name \
    && echo "Successful" || echo "Unsuccessful"
    
else
    echo "Please enter the commit message as a single argument."
fi