---
title: "App Won't Start"
date: 2024-01-01
draft: false
weight: 40
---

# App Won't Start

## Problem

Flutter app fails to launch.

## Solutions

1. **Verify Flutter installation:**
   ```bash
   flutter doctor
   ```
   This command checks your Flutter installation and displays any issues that need to be resolved.

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
   Make sure you're in the `inventory_app` directory.

3. **Check for available devices:**
   ```bash
   flutter devices
   ```
   Ensure you have a device or emulator available. If not, start an emulator or connect a physical device.

4. **Ensure you're in the correct directory:**
   ```bash
   # You should be in the inventory_app directory
   cd inventory_app
   pwd  # Verify current directory
   ```

5. **Check for errors in the code:**
   ```bash
   flutter analyze
   ```
   This will show any code errors that might prevent the app from running.

## Common Issues

- Not in the correct directory (`inventory_app`)
- Dependencies not installed
- No device/emulator available
- Flutter installation incomplete

## Still Having Issues?

- Check Flutter console output for specific error messages
- Verify your Flutter SDK version (requires 3.9.2 or higher)
- Try running `flutter clean` then `flutter pub get`

