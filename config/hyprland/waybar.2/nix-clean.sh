#!/run/current-system/sw/bin/bash
# Shell options for safety
set -euo pipefail
IFS=$'\n\t'
# Constants for notification IDs
NOTIFY_BASE_ID=10000
NOTIFY_INCREMENT=100
# Parameterize limit for batch notifications
NOTIFY_BATCH_LIMIT=${1:-10}
# Check if dunstify is available
if ! command -v dunstify &> /dev/null; then
    echo "dunstify could not be found. Please install it."
    exit 1
fi
# Check if mktemp is available
if ! command -v mktemp &> /dev/null; then
    echo "mktemp could not be found. Please install it."
    exit 1
fi
# Create a temporary file once and reuse it
temp_file=$(mktemp)
# Function to send notifications via dunstify with optional delay
dunst_notify() {
    local message="$1"
    local urgency="$2"
    local timeout="$3"
    local notify_id="$4"
    dunstify -i "System Cleanup" "$message" -u "$urgency" -t "$timeout" -r "$notify_id"
}
# Function to shorten paths if they exceed a certain length
shorten_path() {
    local full_path="$1"
    local max_length="${2:-100}"
    if [ ${#full_path} -gt $max_length ]; then
        local shortened_path="${full_path:0:20}...${full_path: -20}"
        echo "$shortened_path"
    else
        echo "$full_path"
    fi
}
# Function to send notifications in batches
send_batch_notifications() {
    local messages=("$@")
    for msg in "${messages[@]}"; do
        dunst_notify "$msg" "low" 3000 "$NOTIFY_BASE_ID"
        NOTIFY_BASE_ID=$((NOTIFY_BASE_ID + NOTIFY_INCREMENT))
        sleep 1
    done
}
# Function to process output and send notifications
process_output() {
    local output="$1"
    local base_notification_id="$2"
    local current_id="$base_notification_id"
    local block=""
    local path_messages=()
    local grouping=0
    local has_evaluation_warning=0
    while IFS= read -r line; do
        line=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        if echo "$line" | grep -q -E "evaluation warning"; then
            block="$line"
            grouping=1
            has_evaluation_warning=1
            continue
        elif echo "$line" | grep -E "archived and support will no longer be provided" >/dev/null; then
            if [ $has_evaluation_warning -eq 1 ]; then
                block+="\n$line"
            else
                dunst_notify "$line" "normal" 10000 "$current_id"
                current_id=$((current_id + NOTIFY_INCREMENT))
            fi
            continue
        elif echo "$line" | grep -E "Please see https?://" >/dev/null; then
            if [ $has_evaluation_warning -eq 1 ]; then
                block+="\n$line"
                dunst_notify "$(printf "%b" "$block")" "normal" 10000 "$current_id"
                current_id=$((current_id + NOTIFY_INCREMENT))
                block=""
                grouping=0
                has_evaluation_warning=0
            else
                dunst_notify "$line" "normal" 10000 "$current_id"
                current_id=$((current_id + NOTIFY_INCREMENT))
            fi
            continue
        fi
        if echo "$line" | grep -q "setting up /etc"; then
            dunst_notify "$line" "normal" 10000 "$current_id"
            current_id=$((current_id + NOTIFY_INCREMENT))
            continue
        fi
        if echo "$line" | grep -q -E "/[^ ]+" || echo "$line" | grep -q -E "(Copying path|Removing|Deleting)"; then
            path=$(echo "$line" | grep -oP "/[^ ]+")
            if [ -n "$path" ]; then
                shortened_path=$(shorten_path "$path")
                line=${line//$path/$shortened_path}
            fi
            path_messages+=("$line")
            if [ "${#path_messages[@]}" -ge "$NOTIFY_BATCH_LIMIT" ]; then
                send_batch_notifications "${path_messages[@]}"
                path_messages=()
            fi
            continue
        else
            if [ -n "$line" ]; then
                dunst_notify "$line" "normal" 10000 "$current_id"
                current_id=$((current_id + NOTIFY_INCREMENT))
            fi
        fi
    done <<< "$output"
    if [ "${#path_messages[@]}" -gt 0 ]; then
        send_batch_notifications "${path_messages[@]}"
    fi
    if [ -n "$block" ]; then
        dunst_notify "$(printf "%b" "$block")" "normal" 10000 "$current_id"
    fi
}
# Function to clean up temporary files
cleanup() {
    if [ -f "$temp_file" ]; then
        rm -f "$temp_file"
    fi
}
trap cleanup EXIT
# NixOS rebuild switch
dunst_notify "Starting NixOS rebuild switch..." "normal" 5000 "$NOTIFY_BASE_ID"
NOTIFY_BASE_ID=$((NOTIFY_BASE_ID + NOTIFY_INCREMENT))
sudo nixos-rebuild switch > "$temp_file" 2>&1
cmd_status=$?
process_output "$(cat "$temp_file")" "$NOTIFY_BASE_ID"
if [ $cmd_status -ne 0 ]; then
    dunst_notify "NixOS rebuild switch failed!" "normal" 5000 "$NOTIFY_BASE_ID"
    exit 1
fi
NOTIFY_BASE_ID=$((NOTIFY_BASE_ID + NOTIFY_INCREMENT))
# NixOS rebuild boot
dunst_notify "Starting NixOS rebuild boot..." "normal" 5000 "$NOTIFY_BASE_ID"
NOTIFY_BASE_ID=$((NOTIFY_BASE_ID + NOTIFY_INCREMENT))
sudo nixos-rebuild boot > "$temp_file" 2>&1
cmd_status=$?
process_output "$(cat "$temp_file")" "$NOTIFY_BASE_ID"
if [ $cmd_status -ne 0 ]; then
    dunst_notify "NixOS rebuild boot failed!" "normal" 5000 "$NOTIFY_BASE_ID"
    exit 1
fi
NOTIFY_BASE_ID=$((NOTIFY_BASE_ID + NOTIFY_INCREMENT))
# Garbage collection: nix-collect-garbage
dunst_notify "Removing old generations of profile..." "normal" 5000 "$NOTIFY_BASE_ID"
NOTIFY_BASE_ID=$((NOTIFY_BASE_ID + NOTIFY_INCREMENT))
nix-collect-garbage > "$temp_file" 2>&1
cmd_status=$?
process_output "$(cat "$temp_file")" "$NOTIFY_BASE_ID"
if [ $cmd_status -ne 0 ]; then
    dunst_notify "nix-collect-garbage failed!" "normal" 5000 "$NOTIFY_BASE_ID"
    exit 1
fi
NOTIFY_BASE_ID=$((NOTIFY_BASE_ID + NOTIFY_INCREMENT))
# Garbage collection: nix-collect-garbage -d
dunst_notify "Finding garbage collector roots and deleting garbage..." "normal" 5000 "$NOTIFY_BASE_ID"
NOTIFY_BASE_ID=$((NOTIFY_BASE_ID + NOTIFY_INCREMENT))
nix-collect-garbage -d > "$temp_file" 2>&1
cmd_status=$?
process_output "$(cat "$temp_file")" "$NOTIFY_BASE_ID"
if [ $cmd_status -ne 0 ]; then
    dunst_notify "nix-collect-garbage -d failed!" "normal" 5000 "$NOTIFY_BASE_ID"
    exit 1
fi
NOTIFY_BASE_ID=$((NOTIFY_BASE_ID + NOTIFY_INCREMENT))
# Optimizing: nix-store --optimise
dunst_notify "Optimizing nix store and deleting unused links..." "normal" 5000 "$NOTIFY_BASE_ID"
NOTIFY_BASE_ID=$((NOTIFY_BASE_ID + NOTIFY_INCREMENT))
nix-store --optimise > "$temp_file" 2>&1
cmd_status=$?
process_output "$(cat "$temp_file")" "$NOTIFY_BASE_ID"
if [ $cmd_status -ne 0 ]; then
    dunst_notify "nix-store --optimise failed!" "normal" 5000 "$NOTIFY_BASE_ID"
    exit 1
fi
NOTIFY_BASE_ID=$((NOTIFY_BASE_ID + NOTIFY_INCREMENT))
# Final notification about the completion of the system cleanup
dunst_notify "System cleanup completed!" "normal" 5000 "$NOTIFY_BASE_ID"
