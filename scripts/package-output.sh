#!/bin/bash
source "$(dirname "$0")/utils.sh"

ROM_TYPE=$1
BRANCH=$2
DEVICE=$3
TREBLE_BRANCH=$4

print_header "Compressing and Packaging Output"
start_timer

cd ~/rom

# Compress system image
print_info "Compressing system image with xz..."
find out/target/product -name "system.img" -exec xz -9 -T0 -v -z {} \; &
XZ_PID=$!

# Show compression progress
while kill -0 $XZ_PID 2>/dev/null; do
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=$(( $(date +%s) % 10 ))
    printf "\r${CYAN}${spin:$i:1}${NC} Compressing system image..."
    sleep 1
done
wait $XZ_PID

echo ""
print_success "Compression completed"

# Show compressed file size
COMPRESSED_SIZE=$(find out/target/product -name "system.img.xz" -exec ls -lh {} \; | awk '{print $5}')
print_info "Compressed file size: $COMPRESSED_SIZE"

# Generate build info
print_info "Generating build information..."

cat > out/target/product/*/build-info.txt << EOF
╔═══════════════════════════════════════════════════════════╗
║           GSI Build Information                           ║
╚═══════════════════════════════════════════════════════════╝

Build Details:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ROM:                $ROM_TYPE
  Branch:             $BRANCH
  Android Version:    $TREBLE_BRANCH
  Lunch Variant:      $DEVICE
  Build Date:         $(date -u '+%Y-%m-%d %H:%M:%S UTC')
  Builder:            GitHub Actions
  Compressed Size:    $COMPRESSED_SIZE

Source Information:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Manifest URL:       $MANIFEST_URL
  Treble Manifest:    https://github.com/TrebleDroid/treble_manifest

Installation Instructions:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  1. Extract the compressed image:
     xz -d system.img.xz

  2. Boot your device into fastboot mode:
     adb reboot bootloader

  3. Flash the system image:
     fastboot flash system system.img

  4. (Recommended) Wipe data if coming from a different ROM:
     fastboot -w

  5. Reboot your device:
     fastboot reboot

Important Notes:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  • Ensure your device supports Project Treble
  • Bootloader must be unlocked
  • Back up your data before flashing
  • Some ROMs may require additional steps

Credits:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  • phhusson - Project Treble pioneer
  • TrebleDroid - Treble manifest maintenance
  • $ROM_TYPE developers - Original ROM
  • GitHub Actions - Build infrastructure

╔═══════════════════════════════════════════════════════════╗
║  For support, visit the $ROM_TYPE community forums       ║
╚═══════════════════════════════════════════════════════════╝
EOF

print_success "Build info generated"

PACKAGE_TIME=$(end_timer)
print_success "Packaging completed in $PACKAGE_TIME"
