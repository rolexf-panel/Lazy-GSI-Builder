#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print colored message
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Print section header
print_header() {
    local message=$1
    echo ""
    print_message "$CYAN" "═══════════════════════════════════════════════════════════"
    print_message "$CYAN" "  $message"
    print_message "$CYAN" "═══════════════════════════════════════════════════════════"
    echo ""
}

# Print success message
print_success() {
    print_message "$GREEN" "✓ $1"
}

# Print error message
print_error() {
    print_message "$RED" "✗ $1"
}

# Print warning message
print_warning() {
    print_message "$YELLOW" "⚠ $1"
}

# Print info message
print_info() {
    print_message "$BLUE" "ℹ $1"
}

# Progress bar function
show_progress() {
    local current=$1
    local total=$2
    local message=$3
    local width=50
    
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))
    
    # Create the bar
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done
    
    # Print the progress bar
    printf "\r${CYAN}[${bar}] ${percentage}%% ${NC}- ${message}"
    
    # New line when complete
    if [ "$current" -eq "$total" ]; then
        echo ""
    fi
}

# Spinner function for long-running tasks
spinner() {
    local pid=$1
    local message=$2
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %10 ))
        printf "\r${CYAN}${spin:$i:1}${NC} ${message}"
        sleep 0.1
    done
    printf "\r"
}

# Timer function
start_timer() {
    TIMER_START=$(date +%s)
}

end_timer() {
    local start=$TIMER_START
    local end=$(date +%s)
    local duration=$((end - start))
    
    local hours=$((duration / 3600))
    local minutes=$(((duration % 3600) / 60))
    local seconds=$((duration % 60))
    
    if [ $hours -gt 0 ]; then
        echo "${hours}h ${minutes}m ${seconds}s"
    elif [ $minutes -gt 0 ]; then
        echo "${minutes}m ${seconds}s"
    else
        echo "${seconds}s"
    fi
}

# Check disk space
check_disk_space() {
    local required_gb=$1
    local available_gb=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
    
    if [ "$available_gb" -lt "$required_gb" ]; then
        print_error "Insufficient disk space. Required: ${required_gb}GB, Available: ${available_gb}GB"
        return 1
    else
        print_success "Disk space check passed. Available: ${available_gb}GB"
        return 0
    fi
}

# Retry function with exponential backoff
retry_command() {
    local max_attempts=$1
    shift
    local command="$@"
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        print_info "Attempt $attempt of $max_attempts: $command"
        
        if eval "$command"; then
            print_success "Command succeeded on attempt $attempt"
            return 0
        else
            if [ $attempt -lt $max_attempts ]; then
                local wait_time=$((2 ** attempt))
                print_warning "Command failed. Waiting ${wait_time}s before retry..."
                sleep $wait_time
            fi
        fi
        
        attempt=$((attempt + 1))
    done
    
    print_error "Command failed after $max_attempts attempts"
    return 1
}

# Show system info
show_system_info() {
    print_header "System Information"
    
    echo "CPU Cores: $(nproc)"
    echo "Total RAM: $(free -h | awk '/^Mem:/ {print $2}')"
    echo "Available RAM: $(free -h | awk '/^Mem:/ {print $7}')"
    echo "Disk Space: $(df -h . | tail -1 | awk '{print $4}') available"
    echo "Kernel: $(uname -r)"
    echo "OS: $(lsb_release -d | cut -f2-)"
    echo ""
}

# Export all functions
export -f print_message
export -f print_header
export -f print_success
export -f print_error
export -f print_warning
export -f print_info
export -f show_progress
export -f spinner
export -f start_timer
export -f end_timer
export -f check_disk_space
export -f retry_command
export -f show_system_info
