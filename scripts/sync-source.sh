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

# Remove problematic manifest files that cause remote conflicts
print_info "Cleaning up conflicting manifest files..."
rm -f .repo/local_manifests/replace.xml
rm -f .repo/local_manifests/remove.xml
rm -f .repo/local_manifests/lineage_replace.xml

# Fix remote conflicts by editing manifests
if [ -f .repo/local_manifests/manifest.xml ]; then
    # Remove any conflicting 'github' remote definitions
    sed -i '/<remote.*name="github"/d' .repo/local_manifests/manifest.xml 2>/dev/null || true
fi

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
    
    # Use additional flags to handle conflicts
    repo sync -c -j$jobs \
        --force-sync \
        --force-remove-dirty \
        --no-tags \
        --no-clone-bundle \
        --optimized-fetch \
        --prune 2>&1 | \
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
    print_warning "First sync attempt failed, checking for remote conflicts..."
    
    # Try to fix remote conflicts manually
    print_info "Attempting to resolve remote conflicts..."
    cd .repo/manifests
    git config --unset-all remote.github.url 2>/dev/null || true
    git config --unset-all remote.github.fetch 2>/dev/null || true
    cd ~/rom
    
    # Reinitialize repo to fix remotes
    print_info "Reinitializing repo configuration..."
    repo init -u $MANIFEST_URL -b $BRANCH --depth=1 || true
    
    if ! sync_with_progress 2 4; then
        print_warning "Second sync attempt failed, trying deep cleanup..."
        
        # More aggressive cleanup
        find .repo/projects -name "*.git/config" -exec sed -i '/\[remote "github"\]/,+2d' {} \; 2>/dev/null || true
        
        if ! sync_with_progress 3 2; then
            print_error "Repo sync failed after 3 attempts"
            print_info "Showing detailed error information..."
            repo sync -j1 --force-sync --force-remove-dirty
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
