#!/bin/bash
# Claude Code Stop hook - Send desktop notification when task completes

# Read JSON from stdin
input=$(cat)

# Extract task description using jq (fallback to simple parsing if jq not available)
if command -v jq &> /dev/null; then
  description=$(echo "$input" | jq -r '.description // "Task completed"')
  success=$(echo "$input" | jq -r '.success // true')
else
  description="Task completed"
  success="true"
fi

# Determine notification title based on success
if [ "$success" = "true" ]; then
  title="✅ Claude Code: Task Completed"
else
  title="⚠️ Claude Code: Task Failed"
fi

# Send notification using osascript
osascript -e "display notification \"$description\" with title \"$title\" sound name \"default\""
