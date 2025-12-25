# How to Build for GitHub Pages

## Build Command:
```bash
flutter build web --release --base-href="/hadis40-web/"
```

## After building:
1. Copy contents of `build/web` to your GitHub repository
2. Push to `gh-pages` branch
3. Your app will be at: https://c24-s60348.github.io/hadis40-web/

## Quick Deploy:
```bash
cd build/web
git add .
git commit -m "Update web build"
git push origin gh-pages
```

## Icons Updated:
✅ Favicon now uses your Hadis 40 logo
✅ All web icons updated
✅ Manifest.json updated with correct app name and colors
