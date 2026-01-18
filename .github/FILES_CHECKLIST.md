# Files Checklist

Use this checklist to ensure you have all the required files in your repository.

## Required Files ✅

### Workflow File
- [ ] `.github/workflows/build.yml` - Main GitHub Actions workflow

### Script Files (all in `scripts/` directory)
- [ ] `scripts/utils.sh` - Utility functions and progress bars
- [ ] `scripts/setup-environment.sh` - Environment setup
- [ ] `scripts/set-java-version.sh` - Java configuration
- [ ] `scripts/configure-rom.sh` - ROM source configuration
- [ ] `scripts/sync-source.sh` - Repository synchronization
- [ ] `scripts/setup-treble.sh` - Treble environment setup
- [ ] `scripts/setup-ccache.sh` - ccache configuration
- [ ] `scripts/build-gsi.sh` - Main build script
- [ ] `scripts/package-output.sh` - Output packaging
- [ ] `scripts/build-summary.sh` - Build summary generation
- [ ] `scripts/telegram-notify.sh` - Telegram notifications (optional but recommended)

### Documentation (Optional but Recommended)
- [ ] `README.md` - Main documentation
- [ ] `SETUP.md` - Setup guide (optional)
- [ ] `TELEGRAM_SETUP.md` - Telegram notification setup (optional)
- [ ] `TROUBLESHOOTING.md` - Common issues and solutions (optional)
- [ ] `FILES_CHECKLIST.md` - This file (optional)

## Quick Verification

### Directory Structure Check
```bash
# Run this in your repository root
tree -L 3 -a

# Expected output:
# .
# ├── .github
# │   └── workflows
# │       └── build.yml
# ├── scripts
# │   ├── build-gsi.sh
# │   ├── build-summary.sh
# │   ├── configure-rom.sh
# │   ├── package-output.sh
# │   ├── set-java-version.sh
# │   ├── setup-ccache.sh
# │   ├── setup-environment.sh
# │   ├── setup-treble.sh
# │   ├── sync-source.sh
# │   └── utils.sh
# └── README.md
```

### File Count Check
```bash
# Should show 1 workflow file
find .github/workflows -name "*.yml" | wc -l

# Should show 11 script files (10 required + 1 optional telegram-notify.sh)
find scripts -name "*.sh" | wc -l
```

### Script Permissions Check
```bash
# Make all scripts executable
chmod +x scripts/*.sh

# Verify
ls -la scripts/
```

## File Sizes Reference

Approximate file sizes for reference:

| File | Approximate Lines | Size |
|------|-------------------|------|
| `build.yml` | ~100 lines | ~3 KB |
| `utils.sh` | ~150 lines | ~4 KB |
| `setup-environment.sh` | ~80 lines | ~3 KB |
| `set-java-version.sh` | ~40 lines | ~1 KB |
| `configure-rom.sh` | ~60 lines | ~2 KB |
| `sync-source.sh` | ~90 lines | ~3 KB |
| `setup-treble.sh` | ~35 lines | ~1 KB |
| `setup-ccache.sh` | ~20 lines | ~0.5 KB |
| `build-gsi.sh` | ~120 lines | ~4 KB |
| `package-output.sh` | ~90 lines | ~3 KB |
| `build-summary.sh` | ~80 lines | ~3 KB |
| `telegram-notify.sh` | ~200 lines | ~7 KB |

## Common Issues

### ❌ Workflow not appearing in Actions tab
**Solution:** Ensure `build.yml` is exactly in `.github/workflows/` directory

### ❌ "Script not found" errors
**Solution:** 
- Check all scripts are in `scripts/` directory (not in subdirectories)
- Verify file names match exactly (case-sensitive)
- Ensure no extra file extensions (should be `.sh`, not `.sh.txt`)

### ❌ "Permission denied" when running scripts
**Solution:** 
- The workflow automatically handles this with `chmod +x`
- If running locally, run: `chmod +x scripts/*.sh`

### ❌ Scripts have wrong line endings (Windows)
**Solution:**
```bash
# Convert CRLF to LF for all scripts
dos2unix scripts/*.sh

# Or use sed
sed -i 's/\r$//' scripts/*.sh
```

## Validation Script

Create this script to validate your setup:

```bash
#!/bin/bash
# validate-setup.sh

echo "Validating Universal GSI Builder setup..."
echo ""

ERRORS=0

# Check workflow
if [ ! -f .github/workflows/build.yml ]; then
    echo "❌ Missing: .github/workflows/build.yml"
    ERRORS=$((ERRORS + 1))
else
    echo "✅ Found: .github/workflows/build.yml"
fi

# Check scripts
SCRIPTS=(
    "utils.sh"
    "setup-environment.sh"
    "set-java-version.sh"
    "configure-rom.sh"
    "sync-source.sh"
    "setup-treble.sh"
    "setup-ccache.sh"
    "build-gsi.sh"
    "package-output.sh"
    "build-summary.sh"
    "telegram-notify.sh"
)

for script in "${SCRIPTS[@]}"; do
    if [ ! -f "scripts/$script" ]; then
        echo "❌ Missing: scripts/$script"
        ERRORS=$((ERRORS + 1))
    else
        echo "✅ Found: scripts/$script"
        
        # Check if executable
        if [ ! -x "scripts/$script" ]; then
            echo "   ⚠️  Warning: Not executable (will be fixed by workflow)"
        fi
    fi
done

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "✅ All required files present!"
    echo "Ready to use. Go to Actions tab and run the workflow."
else
    echo "❌ Found $ERRORS missing file(s)"
    echo "Please add the missing files before running the workflow."
    exit 1
fi
```

Save as `validate-setup.sh`, make it executable, and run:
```bash
chmod +x validate-setup.sh
./validate-setup.sh
```

## After Setup

Once all files are in place:

1. ✅ Commit and push to GitHub
2. ✅ Go to the Actions tab
3. ✅ Find "Universal Treble GSI Builder"
4. ✅ Click "Run workflow"
5. ✅ Fill in the parameters
6. ✅ Watch the build with progress bars!

## Need Help?

If you're still having issues:

1. Compare your structure with the checklist above
2. Run the validation script
3. Check the SETUP.md guide
4. Review error messages in failed workflow runs
5. Open an issue with your error logs

---

**Last Updated:** Match this with your repository version
