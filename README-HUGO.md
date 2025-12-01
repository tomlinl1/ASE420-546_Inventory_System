# Hugo Website for Inventory System

This directory contains the Hugo static website for the Antonio's Pizza Pub Inventory System.

## Prerequisites

Install Hugo (Extended version recommended):
- Download from: https://gohugo.io/installation/
- Or use package manager:
  - macOS: `brew install hugo`
  - Windows: `choco install hugo-extended`
  - Linux: Follow instructions at https://gohugo.io/installation/

## Running the Website Locally

1. **Install dependencies (if using a theme from git submodule):**
   ```bash
   git submodule update --init --recursive
   ```

2. **Start the Hugo server:**
   ```bash
   hugo server
   ```

3. **View the website:**
   Open your browser to `http://localhost:1313`

4. **With drafts enabled:**
   ```bash
   hugo server -D
   ```

## Building the Website

To build the static site:

```bash
hugo
```

The generated files will be in the `public/` directory.

## Deployment

The `public/` directory contains the static HTML files that can be deployed to any web server or static hosting service:

- **Netlify:** Drag and drop the `public/` folder
- **GitHub Pages:** Push the `public/` folder to the `gh-pages` branch
- **Vercel:** Connect your repository
- **Any web server:** Upload the contents of `public/` to your web root

## Project Structure

```
.
├── content/          # Content pages (markdown)
│   ├── getting-started/
│   ├── setup/
│   ├── usage/
│   ├── features/
│   └── troubleshooting/
├── themes/           # Hugo theme
│   └── inventory-theme/
│       └── layouts/  # HTML templates
├── static/           # Static files (images, CSS, JS)
├── hugo.toml        # Hugo configuration
└── public/          # Generated static site (gitignored)
```

## Customization

- Edit `hugo.toml` to change site configuration
- Modify files in `themes/inventory-theme/layouts/` to change the theme
- Add content by creating markdown files in `content/`
- Add static assets (images, files) to `static/`

## Documentation

For more information about Hugo, visit: https://gohugo.io/documentation/

