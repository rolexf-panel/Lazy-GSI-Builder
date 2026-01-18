#!/bin/bash
source "$(dirname "$0")/utils.sh"

# Telegram notification script
# Usage: ./telegram-notify.sh <status> <rom_type> <branch> <device> [error_log]

STATUS=$1           # "success" or "failure"
ROM_TYPE=$2
BRANCH=$3
DEVICE=$4
ERROR_LOG=$5        # Optional: path to error log file

# Check if Telegram is configured
if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
    print_warning "Telegram notification not configured (skipping)"
    print_info "To enable: Set TELEGRAM_BOT_TOKEN and TELEGRAM_CHAT_ID secrets"
    exit 0
fi

# Validate Telegram configuration
if [ "$TELEGRAM_CHAT_ID" = "YOUR_CHAT_ID_HERE" ] || [ "$TELEGRAM_BOT_TOKEN" = "YOUR_BOT_TOKEN_HERE" ]; then
    print_warning "Telegram secrets not properly configured (using placeholder values)"
    exit 0
fi

print_header "Sending Telegram Notification"

# Telegram API URL
API_URL="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}"

# Function to send message with retry
send_telegram_message() {
    local message=$1
    local parse_mode=${2:-"HTML"}
    local retry_count=0
    local max_retries=3
    
    while [ $retry_count -lt $max_retries ]; do
        response=$(curl -s -X POST "${API_URL}/sendMessage" \
            -H "Content-Type: application/json" \
            -d "{
                \"chat_id\": \"${TELEGRAM_CHAT_ID}\",
                \"text\": \"${message}\",
                \"parse_mode\": \"${parse_mode}\",
                \"disable_web_page_preview\": true
            }" 2>&1)
        
        # Check if request was successful
        if echo "$response" | grep -q '"ok":true'; then
            print_success "Telegram notification sent successfully"
            return 0
        else
            retry_count=$((retry_count + 1))
            if [ $retry_count -lt $max_retries ]; then
                print_warning "Failed to send notification, retrying... ($retry_count/$max_retries)"
                sleep 2
            else
                print_error "Failed to send Telegram notification after $max_retries attempts"
                print_info "Response: $response"
                return 1
            fi
        fi
    done
}

# Function to send document (error log)
send_telegram_document() {
    local file_path=$1
    local caption=$2
    
    if [ ! -f "$file_path" ]; then
        print_warning "Error log file not found: $file_path"
        return 1
    fi
    
    # Check file size (Telegram limit: 50MB)
    local file_size=$(stat -f%z "$file_path" 2>/dev/null || stat -c%s "$file_path" 2>/dev/null || echo "0")
    local max_size=$((50 * 1024 * 1024)) # 50MB in bytes
    
    if [ "$file_size" -gt "$max_size" ]; then
        print_warning "Error log too large ($(($file_size / 1024 / 1024))MB), sending truncated version"
        # Send last 5000 lines
        tail -5000 "$file_path" > /tmp/error_log_truncated.txt
        file_path="/tmp/error_log_truncated.txt"
        caption="$caption (truncated - last 5000 lines)"
    fi
    
    print_info "Sending error log file..."
    
    response=$(curl -s -X POST "${API_URL}/sendDocument" \
        -F "chat_id=${TELEGRAM_CHAT_ID}" \
        -F "document=@${file_path}" \
        -F "caption=${caption}" 2>&1)
    
    if echo "$response" | grep -q '"ok":true'; then
        print_success "Error log sent successfully"
        return 0
    else
        print_warning "Failed to send error log"
        return 1
    fi
}

# Escape special characters for Telegram HTML
escape_html() {
    local text="$1"
    # Escape HTML special characters
    text="${text//&/&amp;}"
    text="${text//</&lt;}"
    text="${text//>/&gt;}"
    # Remove potential problematic characters
    text="${text//\"/&quot;}"
    echo "$text"
}

# Get workflow information
WORKFLOW_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}"
COMMIT_SHA_SHORT="${GITHUB_SHA:0:7}"
ACTOR=$(escape_html "$GITHUB_ACTOR")
ROM_TYPE_ESC=$(escape_html "$ROM_TYPE")
BRANCH_ESC=$(escape_html "$BRANCH")
DEVICE_ESC=$(escape_html "$DEVICE")

# Build time calculation
if [ -f "/tmp/build_start_time" ]; then
    START_TIME=$(cat /tmp/build_start_time)
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    
    hours=$((DURATION / 3600))
    minutes=$(((DURATION % 3600) / 60))
    seconds=$((DURATION % 60))
    
    if [ $hours -gt 0 ]; then
        BUILD_TIME="${hours}h ${minutes}m ${seconds}s"
    elif [ $minutes -gt 0 ]; then
        BUILD_TIME="${minutes}m ${seconds}s"
    else
        BUILD_TIME="${seconds}s"
    fi
else
    BUILD_TIME="N/A"
fi

# Create notification message based on status
if [ "$STATUS" = "success" ]; then
    # Success notification
    ICON="✅"
    TITLE="<b>Build Completed Successfully!</b>"
    
    MESSAGE="$ICON $TITLE

<b>📱 ROM:</b> $ROM_TYPE_ESC
<b>🔖 Branch:</b> $BRANCH_ESC
<b>📦 Device:</b> $DEVICE_ESC
<b>⏱️ Build Time:</b> $BUILD_TIME
<b>👤 Triggered by:</b> $ACTOR
<b>🔧 Commit:</b> <code>$COMMIT_SHA_SHORT</code>

<b>📥 Download:</b>
Your GSI is ready! Download it from the workflow artifacts.

<a href=\"$WORKFLOW_URL\">🔗 View Workflow Details</a>

<i>🎉 Flash and enjoy your new GSI!</i>"

else
    # Failure notification
    ICON="❌"
    TITLE="<b>Build Failed</b>"
    
    # Extract error information if available
    ERROR_DETAILS=""
    if [ -f "$ERROR_LOG" ]; then
        # Get last few lines of error log
        LAST_ERRORS=$(tail -20 "$ERROR_LOG" | grep -i "error\|fail\|fatal" | head -5 | sed 's/^/  /')
        if [ -n "$LAST_ERRORS" ]; then
            ERROR_DETAILS="

<b>🔍 Recent Errors:</b>
<pre>$(escape_html "$LAST_ERRORS")</pre>"
        fi
    fi
    
    MESSAGE="$ICON $TITLE

<b>📱 ROM:</b> $ROM_TYPE_ESC
<b>🔖 Branch:</b> $BRANCH_ESC
<b>📦 Device:</b> $DEVICE_ESC
<b>⏱️ Failed After:</b> $BUILD_TIME
<b>👤 Triggered by:</b> $ACTOR
<b>🔧 Commit:</b> <code>$COMMIT_SHA_SHORT</code>
$ERROR_DETAILS

<b>📋 Next Steps:</b>
1. Check the error logs in workflow artifacts
2. Review the build configuration
3. See TROUBLESHOOTING.md for common issues

<a href=\"$WORKFLOW_URL\">🔗 View Workflow Details</a>

<i>💡 Tip: Most errors are due to branch mismatches or dependencies</i>"
fi

# Send main notification
if ! send_telegram_message "$MESSAGE"; then
    print_error "Failed to send Telegram notification"
    exit 1
fi

# Send error log as document if build failed and log exists
if [ "$STATUS" = "failure" ] && [ -n "$ERROR_LOG" ] && [ -f "$ERROR_LOG" ]; then
    print_info "Attempting to send error log file..."
    send_telegram_document "$ERROR_LOG" "Build Error Log - $ROM_TYPE_ESC ($BRANCH_ESC)"
fi

print_success "Telegram notification completed"
