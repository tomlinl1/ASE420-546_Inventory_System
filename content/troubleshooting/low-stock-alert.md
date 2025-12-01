---
title: "Low Stock Alert Not Showing"
date: 2024-01-01
draft: false
weight: 30
---

# Low Stock Alert Not Showing

## Problem

Items below threshold (3) are not showing as low stock.

## Solutions

1. **Pull down on the home page to refresh data:**
   - The app loads data when it starts
   - Use pull-to-refresh to get the latest data

2. **Verify the item quantity is actually below 3:**
   - Go to Check Stock page
   - Check the actual quantity value
   - Low stock threshold is set to 3 (exclusive, so items with quantity < 3)

3. **Check the item unit is correctly set:**
   - Ensure the unit field is not empty
   - Verify the quantity is a valid number

## How Low Stock Detection Works

- Threshold: 3 units
- Comparison: Less than 3 (not equal to)
- Example: Item with quantity 2 = low stock ✅
- Example: Item with quantity 3 = NOT low stock ❌

## Still Having Issues?

- Refresh the home page
- Verify data is loading correctly
- Check that items exist in the database

