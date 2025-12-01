---
title: "Data Not Syncing"
date: 2024-01-01
draft: false
weight: 50
---

# Data Not Syncing

## Problem

Changes made on one device don't appear on another.

## Solutions

1. **Pull down to refresh on the home page:**
   - The app loads data when it starts
   - Manually refresh to get the latest data
   - Pull down gesture refreshes all inventory data

2. **Ensure all devices are connected to the same PocketBase instance:**
   - All devices must connect to the same PocketBase server
   - Default: `http://127.0.0.1:8090`
   - For network access, use the server's IP address instead of `127.0.0.1`

3. **Check network connectivity:**
   - Verify all devices are on the same network
   - Check that PocketBase is accessible from all devices
   - Test with: `curl http://<server-ip>:8090/api/health`

4. **Verify PocketBase is accessible from all devices:**
   - For cross-machine access, update `lib/main.dart`:
   ```dart
   // Change from:
   final pb = PocketBase('http://127.0.0.1:8090');
   
   // To (use your server's IP address):
   final pb = PocketBase('http://192.168.1.100:8090');
   ```

## Network Configuration

**For local network access:**
- Find your server's local IP address:
  - Windows: `ipconfig`
  - macOS/Linux: `ifconfig` or `ip addr`
- Update the PocketBase URL in `lib/main.dart`
- Restart the Flutter app

**For production:**
- Use a proper domain name or static IP
- Configure PocketBase to listen on all interfaces: `0.0.0.0:8090`
- Set up proper firewall rules

## Still Having Issues?

- Check PocketBase logs for connection attempts
- Verify network firewall settings
- Test PocketBase accessibility from each device

