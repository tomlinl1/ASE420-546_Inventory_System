---
title: "Running PocketBase"
date: 2024-01-01
draft: false
weight: 20
---

# Running PocketBase

## Start the PocketBase Server

### Windows (PowerShell or Command Prompt)
```powershell
.\pocketbase\pocketbase.exe serve
```

### macOS/Linux
```bash
./pocketbase/pocketbase serve
```

## PocketBase Admin UI

When PocketBase starts:

- The server will run on `http://127.0.0.1:8090`
- On first run, you'll need to create an admin account
- Open your browser and navigate to: `http://127.0.0.1:8090/_/`
- Follow the setup wizard to create your admin account

## Keep PocketBase Running

⚠️ **Important:** Leave the terminal window open while using the inventory app. The app requires PocketBase to be running at all times.

## Next Steps

Once PocketBase is running, proceed to [Configuring the Database](/setup/configuring-pocketbase/).

