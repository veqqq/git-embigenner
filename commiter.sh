#!/bin/bash

file="test3.txt"

git init
git add .
git commit -m "Start monorepo"

# Start and end dates
start_date="2022-06-24"
end_date="2025-11-27"
current_date="$start_date" # gets incremented

process_date() {
    local current_date="$1"
    echo "Processing date: $current_date"
    
    dailyCommit=$(( (RANDOM % 17) - 4))  

    if [ "$dailyCommit" -gt 0 ]; then 
        echo -n -e "\nFor $current_date: " >> "$file"

        for ((i = 1; i <= dailyCommit; i++))
        do
            echo -n "$i" >> "$file" 
            commit_message="Created commit number $i today"
            git add "$file"
            commit_output=$(git commit --date "$current_date" -m "$commit_message" 2>&1)
            commit_hash=$(git rev-parse HEAD)
            git rebase --committer-date-is-author-date "$commit_hash" # > /dev/null 2>&1
        done
    fi
}

# Loop through each day
while [[ "$current_date" < "$end_date" ]] || [[ "$current_date" == "$end_date" ]]; do
    # Call the function for the current date
    process_date "$current_date"
    current_date=$(date -I -d "$current_date + 1 day")
done

