

# Universal GSI Builder 🤖

Automated GitHub Actions workflow to build Treble GSIs for multiple ROMs. No code editing required—just select, run, and build.

## Supported ROMs 📱

This workflow supports the following ROMs via a simple dropdown menu:

- LineageOS 🧬
- crDroid 🤖
- DerpFest 🍤
- Evolution X 🔥
- PixelOS 📱
- ArrowOS 🏹
- **Custom** (Any other AOSP ROM)

---

## Quick Start ⚡

1. **Fork** this repository to your account.
2. Go to the **Actions** tab.
3. Select **Universal Treble GSI Builder** and click **Run workflow**.
4. Fill in the options (see the guide below) and click the green button.
5. Wait for the build to finish (usually 1-3 hours) and grab the artifact.

---

## Configuration ⚙️

Refer to the table below to fill out the form correctly. The most important part is matching the **ROM Branch** with the correct **Android Version**.

| Field Name | Description & Tips |
| :--- | :--- |
| **Choose ROM Base** | Select your ROM from the list. If your ROM isn't listed, choose **Custom** and paste the manifest URL in the next field. |
| **ROM Branch** | The specific version of the ROM.<br> *Examples:* `15.0`, `fourteen`, `thirteen`, `peplus`. |
| **Treble Manifest Branch** | Must match the Android version of the ROM branch.<br> *If Branch is `15.0` → Use `android-15.0`*<br> *If Branch is `fourteen` → Use `android-14.0`* |
| **Lunch Variant** | The target architecture.<br> *Standard:* `treble_arm64_bvN-userdebug` |

---

## Build Examples 📝

Here are some common configurations to help you get started:

### Example A: Building crDroid Android 15
- **Choose ROM Base**: `crDroid`
- **ROM Branch**: `15.0`
- **Treble Manifest Branch**: `android-15.0`

### Example B: Building PixelOS 14
- **Choose ROM Base**: `PixelOS`
- **ROM Branch**: `fourteen`
- **Treble Manifest Branch**: `android-14.0`

### Example C: Building an unsupported ROM (e.g., RisingOS)
- **Choose ROM Base**: `Custom (Input URL manually)`
- **Custom Manifest URL**: `https://github.com/RisingTechOSS/android`
- **ROM Branch**: `fenix`
- **Treble Manifest Branch**: `android-15.0` (Check what Android version 'fenix' is based on)

---

## Downloading & Usage 📂

1. Once the workflow completes, scroll to the **Artifacts** section at the bottom.
2. Download the zip file (named `gsi-[ROM]-[branch]`).
3. Extract the zip to find `system.img.xz`.
4. Decompress the image: `xz -d system.img.xz`.
5. Flash the resulting `system.img` to your device.

**Note:** Ensure your device supports Project Treble and has an unlocked bootloader before flashing.

---

## Credits 🙏

- [phhusson](https://github.com/phhusson) for the original Treble work.
- [TrebleDroid](https://github.com/TrebleDroid) for maintaining the device manifests.
- All the respective ROM maintainers for their great code.
