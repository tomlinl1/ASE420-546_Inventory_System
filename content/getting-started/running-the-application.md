---
title: "Running the Application"
date: 2024-01-01
draft: false
weight: 20
---

# Running the Application

**Important:** Make sure PocketBase is running before starting the Flutter app!

The app connects to PocketBase at `http://127.0.0.1:8090`. If PocketBase is not running, the app will show connection errors.

## Run from Terminal

### Desktop Platforms

**Windows:**
```bash
flutter run -d windows
```

**macOS:**
```bash
flutter run -d macos
```

**Linux:**
```bash
flutter run -d linux
```

### Mobile Platforms

**Android (Emulator or Device):**
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

**iOS (Simulator or Device):**
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

### Web Platform

```bash
flutter run -d chrome
```

## Building for Production

### Windows Executable:
```bash
flutter build windows
```
Output will be in: `build/windows/x64/runner/Release/`

### macOS App:
```bash
flutter build macos
```

### Android APK:
```bash
flutter build apk
```

### iOS:
```bash
flutter build ios
```

## Troubleshooting

If you encounter issues running the app:
- Ensure PocketBase is running
- Check that you're in the correct directory (`inventory_app`)
- Verify Flutter installation with `flutter doctor`
- See the [Troubleshooting Guide](/troubleshooting/) for more help

