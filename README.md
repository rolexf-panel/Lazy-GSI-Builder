# Universal GSI Builder 🤖

Automated GitHub Actions workflow to build Treble GSIs for multiple ROMs across Android 10-16. No code editing required—just select, run, and build.

## Supported ROMs 📱

This workflow supports the following ROMs via a simple dropdown menu:

- **LineageOS** 🧬 (Android 10-16)
- **crDroid** 🤖 (Android 10-16)
- **DerpFest** 🍤 (Android 11-16)
- **Evolution X** 🔥 (Android 10-16)
- **PixelOS** 📱 (Android 12-16)
- **ArrowOS** 🏹 (Android 11-16)
- **RisingOS** 🌅 (Android 13-16)
- **Project Elixir** ⚗️ (Android 12-16)
- **Corvus OS** 🐦 (Android 11-14)
- **Cherish OS** 💎 (Android 11-14)
- **Awaken OS** 🌄 (Android 12-14)
- **PixelExperience** 📸 (Android 10-14)
- **Havoc OS** 💥 (Android 10-13)
- **AOSP** 🤖 (Android 10-16)
- **Custom** (Any other AOSP-based ROM)

---

## Project Structure 📁

```
.
├── .github/
│   └── workflows/
│       └── build.yml           # Main workflow file
├── scripts/
│   ├── utils.sh                # Utility functions & progress bars
│   ├── setup-environment.sh    # Environment setup
│   ├── set-java-version.sh     # Java version configuration
│   ├── configure-rom.sh        # ROM manifest configuration
│   ├── sync-source.sh          # Repository sync with progress
│   ├── setup-treble.sh         # Treble environment setup
│   ├── setup-ccache.sh         # ccache configuration
│   ├── build-gsi.sh            # Main build script with progress
│   ├── package-output.sh       # Compression & packaging
│   ├── build-summary.sh        # GitHub summary generation
│   └── telegram-notify.sh      # Telegram notifications (optional)
└── README.md                   # This file
```

The workflow is modular - each script handles a specific phase of the build process with visual progress indicators and detailed logging.

### 📜 Script Functions

| Script | Purpose | Key Features |
|--------|---------|--------------|
| `utils.sh` | Common functions | Progress bars, colored output, timers, retry logic |
| `setup-environment.sh` | Install dependencies | Package installation with progress tracking |
| `set-java-version.sh` | Configure Java | Auto-selects Java 8/11/17 based on Android version |
| `configure-rom.sh` | Set ROM source | Validates and configures manifest URL |
| `sync-source.sh` | Download sources | Repo sync with progress display and retry |
| `setup-treble.sh` | Treble setup | Detects ROM type and runs generation scripts |
| `setup-ccache.sh` | Configure cache | Sets up build cache for faster rebuilds |
| `build-gsi.sh` | Main build | Compiles GSI with real-time ninja progress |
| `package-output.sh` | Compress & package | Creates compressed image and build info |
| `build-summary.sh` | Generate report | Creates GitHub Actions summary |
| `telegram-notify.sh` | Send notifications | Sends Telegram alerts on success/failure (optional) |

### ✨ Features

- **📊 Real-time Progress Bars**: Visual progress indicators for all major build phases
- **🎨 Color-Coded Output**: Easy-to-read colored console output
- **⏱️ Time Tracking**: Automatic timing for each build phase
- **🔄 Automatic Retry**: Smart retry logic with exponential backoff
- **💾 Build Caching**: Optional ccache support for faster rebuilds
- **📝 Detailed Logs**: Comprehensive logging with automatic error capture
- **📦 Auto-Packaging**: Automatic compression and build info generation
- **📱 Telegram Notifications**: Get instant notifications on build success/failure (optional)

---

## Quick Start ⚡

1. **Fork** this repository to your account.
2. Go to the **Actions** tab.
3. Select **Universal Treble GSI Builder** and click **Run workflow**.
4. Fill in the options (see the guide below) and click the green button.
5. Wait for the build to finish (usually 1-4 hours) and grab the artifact.

### 📱 Optional: Enable Telegram Notifications

Get instant notifications when your builds complete!

**Quick Setup (5 minutes):**

1. Create a bot via [@BotFather](https://t.me/BotFather)
2. Get your Chat ID via [@myidbot](https://t.me/myidbot)
3. Add secrets to your repository:
   - `TELEGRAM_BOT_TOKEN` - Your bot token from BotFather
   - `TELEGRAM_CHAT_ID` - Your chat ID
4. Send `/start` to your bot
5. Done! You'll get notifications on every build

**For detailed setup instructions, see [TELEGRAM_SETUP.md](TELEGRAM_SETUP.md)**

**Notifications include:**
- ✅ Build success with download link
- ❌ Build failure with error details
- 📄 Automatic error log file attachment
- ⏱️ Build duration and details
- 🔗 Direct link to workflow

### 🎬 What You'll See During Build

The workflow provides real-time visual feedback:

```
═══════════════════════════════════════════════════════════
  Setting Up Build Environment
═══════════════════════════════════════════════════════════

[████████████████████████████████████████████████] 100% - Installing dependencies
✓ All dependencies installed successfully
✓ Environment setup completed in 3m 24s

═══════════════════════════════════════════════════════════
  Starting Compilation
═══════════════════════════════════════════════════════════

[████████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 42% (1247/2956) Building...
```

Each phase shows:
- Progress bars with percentage completion
- Current/total tasks where applicable
- Elapsed time for each phase
- Color-coded success/error messages

### 🔄 Build Flow

The build process follows these phases:

```
1. ⚙️  Setup Environment (3-5 min)
   └─ Install dependencies, configure tools
   
2. ☕ Configure Java (< 1 min)
   └─ Auto-select correct Java version
   
3. 🔧 Configure ROM Source (< 1 min)
   └─ Set manifest URL
   
4. 📥 Sync Repository (30-90 min)
   ├─ Initialize repo
   ├─ Clone Treble manifests
   └─ Sync all sources
   
5. 🔨 Setup Treble (< 1 min)
   └─ Generate device configs
   
6. 💾 Setup ccache (< 1 min) [Optional]
   └─ Configure build cache
   
7. 🏗️  Build GSI (1-3 hours)
   ├─ Source environment
   ├─ Configure target
   └─ Compile system image
   
8. 📦 Package Output (5-15 min)
   ├─ Compress image
   └─ Generate build info
   
9. ✅ Upload Artifacts
   └─ Save to GitHub
```

Each phase includes automatic retry logic and detailed error reporting.

---

## Configuration ⚙️

Refer to the table below to fill out the form correctly. The most important part is matching the **ROM Branch** with the correct **Treble Manifest Branch**.

| Field Name | Description & Tips |
| :--- | :--- |
| **Choose ROM Base** | Select your ROM from the list. If your ROM isn't listed, choose **Custom** and paste the manifest URL in the next field. |
| **Custom Manifest URL** | Only required if you selected **Custom**. Paste the full Git repository URL (e.g., `https://github.com/RisingTechOSS/android`). |
| **ROM Branch** | The specific version/branch of the ROM.<br>*Examples:* `lineage-22.0`, `15.0`, `fourteen`, `thirteen`, `tiramisu`, `fenix`. |
| **Treble Manifest Branch** | Must match the Android version of the ROM branch.<br>*Common mappings:*<br>• Android 16 → `android-16.0`<br>• Android 15 → `android-15.0`<br>• Android 14 → `android-14.0`<br>• Android 13 → `android-13.0`<br>• Android 12/12.1 → `android-12.1`<br>• Android 11 → `android-11.0`<br>• Android 10 → `android-10.0` |
| **Lunch Variant** | The target architecture and build type.<br>*Common options:*<br>• `treble_arm64_bvN-userdebug` (64-bit A/B with VNDKLite)<br>• `treble_arm64_bgN-userdebug` (64-bit A-only with VNDKLite)<br>• `treble_a64_bvN-userdebug` (32/64-bit A/B)<br>• `treble_arm64_bvS-userdebug` (64-bit A/B Slim variant) |

---

## Android Version to Treble Branch Mapping 🗺️

| Android Version | Treble Branch | Common ROM Branch Names |
| :--- | :--- | :--- |
| Android 16 | `android-16.0` | `16.0`, `lineage-23.0`, `sixteen`, `baklava` |
| Android 15 | `android-15.0` | `15.0`, `lineage-22.0`, `fifteen`, `udc` |
| Android 14 | `android-14.0` | `14.0`, `lineage-21.0`, `fourteen`, `upside-down-cake` |
| Android 13 | `android-13.0` | `13.0`, `lineage-20.0`, `thirteen`, `tiramisu` |
| Android 12.1 | `android-12.1` | `12.1`, `lineage-19.1`, `twelve-plus`, `snow-cone` |
| Android 12 | `android-12.1` | `12.0`, `lineage-19.0`, `twelve`, `snow-cone` |
| Android 11 | `android-11.0` | `11.0`, `lineage-18.1`, `eleven`, `red-velvet-cake` |
| Android 10 | `android-10.0` | `10.0`, `lineage-17.1`, `ten`, `quince-tart` |

---

## Build Examples 📝

Here are some common configurations to help you get started:

### Example A: Building LineageOS 23.0 (Android 16) - Latest!
- **Choose ROM Base**: `LineageOS`
- **ROM Branch**: `lineage-23.0`
- **Treble Manifest Branch**: `android-16.0`
- **Lunch Variant**: `treble_arm64_bvN-userdebug`

### Example B: Building LineageOS 22.0 (Android 15)
- **Choose ROM Base**: `LineageOS`
- **ROM Branch**: `lineage-22.0`
- **Treble Manifest Branch**: `android-15.0`
- **Lunch Variant**: `treble_arm64_bvN-userdebug`

### Example C: Building crDroid Android 14
- **Choose ROM Base**: `crDroid`
- **ROM Branch**: `14.0`
- **Treble Manifest Branch**: `android-14.0`
- **Lunch Variant**: `treble_arm64_bvN-userdebug`

### Example D: Building PixelOS 14
- **Choose ROM Base**: `PixelOS`
- **ROM Branch**: `fourteen`
- **Treble Manifest Branch**: `android-14.0`
- **Lunch Variant**: `treble_arm64_bvN-userdebug`

### Example E: Building Evolution X Android 13
- **Choose ROM Base**: `Evolution X`
- **ROM Branch**: `tiramisu`
- **Treble Manifest Branch**: `android-13.0`
- **Lunch Variant**: `treble_arm64_bvN-userdebug`

### Example F: Building RisingOS (Custom ROM)
- **Choose ROM Base**: `RisingOS`
- **ROM Branch**: `fifteen`
- **Treble Manifest Branch**: `android-15.0`
- **Lunch Variant**: `treble_arm64_bvN-userdebug`

### Example G: Building an unlisted ROM (e.g., YAAP)
- **Choose ROM Base**: `Custom (Input URL manually)`
- **Custom Manifest URL**: `https://github.com/yaap/manifest`
- **ROM Branch**: `fifteen`
- **Treble Manifest Branch**: `android-15.0` 
- **Lunch Variant**: `treble_arm64_bvN-userdebug`

---

## Lunch Variant Guide 🍽️

Choose the correct variant based on your device architecture:

| Variant | Architecture | Partition | VNDK | Description |
| :--- | :--- | :--- | :--- | :--- |
| `treble_arm64_bvN` | ARM64 only | A/B | Lite | Most modern devices (Recommended) |
| `treble_arm64_bgN` | ARM64 only | A-only | Lite | Older devices with single system partition |
| `treble_a64_bvN` | ARM32/64 | A/B | Lite | Devices with 32-bit app support |
| `treble_arm64_bvS` | ARM64 only | A/B | Slim | Minimal variant, smaller size |
| `treble_arm_bvN` | ARM32 only | A/B | Lite | Very old 32-bit devices (rare) |

**Note:** Always use `-userdebug` suffix for GSI builds (e.g., `treble_arm64_bvN-userdebug`).

---

## Troubleshooting 🔧

### Common Issues

For detailed troubleshooting, see **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)**.

#### Quick Fixes:

**"remote github already exists with different attributes"**
- ✅ Now automatically handled by the sync script
- Script removes conflicting manifests and cleans remotes
- If still fails, the issue is with the ROM's manifest structure
- **Try:** Use a different ROM branch or see TROUBLESHOOTING.md

**Build Fails During Sync**
- Check if the ROM branch name is correct by visiting the ROM's GitHub repository
- Verify the manifest URL is accessible
- Some ROMs may have renamed their branches recently

### Build Fails During Compilation
- Download the error logs artifact from the failed workflow
- Common issues:
  - Insufficient disk space (workflow automatically clears space, but very large ROMs may still fail)
  - Missing dependencies for specific Android versions
  - ROM-specific build requirements not met

### Wrong Android Version
- Always verify the Android version of your chosen ROM branch
- Check the ROM's official documentation or GitHub tags
- When in doubt, check the ROM's `build/core/version_defaults.mk` file in their repository

---

## Downloading & Usage 📂

### Setting Up Your Fork

After forking this repository, the structure should look like:

```
your-repo/
├── .github/workflows/build.yml
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
│   └── build-summary.sh
└── README.md
```

**Important:** Make sure all scripts in the `scripts/` directory are present. The workflow will automatically make them executable.

### Downloading Built GSIs

1. Once the workflow completes, scroll to the **Artifacts** section at the bottom.
2. Download the zip file (named `gsi-[ROM]-[branch]`).
3. Extract the zip to find `system.img.xz`.
4. Decompress the image: 
   ```bash
   xz -d system.img.xz
   ```
5. Flash the resulting `system.img` to your device using fastboot:
   ```bash
   fastboot flash system system.img
   ```

**Important Notes:**
- Ensure your device supports Project Treble (check with Treble Check app)
- Your bootloader must be unlocked
- Back up your data before flashing
- Some ROMs may require additional steps (wiping data, formatting partitions)
- **Telegram notifications are optional** - if you don't set them up, the workflow works normally

---

## Advanced Options 🔬

### Building for Specific Devices
While these are generic GSIs, you can optimize for your device by:
1. Choosing the correct architecture variant (arm64 vs a64)
2. Selecting A/B vs A-only based on your partition scheme
3. Using slim variants for devices with limited storage

### Custom Build Flags
The workflow includes standard flags, but you can fork and modify to add:
- `BOARD_VNDK_VERSION` overrides
- Custom kernel configurations
- Additional ROM-specific flags

---

## Known Limitations ⚠️

- Maximum build time: 6 hours (GitHub Actions limit)
- Disk space: ~80GB available (very large ROMs may fail)
- Some ROMs with heavy customization may not build successfully
- Android versions older than 10 are not officially supported
- **Android 16 Note**: As a new release, some ROMs may not have stable Android 16 branches yet. Check the ROM's GitHub repository for availability.

---

## Credits 🙏

- [phhusson](https://github.com/phhusson) for the original Treble work
- [TrebleDroid](https://github.com/TrebleDroid) for maintaining the device manifests
- All the respective ROM maintainers for their great code
- [GitHub Actions](https://github.com/features/actions) for free CI/CD infrastructure

---

## Contributing 🤝

Found a ROM that doesn't work? Have suggestions for improvements?

1. Open an issue with details about the ROM and error logs
2. Submit a pull request with fixes or new ROM additions
3. Share your successful builds and configurations

---

## License 📄

This project is licensed under GPL-3.0. See individual ROM projects for their respective licenses.

---

**Happy Building!** 🚀
