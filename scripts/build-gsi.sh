#!/bin/bash
source "$(dirname "$0")/utils.sh"

DEVICE=$1
USE_CCACHE=$2

print_header "Building GSI"
print_info "Target: $DEVICE"
start_timer

cd ~/rom

# Setup environment
export USE_CCACHE=1
export CCACHE_DIR=~/rom/.ccache
export ALLOW_MISSING_DEPENDENCIES=true
export LC_ALL=C

# Source build environment
print_info "Sourcing build environment..."
source build/envsetup.sh

# Lunch target device
print_info "Running lunch for $DEVICE"
lunch $DEVICE

if [ $? -ne 0 ]; then
    print_error "Lunch command failed"
    exit 1
fi

print_success "Build target configured"

# Build with progress monitoring
print_header "Starting Compilation"
print_warning "This will take 1-4 hours depending on system resources"
print_info "CPU cores available: $(nproc)"
print_info "Building with make -j$(nproc)"

# Function to monitor build progress
monitor_build() {
    local log_file="build.log"
    local jobs=$1
    
    # Start build in background
    WITHOUT_CHECK_API=true make -j$jobs systemimage 2>&1 | tee "$log_file" &
    local build_pid=$!
    
    # Monitor progress
    local last_line=""
    local ninja_started=false
    
    while kill -0 $build_pid 2>/dev/null; do
        if [ -f "$log_file" ]; then
            # Try to find ninja progress
            local ninja_line=$(tail -1 "$log_file" 2>/dev/null | grep -oP '\[\s*\d+/\s*\d+\]' | tail -1)
            
            if [ ! -z "$ninja_line" ]; then
                ninja_started=true
                # Extract current and total from [current/total]
                local current=$(echo "$ninja_line" | grep -oP '\d+' | head -1)
                local total=$(echo "$ninja_line" | grep -oP '\d+' | tail -1)
                
                if [ ! -z "$current" ] && [ ! -z "$total" ] && [ "$total" -gt 0 ]; then
                    local percentage=$((current * 100 / total))
                    local filled=$((50 * current / total))
                    local bar=$(printf '█%.0s' $(seq 1 $filled))
                    local empty=$(printf '░%.0s' $(seq $filled 50))
                    
                    printf "\r${CYAN}[${bar}${empty}] ${percentage}%% ${NC}($current/$total) Building..."
                fi
            elif [ "$ninja_started" = false ]; then
                # Before ninja starts, show a spinner
                local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
                local i=$(( $(date +%s) % 10 ))
                printf "\r${CYAN}${spin:$i:1}${NC} Preparing build environment..."
            fi
        fi
        sleep 1
    done
    
    # Wait for build to complete and get exit code
    wait $build_pid
    local exit_code=$?
    
    echo ""
    return $exit_code
}

# Try building with different job counts on failure
if ! monitor_build $(nproc); then
    print_warning "Build failed with $(nproc) jobs, retrying with 4 jobs..."
    if ! monitor_build 4; then
        print_warning "Build failed with 4 jobs, final attempt with 2 jobs..."
        if ! monitor_build 2; then
            print_error "Build failed after 3 attempts"
            exit 1
        fi
    fi
fi

# Check if build succeeded
if [ ! -f out/target/product/*/system.img ]; then
    print_error "Build failed - system.img not found"
    exit 1
fi

BUILD_TIME=$(end_timer)
print_success "Build completed successfully in $BUILD_TIME!"

# Show build output
print_info "Build output:"
ls -lh out/target/product/*/system.img
