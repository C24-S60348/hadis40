# Deploying Hadis 40 to Itch.io

## Files Ready
Your web build is ready at: `build/hadis40-web.zip`

## Steps to Upload to Itch.io

### 1. Go to Your Itch.io Dashboard
- Visit: https://itch.io/dashboard
- Click "Create new project"

### 2. Configure Your Project
- **Title**: Hadis 40 Imam Nawawi
- **Project URL**: Choose a URL (e.g., hadis40)
- **Classification**: Game or Tool (choose Tool for an app)
- **Kind of project**: HTML

### 3. Upload Files
- Click "Upload files"
- Upload the `hadis40-web.zip` file
- **IMPORTANT**: Check the box "This file will be played in the browser"

### 4. Embed Options (CRITICAL for Flutter Web)
After uploading, configure these settings:

**Viewport dimensions:**
- Width: 1280 (or leave default)
- Height: 720 (or leave default)
- Or check "Fullscreen button" for best experience

**Embed options:**
- ✅ Check "Fullscreen button" - RECOMMENDED
- ✅ Check "Automatically start on page load"
- ✅ Check "Mobile friendly" (if applicable)

**Frame options:**
- Select "iframe" (default)

### 5. Additional Settings
- Set visibility (Public/Private)
- Add description
- Add screenshots
- Set pricing (Free or paid)

### 6. Save & View Page
- Click "Save & view page"
- Test your app in the browser

## Troubleshooting

### If you still see a blank screen:

1. **Check Browser Console** (F12):
   - Look for any errors
   - Common issues: CORS errors, missing files

2. **Try Different Browsers**:
   - Test in Chrome, Firefox, Safari
   - Some browsers may have stricter security

3. **Rebuild with CanvasKit** (if needed):
   ```bash
   flutter build web --release --web-renderer canvaskit --base-href="/"
   ```

4. **Or use HTML renderer** (lighter, better compatibility):
   ```bash
   flutter build web --release --web-renderer html --base-href="/"
   ```

5. **Check Itch.io Settings**:
   - Make sure "This file will be played in the browser" is checked
   - Try toggling "Fullscreen button" option
   - Try different viewport dimensions

### Common Issues:

**Issue**: White/blank screen
**Solution**: 
- Ensure base href is set to "/"
- Check that all files are in the zip
- Verify "played in the browser" is checked

**Issue**: Assets not loading
**Solution**: 
- Make sure you zipped the contents of the `web` folder, not the folder itself
- The zip should have `index.html` at the root level

**Issue**: App too large
**Solution**:
```bash
flutter build web --release --tree-shake-icons --base-href="/"
```

## Current Build Info
- Base href: `/`
- Build date: December 25, 2025
- Flutter version: Latest
- Renderer: Auto (CanvasKit with HTML fallback)

## Alternative: GitHub Pages
If Itch.io doesn't work, you can also deploy to GitHub Pages:

1. Push the `build/web` folder to a GitHub repository
2. Enable GitHub Pages in repository settings
3. Your app will be available at: `https://yourusername.github.io/repository-name/`

## Support
If you continue to have issues, check:
- Itch.io documentation: https://itch.io/docs/creators/html5
- Flutter web deployment: https://docs.flutter.dev/deployment/web

