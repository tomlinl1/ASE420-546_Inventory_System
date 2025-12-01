---
title: "Installing Dependencies"
date: 2024-01-01
draft: false
weight: 10
---

# Installing Dependencies

## Navigate to Project Directory

```bash
cd inventory_app
```

## Install Flutter Dependencies

Run the following command to install all required packages:

```bash
flutter pub get
```

This will download and install all dependencies listed in `pubspec.yaml`, including:
- Flutter SDK packages
- PocketBase client
- URL launcher
- Other required dependencies

## Verify Installation

To verify that everything is installed correctly:

```bash
flutter doctor
```

This command will check your Flutter installation and display any issues that need to be resolved.

## Next Steps

Once dependencies are installed, you can proceed to [Running the Application](/getting-started/running-the-application/).

