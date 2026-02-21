#!/bin/bash
# Claude Code Notification hook - Send desktop notification when Claude needs attention
# Events: permission_prompt, idle_prompt, auth_success, elicitation_dialog

# Read JSON from stdin
input=$(cat)

if command -v jq &> /dev/null; then
  message=$(echo "$input" | jq -r '.message // "Claude Code needs your attention"')
else
  message="Claude Code needs your attention"
fi

title="🔔 Claude Code"

# Send notification using osascript
osascript -e "display notification \"$message\" with title \"$title\" sound name \"default\""
