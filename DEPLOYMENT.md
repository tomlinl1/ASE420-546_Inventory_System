# GitHub Pages Deployment Guide

This guide explains how to deploy the Hugo website to GitHub Pages using GitHub Actions.

## Prerequisites

1. Your repository must be on GitHub
2. GitHub Pages must be enabled in your repository settings
3. The workflow file (`.github/workflows/hugo.yml`) is already configured

## Setup Instructions

### Step 1: Enable GitHub Pages

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Pages**
3. Under **Source**, select **GitHub Actions**
4. Save the changes

### Step 2: Update Base URL (Optional)

The workflow automatically sets the base URL based on your repository name. However, if you want to use a custom domain or update the URL manually:

1. Edit `hugo.toml`
2. Update the `baseURL` line:
   ```toml
   baseURL = 'https://yourusername.github.io/your-repo-name/'
   ```

**Note:** For GitHub Pages, the URL format is:
- `https://username.github.io/repository-name/` (for user/organization pages)
- `https://username.github.io/` (if repository name is `username.github.io`)

### Step 3: Push to Main Branch

The workflow will automatically trigger when you push to the `main` branch:

```bash
git add .
git commit -m "Update website content"
git push origin main
```

### Step 4: Monitor Deployment

1. Go to the **Actions** tab in your GitHub repository
2. You'll see the workflow running
3. Wait for it to complete (usually 1-2 minutes)
4. Once complete, your site will be available at:
   `https://yourusername.github.io/your-repo-name/`

## Manual Deployment

You can also trigger the workflow manually:

1. Go to the **Actions** tab
2. Select **Deploy Hugo site to Pages** workflow
3. Click **Run workflow**
4. Select the branch (usually `main`)
5. Click **Run workflow**

## Troubleshooting

### Workflow Fails

1. Check the **Actions** tab for error messages
2. Common issues:
   - Hugo syntax errors in content files
   - Missing theme files
   - Incorrect baseURL format

### Site Not Updating

1. Wait a few minutes for GitHub Pages to update
2. Clear your browser cache
3. Check the workflow status in the **Actions** tab

### 404 Errors

1. Verify the baseURL in `hugo.toml` matches your repository URL
2. Ensure all content files are in the `content/` directory
3. Check that the theme is properly configured

## Custom Domain

To use a custom domain:

1. Add a `CNAME` file to the `static/` directory with your domain name
2. Update DNS settings to point to GitHub Pages
3. Update `baseURL` in `hugo.toml` to your custom domain

## Workflow Details

The workflow:
- Runs on pushes to `main` branch
- Uses Hugo Extended version
- Builds with minification enabled
- Automatically sets the correct baseURL
- Deploys to GitHub Pages

## Repository Structure

```
.
├── .github/
│   └── workflows/
│       └── hugo.yml          # GitHub Actions workflow
├── content/                  # Website content
├── themes/
│   └── inventory-theme/      # Custom theme
├── hugo.toml                 # Hugo configuration
└── public/                   # Generated site (created during build)
```

## Support

For issues with the deployment:
1. Check GitHub Actions logs
2. Verify Hugo configuration
3. Review GitHub Pages settings

