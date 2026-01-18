#!/bin/bash
source "$(dirname "$0")/utils.sh"

BRANCH=$1
TREBLE_BRANCH=$2

print_header "Initializing Repository"
start_timer

mkdir -p ~/rom && cd ~/rom

# Initialize repo with retry
print_info "Initializing repo with manifest: $MANIFEST_URL"
print_info "Branch: $BRANCH"

if ! retry_command 3 "repo init -u $MANIFEST_URL -b $BRANCH --depth=1"; then
    print_error "Failed to initialize repo after 3 attempts"
    exit 1
fi

print_success "Repo initialized successfully"

# Clone Treble manifests
print_info "Cloning TrebleDroid manifests for $TREBLE_BRANCH"
git clone https://github.com/TrebleDroid/treble_manifest .repo/local_manifests -b $TREBLE_BRANCH

# Remove replace.xml if it exists
rm -f .repo/local_manifests/replace.xml
print_success "Treble manifests configured"

# Show manifest configuration
print_info "Local manifests:"
ls -la .repo/local_manifests/

INIT_TIME=$(end_timer)
print_success "Repository initialization completed in $INIT_TIME"

# Repo sync with progress
print_header "Syncing Source Code"
print_warning "This may take 30-90 minutes depending on ROM size and network speed"
start_timer

# Function to parse repo sync output and show progress
sync_with_progress() {
    local attempt=$1
    local jobs=$2
    
    print_info "Sync attempt $attempt with $jobs parallel jobs"
    
    repo sync -c -j$jobs --force-sync --no-tags --no-clone-bundle --optimized-fetch --prune 2>&1 | \
    while IFS= read -r line; do
        # Try to extract project count from repo sync output
        if [[ $line =~ Fetching\ projects:\ ([0-9]+)% ]]; then
            percentage="${BASH_REMATCH[1]}"
            printf "\r${CYAN}[%-50s] ${percentage}%% ${NC}- Syncing repositories" \
                "$(printf '█%.0s' $(seq 1 $((percentage / 2))))"
        elif [[ $line =~ Checking\ out\ files:\ ([0-9]+)% ]]; then
            percentage="${BASH_REMATCH[1]}"
            printf "\r${CYAN}[%-50s] ${percentage}%% ${NC}- Checking out files" \
                "$(printf '█%.0s' $(seq 1 $((percentage / 2))))"
        else
            # Show some activity
            echo "$line"
        fi
    done
    
    return ${PIPESTATUS[0]}
}

# Try syncing with different job counts
if ! sync_with_progress 1 $(nproc); then
    print_warning "First sync attempt failed, retrying with fewer jobs..."
    if ! sync_with_progress 2 4; then
        print_warning "Second sync attempt failed, final retry with minimal jobs..."
        if ! sync_with_progress 3 2; then
            print_error "Repo sync failed after 3 attempts"
            exit 1
        fi
    fi
fi

echo ""
SYNC_TIME=$(end_timer)
print_success "Source code sync completed in $SYNC_TIME"

# Show disk usage
print_info "Disk usage after sync:"
df -h | grep -E '^/dev/'
