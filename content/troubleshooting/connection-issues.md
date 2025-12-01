---
title: "PocketBase Connection Issues"
date: 2024-01-01
draft: false
weight: 10
---

# PocketBase Connection Issues

## Problem

App shows "Failed to load stock" error.

## Solutions

1. **Verify PocketBase is running:**
   ```bash
   # Check if PocketBase is accessible
   curl http://127.0.0.1:8090/api/health
   ```

2. **Check PocketBase is running on the correct port:**
   - Default port is 8090
   - Verify in the terminal where you started PocketBase

3. **Ensure no firewall is blocking the connection:**
   - Check Windows Firewall or macOS/Linux firewall settings
   - Allow connections on port 8090

4. **Verify the `inventory` collection exists:**
   - Open PocketBase admin UI: `http://127.0.0.1:8090/_/`
   - Check that the "inventory" collection is created
   - See [Configuring PocketBase](/setup/configuring-pocketbase/) for setup instructions

5. **Check PocketBase admin UI is accessible:**
   - Open browser to `http://127.0.0.1:8090/_/`
   - If this doesn't work, PocketBase is not running correctly

## Still Having Issues?

- Check PocketBase terminal output for error messages
- Restart PocketBase server
- Verify network settings

