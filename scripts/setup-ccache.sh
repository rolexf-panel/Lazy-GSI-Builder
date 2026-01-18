#!/bin/bash
source "$(dirname "$0")/utils.sh"

print_header "Setting Up ccache"

cd ~/rom

export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
export CCACHE_DIR=~/rom/.ccache

print_info "Configuring ccache with 10GB max size..."
ccache -M 10G
ccache -z

print_success "ccache configured and statistics reset"
