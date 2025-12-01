---
title: "Configuring PocketBase Database"
date: 2024-01-01
draft: false
weight: 30
---

# Configuring PocketBase Database

## Step 1: Access PocketBase Admin UI

1. Open `http://127.0.0.1:8090/_/` in your browser
2. Log in with your admin credentials

## Step 2: Create the Inventory Collection

1. Click on "Collections" in the left sidebar
2. Click the "+" button to create a new collection
3. Set the collection name to: **`inventory`** (exact name, case-sensitive)

## Step 3: Add Fields to the Collection

Click "New field" and add the following fields:

| Field Name | Field Type | Options |
|------------|-----------|---------|
| `item_name` | Text | Required: Yes, Min length: 1 |
| `quantity` | Number | Required: Yes, Type: Integer, Min: 0 |
| `unit` | Text | Required: Yes, Min length: 1 |

## Step 4: Set Collection Permissions

1. Go to the "API rules" tab in your collection settings
2. Set the following rules to: `@request.auth.id != ""`
   - List/Search rule
   - View rule
   - Create rule
   - Update rule
   - Delete rule

**Note:** For development/testing purposes, you can also allow anonymous access by setting all rules to empty string `""`, but this is not recommended for production.

## Step 5: Enable Anonymous Access (Optional - for testing)

1. Go to "Settings" → "API Settings"
2. Enable "Allow anonymous access to collections"

## Next Steps

Once the database is configured, you're ready to [Run the Application](/getting-started/running-the-application/).

