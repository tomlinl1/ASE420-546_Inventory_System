---
title: "Cannot Add/Update Items"
date: 2024-01-01
draft: false
weight: 20
---

# Cannot Add/Update Items

## Problem

Unable to save new items or update existing ones.

## Solutions

1. **Check PocketBase collection permissions:**
   - Open PocketBase admin UI: `http://127.0.0.1:8090/_/`
   - Go to Collections → inventory → API rules
   - Ensure rules are set correctly (see [Configuring PocketBase](/setup/configuring-pocketbase/))
   - For testing, you can allow anonymous access by setting rules to empty string `""`

2. **Verify all required fields are filled:**
   - Item Name: Cannot be empty
   - Quantity: Must be a valid number (integer)
   - Unit: Cannot be empty

3. **Ensure quantity is a valid number:**
   - Must be an integer (whole number)
   - Cannot be negative (minimum is 0)
   - Examples: `10`, `5`, `0` ✅
   - Invalid: `10.5`, `abc`, `-5` ❌

4. **Check PocketBase logs for error messages:**
   - Look at the terminal where PocketBase is running
   - Check for any error messages when attempting to save

## Common Mistakes

- Forgetting to fill in all three fields
- Entering non-numeric values in quantity field
- Collection permissions not set correctly

## Still Having Issues?

Try refreshing the app or restarting both PocketBase and the Flutter app.

