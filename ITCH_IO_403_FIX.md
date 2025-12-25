# Fixing 403 Errors on Itch.io

## The Problem

You're seeing:
```
GET https://html-classic.itch.zone/flutter_bootstrap.js [HTTP/2 403]
GET https://html-classic.itch.zone/icons/Icon-512.png [HTTP/2 403]
```

This means Itch.io is **blocking** access to your files.

## Why This Happens

Itch.io has strict security policies for HTML5 games. The 403 error usually means:

1. **File permissions issue** - Itch.io can't serve certain files
2. **MIME type issues** - Some file types are blocked
3. **Upload settings wrong** - The game isn't configured correctly
4. **Itch.io caching** - Old version is cached

## Solutions to Try

### Solution 1: Re-upload with Correct Settings ⭐ (Try This First)

1. **Delete the old upload** on Itch.io
2. Upload the **new clean zip**: `build/hadis40-itch-clean.zip`
3. **CRITICAL SETTINGS**:
   - ✅ Check "This file will be played in the browser"
   - ✅ Set "Kind of project" to **HTML**
   - ✅ Enable "Fullscreen button"
   - ✅ Enable "Automatically start on page load"
   - ✅ Set "Embed in page" (not "Click to launch in fullscreen")

4. **Viewport Settings**:
   - Width: 1280 (or leave auto)
   - Height: 720 (or leave auto)
   - ✅ Check "Mobile friendly"

5. **Save and Clear Cache**:
   - Save the project
   - Clear your browser cache (Ctrl+Shift+Delete)
   - Try again in incognito/private mode

### Solution 2: Check Project Visibility

Make sure your project is:
- Not in "Draft" mode
- Set to "Public" or "Restricted"
- Has proper access permissions

### Solution 3: Wait for Itch.io Processing

Sometimes Itch.io takes time to process files:
- Wait 5-10 minutes after upload
- Refresh the page
- Try in a different browser

### Solution 4: Use GitHub Pages Instead 🚀

If Itch.io continues to give problems, use GitHub Pages (it's free and works perfectly):

#### Step 1: Create GitHub Repository
```bash
cd /Users/afwanhaziq/Documents/GitHub/hadis40
git init
git add .
git commit -m "Initial commit"
gh repo create hadis40-web --public --source=. --remote=origin --push
```

#### Step 2: Push Web Build
```bash
# Create gh-pages branch
git checkout --orphan gh-pages
git rm -rf .

# Copy web build
cp -r build/web/* .
git add .
git commit -m "Deploy web build"
git push origin gh-pages
```

#### Step 3: Enable GitHub Pages
1. Go to repository Settings
2. Click "Pages"
3. Source: Deploy from branch
4. Branch: gh-pages / (root)
5. Save

Your app will be at: `https://yourusername.github.io/hadis40-web/`

### Solution 5: Try Different Itch.io Upload Method

Instead of uploading a ZIP:

1. **Use Butler** (Itch.io's command-line tool):
```bash
# Install butler
curl -L -o butler.zip https://broth.itch.ovh/butler/darwin-amd64/LATEST/archive/default
unzip butler.zip

# Login
./butler login

# Push your game
./butler push build/web yourusername/hadis-40-imam-nawawi:html5
```

### Solution 6: Check File Names

Itch.io might block files with certain names. Check if any files have:
- Special characters
- Very long names
- Uppercase/lowercase issues

### Solution 7: Simplify the Build

Try a minimal build without some features:

```bash
flutter build web --release \
  --base-href="/" \
  --no-tree-shake-icons \
  --dart-define=FLUTTER_WEB_USE_SKIA=false
```

## Debugging Steps

### 1. Check Itch.io Dashboard
- Go to your game's dashboard
- Click "Edit game"
- Scroll to "Uploads"
- Check if the file shows "Browser playable" badge

### 2. Check Browser Console
Open F12 and look for:
- Any CORS errors?
- Any CSP (Content Security Policy) errors?
- What's the actual error message?

### 3. Test Locally First
Before uploading, test locally:
```bash
cd build/web
python3 -m http.server 8000
```
Open http://localhost:8000 - Does it work?

### 4. Check Itch.io Status
Visit: https://itch.io/status
Make sure Itch.io services are running normally.

## Alternative Platforms

If Itch.io doesn't work, consider:

1. **GitHub Pages** (Free, easy, recommended)
2. **Netlify** (Free, drag & drop)
3. **Vercel** (Free, automatic deployments)
4. **Firebase Hosting** (Free tier available)

## Quick GitHub Pages Deploy

The easiest solution:

```bash
# From your project root
cd build/web

# Initialize git
git init
git add .
git commit -m "Deploy Hadis 40"

# Create and push to GitHub
gh repo create hadis40-web --public --source=. --push

# Enable Pages
gh api repos/:owner/hadis40-web/pages -X POST -f source[branch]=main -f source[path]=/
```

Your app will be live at: `https://yourusername.github.io/hadis40-web/`

## Files Ready

- `build/hadis40-itch-clean.zip` - Clean version without hidden files
- `build/hadis40-web-with-loader.zip` - Version with loading screen

## Still Not Working?

If none of these work, the issue might be:
1. Itch.io account restrictions
2. Regional blocking
3. Itch.io server issues

**Recommendation**: Use GitHub Pages - it's more reliable for Flutter web apps.

## Contact

If you need help:
- Itch.io Support: https://itch.io/support
- Flutter Web Issues: https://github.com/flutter/flutter/issues


