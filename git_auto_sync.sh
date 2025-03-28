#!/bin/bash

# Configuration
REPO_DIR="$HOME/Desktop/MyNewCode"  # Your Git repo path
BRANCH="main"                       # Git branch
REMOTE="origin"                     # Git remote
LOGFILE="/tmp/git_auto_sync.log"    # Log file

# Initialize logging
echo "Git Auto-Sync started at $(date)" > "$LOGFILE"

# Function to commit and push changes
sync_changes() {
    cd "$REPO_DIR" || exit 1

    # Check for changes
    if [[ -n $(git status -s) ]]; then
        echo "Changes detected at $(date)" >> "$LOGFILE"
        git add . >> "$LOGFILE" 2>&1
        git commit -m "Auto-sync: $(date +'%Y-%m-%d %H:%M:%S')" >> "$LOGFILE" 2>&1
        git push "$REMOTE" "$BRANCH" >> "$LOGFILE" 2>&1
        echo "Changes pushed to $REMOTE/$BRANCH" >> "$LOGFILE"
    else
        echo "No changes detected at $(date)" >> "$LOGFILE"
    fi
}

# Ask for auto-sync mode
read -rp "Enable auto-sync every 60 seconds? (Y/N): " AUTO_SYNC
AUTO_SYNC=$(echo "$AUTO_SYNC" | tr '[:lower:]' '[:upper:]')

# Main loop
while true; do
    if [[ "$AUTO_SYNC" == "Y" ]]; then
        echo "Auto-sync mode: Enabled (60s interval)"
        while true; do
            sync_changes
            sleep 60
            read -t 1 -rp "Press [Y] to sync now or [N] to exit: " INPUT
            INPUT=$(echo "$INPUT" | tr '[:lower:]' '[:upper:]')
            [[ "$INPUT" == "N" ]] && exit 0
            [[ "$INPUT" == "Y" ]] && sync_changes
        done
    else
        echo "Manual sync mode: Press [Y] to sync or [N] to exit"
        read -rp "Choice: " INPUT
        INPUT=$(echo "$INPUT" | tr '[:lower:]' '[:upper:]')
        [[ "$INPUT" == "N" ]] && exit 0
        [[ "$INPUT" == "Y" ]] && sync_changes
    fi
done