---
title: "Installing PocketBase"
date: 2024-01-01
draft: false
weight: 10
---

# Installing PocketBase

## Step 1: Download PocketBase

Visit [https://pocketbase.io/docs/](https://pocketbase.io/docs/) and download the appropriate version for your operating system:

- **Windows:** `pocketbase_x.x.x_windows_amd64.zip`
- **macOS (Intel):** `pocketbase_x.x.x_darwin_amd64.zip`
- **macOS (Apple Silicon):** `pocketbase_x.x.x_darwin_arm64.zip`
- **Linux:** `pocketbase_x.x.x_linux_amd64.zip`

## Step 2: Extract the Downloaded File

### Windows (PowerShell)
```powershell
Expand-Archive pocketbase_x.x.x_windows_amd64.zip -DestinationPath ./pocketbase
```

### macOS/Linux
```bash
unzip pocketbase_x.x.x_darwin_amd64.zip -d ./pocketbase
```

## Step 3: Make PocketBase Executable (macOS/Linux only)

```bash
chmod +x ./pocketbase/pocketbase
```

## Next Steps

Once PocketBase is installed, proceed to [Running PocketBase](/setup/running-pocketbase/).

