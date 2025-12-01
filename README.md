---
marp: true
size: 16:9
paginate: true
theme: default
style: |
  section {
    background-color: #ffffff;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  }
  h1 {
    color: #d32f2f;
    border-bottom: 3px solid #d32f2f;
    padding-bottom: 10px;
  }
  h2 {
    color: #c62828;
  }
  code {
    background-color: #f5f5f5;
    padding: 2px 6px;
    border-radius: 3px;
  }
---

# Antonio's Pizza Pub Inventory System

## A Flutter-based inventory management system

**Features:**
- Real-time inventory tracking
- Low stock alerts
- Remote access capabilities
- Cross-platform support

**Version:** 1.0.0

---

# Table of Contents

1. Prerequisites
2. Setup Instructions
3. Running the Application
4. Using the Application
5. Features
6. Troubleshooting

---

# Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (version 3.9.2 or higher)
  - Installation: [docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
  - Verify: `flutter --version`

- **PocketBase** (latest version)
  - Download: [pocketbase.io/docs/](https://pocketbase.io/docs/)

- **Dart SDK** (included with Flutter)

- **An IDE** (VS Code, Android Studio, or IntelliJ IDEA)

---

# Installing PocketBase

**Step 1: Download**
- Visit [pocketbase.io/docs/](https://pocketbase.io/docs/)
- Download for your OS:
  - Windows: `pocketbase_x.x.x_windows_amd64.zip`
  - macOS: `pocketbase_x.x.x_darwin_amd64.zip` or `darwin_arm64.zip`
  - Linux: `pocketbase_x.x.x_linux_amd64.zip`

**Step 2: Extract**
```bash
# Windows (PowerShell)
Expand-Archive pocketbase_x.x.x_windows_amd64.zip -DestinationPath ./pocketbase

# macOS/Linux
unzip pocketbase_x.x.x_darwin_amd64.zip -d ./pocketbase
```

**Step 3: Make executable** (macOS/Linux)
```bash
chmod +x ./pocketbase/pocketbase
```

---

# Running PocketBase

**Start the server:**
```bash
# Windows
.\pocketbase\pocketbase.exe serve

# macOS/Linux
./pocketbase/pocketbase serve
```

**Access Admin UI:**
- Opens at `http://127.0.0.1:8090`
- First run: Create admin account at `http://127.0.0.1:8090/_/`

**Important:** Keep PocketBase running while using the app!

---

# Configuring PocketBase Database (1/2)

**Step 1: Create Collection**
- Open `http://127.0.0.1:8090/_/` in browser
- Click "Collections" → "+" button
- Name: **`inventory`** (case-sensitive)

**Step 2: Add Fields**

| Field Name  | Type   | Options                        |
| ----------- | ------ | ------------------------------ |
| `item_name` | Text   | Required: Yes                  |
| `quantity`  | Number | Required: Yes, Integer, Min: 0 |
| `unit`      | Text   | Required: Yes                  |

---

# Configuring PocketBase Database (2/2)

**Step 3: Set Permissions**
- Go to "API rules" tab
- Set all rules to: `@request.auth.id != ""`
  - List/Search rule
  - View rule
  - Create rule
  - Update rule
  - Delete rule

**Step 4: Enable Anonymous Access** (Optional - for testing)
- Settings → API Settings
- Enable "Allow anonymous access to collections"

---

# Running the Application - Setup

**1. Navigate to project:**
```bash
cd inventory_app
```

**2. Install dependencies:**
```bash
flutter pub get
```

**3. Ensure PocketBase is running!**

The app connects to `http://127.0.0.1:8090`

---

# Running the Application - Commands

**Desktop:**
```bash
flutter run -d windows    # Windows
flutter run -d macos      # macOS
flutter run -d linux      # Linux
```

**Mobile:**
```bash
flutter devices           # List devices
flutter run -d <device-id>
```

**Web:**
```bash
flutter run -d chrome
```

---

# Building for Production

**Windows:**
```bash
flutter build windows
# Output: build/windows/x64/runner/Release/
```

**macOS:**
```bash
flutter build macos
```

**Android:**
```bash
flutter build apk
```

**iOS:**
```bash
flutter build ios
```

---

# Home Page

The main entry point displays:

- **Welcome Message:** "Welcome to the Inventory System!"
- **Navigation Buttons:**
  - Check Stock
  - Update Stock
  - Website (opens antonios-pizzapub.com)
- **Low Stock Alert:** Red warning card if items < 3
- **Low Stock List:** Up to 5 items shown

**Refresh:** Pull down to refresh data

---

# Checking Stock

**Navigate:** Tap "Check Stock" button

**Features:**
- **Search Bar:** Filter items by name (case-insensitive, real-time)
- **Sort Menu** (☰ icon):
  - Name A–Z / Z–A
  - Quantity Low→High / High→Low
  - Low Stock First

**Update Quantities:**
- Use **"-"** button to decrease by 1
- Use **"+"** button to increase by 1
- Cannot go below 0
- Success/error messages shown

---

# Adding Stock Items

**Navigate:** Tap "Update Stock" button

**Fill in the Form:**
1. **Item Name:** e.g., "Mozzarella Cheese"
2. **Quantity:** e.g., "10"
3. **Unit:** e.g., "lbs", "gal", "boxes"

**Save:**
- Tap "Add Stock" button
- Green success message appears
- Form clears automatically
- Item appears in list below

---

# Updating Stock Items

**Navigate:** Tap "Update Stock" button

**Edit an Item:**
1. Find item in the list
2. Tap **edit icon (✏️)**
3. Form auto-fills with current data
4. Button changes to "Update Stock"

**Modify & Save:**
- Change any fields
- Tap "Update Stock"
- Green success message confirms update

---

# Removing Stock Items

**Navigate:** Tap "Update Stock" button

**Delete an Item:**
1. Find item in the list
2. Tap **delete icon (🗑️)**
3. Item immediately removed
4. List auto-refreshes

**⚠️ Warning:** Deletion is permanent!

**Quick Updates:**
- Use + / - buttons on Check Stock page
- Changes save immediately

---

# Features

✅ **Real-time Inventory Management**  
✅ **Low Stock Alerts** (threshold: 3 units)  
✅ **Search Functionality**  
✅ **Multiple Sort Options**  
✅ **User-Friendly Interface**  
✅ **Remote Access**  
✅ **Cross-Platform** (Windows, macOS, Linux, Android, iOS, Web)  

---

# Troubleshooting - Connection Issues

**Problem:** "Failed to load stock" error

**Solutions:**
1. Verify PocketBase is running: `curl http://127.0.0.1:8090/api/health`
2. Check port 8090 is correct
3. Check firewall settings
4. Verify `inventory` collection exists
5. Access admin UI at `http://127.0.0.1:8090/_/`

---

# Troubleshooting - Common Issues

**Cannot Add/Update Items:**
- Check collection permissions
- Verify all fields filled (Name, Quantity, Unit)
- Ensure quantity is valid integer
- Check PocketBase logs

**Low Stock Alert Not Showing:**
- Pull down to refresh
- Verify quantity < 3
- Check unit is set correctly

**App Won't Start:**
- Run `flutter doctor`
- Run `flutter pub get`
- Check `flutter devices`
- Verify correct directory (`inventory_app`)

---

# Troubleshooting - Advanced

**Data Not Syncing:**
- Pull down to refresh
- Ensure same PocketBase instance
- Check network connectivity
- Use device IP for cross-machine access

**Port Already in Use:**
```bash
# Windows
netstat -ano | findstr :8090
taskkill /PID <PID> /F

# macOS/Linux
lsof -ti:8090 | xargs kill -9
```

**Or use different port:**
```bash
./pocketbase serve --http=127.0.0.1:8091
```

---

# Additional Resources

- **Flutter Documentation:**  
  [docs.flutter.dev](https://docs.flutter.dev/)

- **PocketBase Documentation:**  
  [pocketbase.io/docs](https://pocketbase.io/docs/)

- **Dart Language Tour:**  
  [dart.dev/guides/language/language-tour](https://dart.dev/guides/language/language-tour)

---

# Support

**For issues or questions:**

1. Check the Troubleshooting section
2. Review PocketBase logs
3. Check Flutter console output

**Version:** 1.0.0  
**Last Updated:** 2024

**Thank you!**
