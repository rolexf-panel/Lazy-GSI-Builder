#!/bin/bash
source "$(dirname "$0")/utils.sh"

print_header "Setting Up Treble Environment"

cd ~/rom

# Run Treble generation script if it exists
if [ -f device/phh/treble/generate.sh ]; then
    print_info "Running Treble generation script..."
    bash device/phh/treble/generate.sh
    print_success "Treble generation completed"
else
    print_warning "No Treble generation script found, skipping..."
fi

# Detect ROM type
if [ -d vendor/lineage ]; then
    print_info "LineageOS-based ROM detected"
elif [ -d vendor/aosp ]; then
    print_info "AOSP-based ROM detected"
elif [ -d vendor/evolution ]; then
    print_info "Evolution X ROM detected"
elif [ -d vendor/crDroid ]; then
    print_info "crDroid ROM detected"
else
    print_info "Generic ROM detected"
fi

print_success "Treble environment setup completed"
