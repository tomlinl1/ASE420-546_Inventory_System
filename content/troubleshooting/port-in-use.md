---
title: "Port Already in Use"
date: 2024-01-01
draft: false
weight: 60
---

# Port Already in Use

## Problem

PocketBase won't start because port 8090 is already in use.

## Solutions

### Solution 1: Find and Close the Process

**Windows:**
```powershell
# Find the process using port 8090
netstat -ano | findstr :8090

# Kill the process (replace <PID> with the actual process ID)
taskkill /PID <PID> /F
```

**macOS/Linux:**
```bash
# Find and kill the process using port 8090
lsof -ti:8090 | xargs kill -9
```

### Solution 2: Use a Different Port

If you can't close the existing process, run PocketBase on a different port:

```bash
# Run PocketBase on port 8091
./pocketbase serve --http=127.0.0.1:8091
```

Then update `lib/main.dart` to use the new port:

```dart
// Change the PocketBase URL
final pb = PocketBase('http://127.0.0.1:8091');
```

### Solution 3: Check for Multiple PocketBase Instances

Sometimes multiple PocketBase instances might be running:

**Windows:**
```powershell
Get-Process | Where-Object {$_.ProcessName -like "*pocketbase*"}
```

**macOS/Linux:**
```bash
ps aux | grep pocketbase
```

Kill any duplicate instances.

## Prevention

- Always check if PocketBase is already running before starting it
- Close the terminal or stop the process properly when done
- Use a process manager for production deployments

## Still Having Issues?

- Restart your computer if the port remains locked
- Check if another application is using port 8090
- Consider using a different port for PocketBase

