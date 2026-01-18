# Treble GSI Builder

Automated build system using GitHub Actions to generate Project Treble GSI images. Based on LineageOS and TrebleDroid.

---

## Overview

This workflow allows you to build Treble GSIs remotely without using local resources. It utilizes `slimhub_actions` to optimize disk usage, ensuring sufficient space for the compilation process on standard GitHub runners.

## Quick Start

1. **Fork this repository** to your account.
2. Open the **Actions** tab.
3. Select **Build Treble GSI (SlimHub Optimized)**.
4. Click **Run workflow**.
5. Select the branch and fill in the build parameters.
6. Click the green **Run workflow** button.

## Configuration

The following parameters are available when running the workflow:

| Parameter | Description | Default Value |
| :--- | :--- | :--- |
| **LineageOS Branch** | The version of LineageOS to use as the base. | `lineage-22.1` |
| **Manifest Branch** | The TrebleDroid manifest version (usually matches Android version). | `android-15.0` |
| **Lunch Variant** | The specific device configuration and architecture. | `treble_arm64_bvN-userdebug` |

<details>
<summary><b>Available Lunch Variants</b></summary>

Choose the variant that matches your device architecture and preference:

- **`treble_arm64_bvN`**: 64-bit, Vanilla (No GApps), VNDK v3+.
- **`treble_arm64_bgN`**: 64-bit, GApps included, VNDK v3+.
- **`treble_arm64_avN`**: 64-bit, AOSP (Generic), VNDK v3+.

*Note: Replace `N` with the specific version number if required by the manifest.*

</details>

## Downloading

Once the build status shows success:

1. Scroll to the bottom of the workflow run page.
2. Locate the **Artifacts** section.
3. Download `gsi-treble-[branch]-slim.zip`.
4. Extract the zip file to retrieve `system.img.xz`.
5. Decompress the image file:
   ```bash
   xz -d system.img.xz
   ```

## Notes & Limitations

- **Duration**: The build process takes approximately 1 to 3 hours. The initial run will be slower due to source synchronization.
- **Storage**: The workflow cleans up the CI environment to free up to ~80GB. If the source size exceeds this, the build may fail.
- **Requirements**: Ensure your device supports Project Treble and has an unlocked bootloader.

## Credits

- [phhusson](https://github.com/phhusson) for Treble contributions.
- [TrebleDroid](https://github.com/TrebleDroid) for the device manifests.
- [LineageOS](https://github.com/LineageOS) for the ROM source.
- [rokibhasansagar](https://github.com/rokibhasagar) for `slimhub_actions`.
