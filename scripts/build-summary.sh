#!/bin/bash
source "$(dirname "$0")/utils.sh"

ROM_TYPE=$1
BRANCH=$2
TREBLE_BRANCH=$3
DEVICE=$4
USE_CCACHE=$5
CLEAN_BUILD=$6

cd ~/rom

# Generate GitHub Step Summary
echo "## 🏗️ Build Summary" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY

# Build configuration table
echo "### Configuration" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY
echo "| Parameter | Value |" >> $GITHUB_STEP_SUMMARY
echo "|-----------|-------|" >> $GITHUB_STEP_SUMMARY
echo "| ROM | $ROM_TYPE |" >> $GITHUB_STEP_SUMMARY
echo "| Branch | \`$BRANCH\` |" >> $GITHUB_STEP_SUMMARY
echo "| Android Version | \`$TREBLE_BRANCH\` |" >> $GITHUB_STEP_SUMMARY
echo "| Lunch Variant | \`$DEVICE\` |" >> $GITHUB_STEP_SUMMARY
echo "| ccache Enabled | $USE_CCACHE |" >> $GITHUB_STEP_SUMMARY
echo "| Clean Build | $CLEAN_BUILD |" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY

# Check build status
if [ -f out/target/product/*/system.img.xz ]; then
    SIZE=$(ls -lh out/target/product/*/system.img.xz | awk '{print $5}')
    
    echo "### ✅ Build Successful!" >> $GITHUB_STEP_SUMMARY
    echo "" >> $GITHUB_STEP_SUMMARY
    echo "**Compressed Size:** \`$SIZE\`" >> $GITHUB_STEP_SUMMARY
    echo "" >> $GITHUB_STEP_SUMMARY
    
    echo "#### 📦 Artifact Information" >> $GITHUB_STEP_SUMMARY
    echo "- **File:** \`system.img.xz\`" >> $GITHUB_STEP_SUMMARY
    echo "- **Build Info:** Included in artifact" >> $GITHUB_STEP_SUMMARY
    echo "- **Retention:** 14 days" >> $GITHUB_STEP_SUMMARY
    echo "" >> $GITHUB_STEP_SUMMARY
    
    echo "#### 🚀 Next Steps" >> $GITHUB_STEP_SUMMARY
    echo "1. Download the artifact from the bottom of this page" >> $GITHUB_STEP_SUMMARY
    echo "2. Extract the zip file" >> $GITHUB_STEP_SUMMARY
    echo "3. Decompress: \`xz -d system.img.xz\`" >> $GITHUB_STEP_SUMMARY
    echo "4. Flash: \`fastboot flash system system.img\`" >> $GITHUB_STEP_SUMMARY
    
    print_success "Build completed successfully!"
    print_info "Compressed size: $SIZE"
else
    echo "### ❌ Build Failed" >> $GITHUB_STEP_SUMMARY
    echo "" >> $GITHUB_STEP_SUMMARY
    echo "The build process encountered errors. Please check the error logs artifact for details." >> $GITHUB_STEP_SUMMARY
    echo "" >> $GITHUB_STEP_SUMMARY
    echo "#### 🔍 Troubleshooting" >> $GITHUB_STEP_SUMMARY
    echo "- Check that the ROM branch \`$BRANCH\` exists" >> $GITHUB_STEP_SUMMARY
    echo "- Verify the Treble branch \`$TREBLE_BRANCH\` is compatible" >> $GITHUB_STEP_SUMMARY
    echo "- Review the error logs artifact for specific errors" >> $GITHUB_STEP_SUMMARY
    echo "- Ensure the lunch variant \`$DEVICE\` is valid" >> $GITHUB_STEP_SUMMARY
    
    print_error "Build failed - check error logs"
fi

# System resource usage
echo "" >> $GITHUB_STEP_SUMMARY
echo "### 📊 Resource Usage" >> $GITHUB_STEP_SUMMARY
echo "" >> $GITHUB_STEP_SUMMARY
echo "| Resource | Usage |" >> $GITHUB_STEP_SUMMARY
echo "|----------|-------|" >> $GITHUB_STEP_SUMMARY
echo "| CPU Cores | $(nproc) |" >> $GITHUB_STEP_SUMMARY
echo "| Disk Used | $(df -h . | tail -1 | awk '{print $3}') / $(df -h . | tail -1 | awk '{print $2}') |" >> $GITHUB_STEP_SUMMARY
echo "| Disk Free | $(df -h . | tail -1 | awk '{print $4}') |" >> $GITHUB_STEP_SUMMARY

if [ "$USE_CCACHE" = "true" ]; then
    echo "" >> $GITHUB_STEP_SUMMARY
    echo "### 💾 ccache Statistics" >> $GITHUB_STEP_SUMMARY
    echo "" >> $GITHUB_STEP_SUMMARY
    echo "\`\`\`" >> $GITHUB_STEP_SUMMARY
    ccache -s >> $GITHUB_STEP_SUMMARY
    echo "\`\`\`" >> $GITHUB_STEP_SUMMARY
fi
