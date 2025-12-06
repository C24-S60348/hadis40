# Hadis 40 - Implementation Notes

## ✅ Completed

1. **Package Name Changed**: Changed from `com.af1productions.celiktafsirv3` to `com.af1productions.hadis40`
2. **App Name Updated**: Changed to "Hadis 40" throughout the app
3. **Main Page Created**: Home page with logo, hadith selector (slider +/-), tick button, quote placeholder, settings and favorites buttons
4. **Hadith Reading Page**: Complete reading page with:
   - Hamburger menu (sidebar)
   - Favorite button
   - Next button
   - Title and Arabic title
   - Image display
   - Audio player (play/pause)
   - Bismillah image
   - Hadith images (supports 1 or 2 images)
   - HTML description
   - Font size controls (+/- buttons)
   - Swipe navigation between 42 hadith
5. **Sidebar Menu**: Complete navigation menu with all requested items
6. **All Pages Created**:
   - Panduan Solat Sunat (with next/before navigation)
   - Kata-kata Hikmah (with next/before navigation)
   - Surah Calculator (with checkboxes and summary)
   - Senarai Surau Jumaat (with CSV import support)
   - Settings (Language, Background Color, Font Size, App Info)
   - Bookmarks/Favorites page
7. **Dependencies Added**: audioplayers, csv, path_provider

## 📝 What You Need to Do

### 1. Add Hadith Content
Update `lib/models/hadith.dart` - Replace placeholder data with actual hadith content:
- Update `HadithData.getAllHadith()` method
- Add actual titles, Arabic titles, images, audio files, and HTML descriptions for all 42 hadith
- Ensure image paths match your actual asset files

### 2. Add Assets
Place your assets in the following locations:
- **Images**: `assets/images/`
  - Logo: `logo.png`
  - Background: `bg.jpg`
  - Bismillah: `bismillah.png`
  - Hadith images: `hadith_1.png`, `hadith_1_1.png`, `hadith_1_2.png`, etc.
- **Audio**: `assets/audio/`
  - Hadith audio files: `hadith_1.mp3`, `hadith_2.mp3`, etc.
- **Data**: `assets/data/`
  - CSV file for surau jumaat: `surau_jumaat.csv`

### 3. Add Quotes
Update `lib/services/hadith_service.dart`:
- Replace placeholder quotes in `getRandomQuote()` method
- Or use `HadithService.saveQuotes()` to save quotes programmatically

### 4. Add Solat Sunat Content
Update `lib/views/panduan_solat_sunat.dart`:
- Replace placeholder data in `_solatSunatList` with actual solat sunat content

### 5. Add Kata-kata Hikmah Content
Update `lib/views/kata_kata_hikmah.dart`:
- Replace placeholder quotes in `_loadQuotes()` method with actual quotes

### 6. Add Surah Data
Update `lib/views/surah_calculator.dart`:
- Replace placeholder `_surahList` with all 114 surahs with their juz, ayat, and pages data

### 7. Add CSV File
Create `assets/data/surau_jumaat.csv` with columns:
- Nama Surau
- Alamat
- Bandar
- Negeri
(Or adjust the code to match your CSV structure)

### 8. Update Information Page
Update `lib/views/information.dart` with your app's update log/help content

## 🎨 Asset Structure Expected

```
assets/
├── images/
│   ├── logo.png
│   ├── bg.jpg
│   ├── bismillah.png
│   ├── hadith_1.png
│   ├── hadith_1_1.png
│   ├── hadith_1_2.png (if applicable)
│   ├── hadith_2.png
│   └── ... (for all 42 hadith)
├── audio/
│   ├── hadith_1.mp3
│   ├── hadith_2.mp3
│   └── ... (for all 42 hadith)
└── data/
    └── surau_jumaat.csv
```

## 📱 Features Implemented

- ✅ Hadith selector with slider (1-42)
- ✅ Reading page with audio playback
- ✅ Swipe navigation between hadith
- ✅ Favorites/Bookmarks system
- ✅ Font size adjustment
- ✅ Random quotes (placeholder ready)
- ✅ Sidebar navigation
- ✅ All requested pages
- ✅ Settings with language, background color, font size
- ✅ CSV import for surau jumaat

## 🚀 Next Steps

1. Run `flutter pub get` to install dependencies
2. Add your assets to the assets folder
3. Update hadith content in `lib/models/hadith.dart`
4. Update other content as needed
5. Test the app
6. Build and deploy

## 📝 Notes

- The app structure supports 42 hadith (as requested)
- Audio player is ready but needs actual audio files
- CSV reader is ready but needs the CSV file
- All pages have placeholder content that needs to be replaced
- The quote system rotates through quotes each time the app opens

