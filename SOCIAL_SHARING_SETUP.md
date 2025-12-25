# Social Sharing Setup ✅

## What's Been Added:

Your website now has proper **Open Graph** and **Twitter Card** meta tags for beautiful social media sharing!

## When You Share Your Link:

**URL**: https://c24-s60348.github.io/hadis40-web/

### On Facebook, WhatsApp, LinkedIn:
- ✅ **Title**: Hadis 40 Imam Nawawi
- ✅ **Description**: Aplikasi pembelajaran 40 Hadis Imam Nawawi lengkap dengan terjemahan, penjelasan, dan audio bacaan hadis
- ✅ **Image**: Your Hadis 40 logo (512x512px)

### On Twitter:
- ✅ **Card Type**: Large image card
- ✅ **Title**: Hadis 40 Imam Nawawi
- ✅ **Description**: Full description with features
- ✅ **Image**: Your logo

### Browser Tab:
- ✅ **Favicon**: Your Hadis 40 logo
- ✅ **Title**: Hadis 40 Imam Nawawi - Aplikasi Pembelajaran Hadis

## Deploy to GitHub Pages:

```bash
cd build/web
git add .
git commit -m "Add social sharing meta tags and icons"
git push origin gh-pages
```

## Test Your Sharing:

### Facebook/WhatsApp Debugger:
1. Go to: https://developers.facebook.com/tools/debug/
2. Enter: https://c24-s60348.github.io/hadis40-web/
3. Click "Scrape Again" to refresh cache
4. You'll see your logo and description!

### Twitter Card Validator:
1. Go to: https://cards-dev.twitter.com/validator
2. Enter: https://c24-s60348.github.io/hadis40-web/
3. Preview your card!

### LinkedIn Post Inspector:
1. Go to: https://www.linkedin.com/post-inspector/
2. Enter: https://c24-s60348.github.io/hadis40-web/
3. Click "Inspect"

## What's Included:

### Meta Tags Added:
- ✅ Open Graph (Facebook, WhatsApp, LinkedIn)
- ✅ Twitter Cards
- ✅ Description and keywords for SEO
- ✅ Multiple favicon sizes
- ✅ Apple touch icon
- ✅ Proper page title

### Images Used:
- **Logo**: `icons/Icon-512.png` (your Hadis 40 logo)
- **Favicon**: `favicon.png` (your logo)
- **Apple Touch Icon**: `icons/Icon-192.png`

## File Locations:

All updated in:
- `web/index.html` - Meta tags
- `web/manifest.json` - App name and colors
- `web/favicon.png` - Your logo
- `web/icons/*` - All icon sizes

## Next Steps:

1. **Deploy** the new build to GitHub Pages
2. **Test** sharing on social media
3. **Clear cache** if needed (use debugger tools above)

## Example Share Preview:

```
┌─────────────────────────────────────┐
│  [Your Hadis 40 Logo - 512x512]    │
│                                     │
│  Hadis 40 Imam Nawawi              │
│  Aplikasi pembelajaran 40 Hadis     │
│  Imam Nawawi lengkap dengan...     │
│                                     │
│  c24-s60348.github.io              │
└─────────────────────────────────────┘
```

## Troubleshooting:

**Issue**: Old image/title showing when sharing
**Solution**: 
1. Use Facebook Debugger to scrape again
2. Clear browser cache
3. Wait a few minutes for cache to expire

**Issue**: Image not showing
**Solution**:
1. Make sure you pushed the latest build
2. Check image URL directly: https://c24-s60348.github.io/hadis40-web/icons/Icon-512.png
3. Image must be accessible publicly

## Build Command Reference:

```bash
flutter build web --release --base-href="/hadis40-web/"
```

---

🎉 Your app is now ready for beautiful social media sharing!

