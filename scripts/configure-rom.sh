#!/bin/bash
source "$(dirname "$0")/utils.sh"

ROM_TYPE=$1
CUSTOM_URL=$2

print_header "Configuring ROM Source"

case "$ROM_TYPE" in
    "LineageOS") 
        MANIFEST="https://github.com/LineageOS/android.git" 
        ;;
    "crDroid") 
        MANIFEST="https://github.com/crdroidandroid/android.git" 
        ;;
    "DerpFest") 
        MANIFEST="https://github.com/DerpFest-AOSP/manifest.git" 
        ;;
    "Evolution X") 
        MANIFEST="https://github.com/Evolution-X/manifest.git" 
        ;;
    "PixelOS") 
        MANIFEST="https://github.com/PixelOS-AOSP/manifest.git" 
        ;;
    "ArrowOS") 
        MANIFEST="https://github.com/ArrowOS/android_manifest.git" 
        ;;
    "RisingOS") 
        MANIFEST="https://github.com/RisingTechOSS/android.git" 
        ;;
    "Project Elixir") 
        MANIFEST="https://github.com/Project-Elixir/manifest.git" 
        ;;
    "Corvus OS") 
        MANIFEST="https://github.com/Corvus-AOSP/android_manifest.git" 
        ;;
    "Cherish OS") 
        MANIFEST="https://github.com/CherishOS/android_manifest.git" 
        ;;
    "Awaken OS") 
        MANIFEST="https://github.com/Project-Awaken/android_manifest.git" 
        ;;
    "PixelExperience") 
        MANIFEST="https://github.com/PixelExperience/manifest.git" 
        ;;
    "Havoc OS") 
        MANIFEST="https://github.com/Havoc-OS/android_manifest.git" 
        ;;
    "AOSP") 
        MANIFEST="https://android.googlesource.com/platform/manifest" 
        ;;
    "Custom (Input URL manually)") 
        MANIFEST="$CUSTOM_URL"
        if [ -z "$MANIFEST" ]; then
            print_error "Custom manifest URL is required when 'Custom' is selected"
            exit 1
        fi
        ;;
    *)
        print_error "Unknown ROM type: $ROM_TYPE"
        exit 1
        ;;
esac

echo "MANIFEST_URL=$MANIFEST" >> $GITHUB_ENV
print_success "ROM Type: $ROM_TYPE"
print_success "Manifest URL: $MANIFEST"
