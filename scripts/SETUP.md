# Repository Setup Guide

This guide will help you set up the Universal GSI Builder in your GitHub repository.

## Quick Setup

### Option 1: Using GitHub Web Interface

1. **Create the repository structure:**
   - Fork or create a new repository
   - Create a folder named `.github/workflows/`
   - Create a folder named `scripts/`

2. **Add the workflow file:**
   - In `.github/workflows/`, create a file named `build.yml`
   - Copy the content from the `build.yml` artifact

3. **Add all script files:**
   In the `scripts/` folder, create these files:
   - `utils.sh`
   - `setup-environment.sh`
   - `set-java-version.sh`
   - `configure-rom.sh`
   - `sync-source.sh`
   - `setup-treble.sh`
   - `setup-ccache.sh`
   - `build-gsi.sh`
   - `package-output.sh`
   - `build-summary.sh`

   Copy the respective content into each file.

4. **Add README.md** (optional but recommended)
   - Create `README.md` in the root
   - Copy the content from the README artifact

5. **Setup Telegram Notifications** (optional but recommended)
   - See [TELEGRAM_SETUP.md](TELEGRAM_SETUP.md) for detailed instructions
   - Quick steps:
     1. Create bot via @BotFather
     2. Get Chat ID via @myidbot
     3. Add secrets to GitHub:
        - `TELEGRAM_BOT_TOKEN`
        - `TELEGRAM_CHAT_ID`
     4. Send `/start` to your bot
   - If you skip this, notifications will be automatically disabled (no errors)

### Option 2: Using Git Command Line

```bash
# Clone your repository
git clone https://github.com/YOUR_USERNAME/YOUR_REPO.git
cd YOUR_REPO

# Create directory structure
mkdir -p .github/workflows scripts

# Create workflow file
cat > .github/workflows/build.yml << 'EOF'
# Paste build.yml content here
EOF

# Create script files
cat > scripts/utils.sh << 'EOF'
# Paste utils.sh content here
EOF

# Repeat for all other scripts...

# Add execute permissions (GitHub Actions will also do this)
chmod +x scripts/*.sh

# Commit and push
git add .
git commit -m "Add Universal GSI Builder"
git push
```

## Verification

After setup, your repository should have this structure:

```
your-repo/
├── .github/
│   └── workflows/
│       └── build.yml
├── scripts/
│   ├── utils.sh
│   ├── setup-environment.sh
│   ├── set-java-version.sh
│   ├── configure-rom.sh
│   ├── sync-source.sh
│   ├── setup-treble.sh
│   ├── setup-ccache.sh
│   ├── build-gsi.sh
│   ├── package-output.sh
│   ├── build-summary.sh
│   └── telegram-notify.sh
└── README.md (optional)
```

## Testing the Setup

1. Go to your repository on GitHub
2. Click on the "Actions" tab
3. You should see "Universal Treble GSI Builder" in the workflows list
4. Click "Run workflow" to test
5. Select a simple configuration (like LineageOS with default settings)
6. Monitor the build process

## Troubleshooting

### "Permission denied" errors
- GitHub Actions automatically handles script permissions
- The workflow includes a step to `chmod +x scripts/*.sh`
- This should not normally be an issue

### Scripts not found
- Verify all scripts are in the `scripts/` directory
- Check that file names match exactly (case-sensitive)
- Ensure the directory structure is correct

### Workflow doesn't appear
- Make sure `build.yml` is in `.github/workflows/`
- Check the YAML syntax is valid
- Try pushing an empty commit: `git commit --allow-empty -m "Trigger workflow"`

## Customization

### Modifying Build Parameters

You can customize the scripts to fit your needs:

**Change default branches:**
Edit `build.yml` and modify the `default:` values

**Add more ROMs:**
Edit `scripts/configure-rom.sh` and add more cases to the switch statement

**Adjust progress display:**
Modify `scripts/utils.sh` to change how progress bars look

**Change build parallelization:**
Edit `scripts/build-gsi.sh` to modify the `-j` values

### Advanced Customization

**Add custom build flags:**
Edit `scripts/build-gsi.sh` and add export statements before the make command

**Change compression:**
Edit `scripts/package-output.sh` to use different compression (e.g., `gzip` instead of `xz`)

**Modify disk cleanup:**
Edit `scripts/setup-environment.sh` to add or remove cleanup steps

## Support

If you encounter issues:

1. Check the error logs artifact from failed builds
2. Verify your configuration matches a working example in README.md
3. Ensure the ROM branch and Treble branch are compatible
4. Check that the ROM repository is accessible
5. Open an issue with:
   - Your configuration (ROM, branch, etc.)
   - Error logs
   - Steps to reproduce

## Next Steps

After successful setup:

1. Read the full README.md for usage instructions
2. Try building a simple ROM first (LineageOS is recommended)
3. Experiment with different ROMs and configurations
4. Check the build summary for optimization tips

Happy building! 🚀
