import 'package:flutter/material.dart';

/// App-wide constants for colors, strings, and other reusable values
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // ==================== COLORS ====================
  
  /// Primary app bar color (Green)
  static const Color appBarColor = Color.fromARGB(255, 20, 77, 21);
  
  /// Old purple color (kept for reference if needed)
  static const Color oldPurpleColor = Color.fromARGB(255, 52, 21, 104);
  
  /// Background colors
  static const Color backgroundColor = Colors.black;
  
  /// Button colors
  static const Color greenButtonColor = Colors.green;
  static const Color blueButtonColor = Colors.blue;
  static const Color redButtonColor = Colors.red;
  
  /// Text colors
  static const Color whiteTextColor = Colors.white;
  static const Color blackTextColor = Colors.black;
  static const Color black87TextColor = Colors.black87;
  
  /// Icon colors
  static const Color whiteIconColor = Colors.white;
  static const Color blackIconColor = Colors.black;
  
  // ==================== STRINGS ====================
  
  /// App name
  static const String appName = 'Hadis 40';
  
  /// Menu items
  static const String menuHome = 'Home';
  static const String menuPanduanSolat = 'Panduan Solat Sunat';
  static const String menuKataKataHikmah = 'Kata-kata Hikmah';
  static const String menuSurahCalculator = 'Surah Calculator';
  static const String menuSenaraiSurau = 'Senarai Surau Jumaat';
  static const String menuSettings = 'Settings';
  static const String menuFavourite = 'Favourite';
  static const String menuShare = 'Share';
  static const String menuHelp = 'Help (Update Log)';
  static const String menuExit = 'Exit app';
  
  /// Button labels
  static const String buttonTetapan = 'Tetapan';
  static const String buttonFavoritSaya = 'Favorit Saya';
  static const String buttonBatal = 'Batal';
  static const String buttonKeluar = 'Keluar';
  
  /// Messages
  static const String exitDialogTitle = 'Keluar Aplikasi';
  static const String exitDialogMessage = 'Adakah anda pasti ingin keluar?';
  static const String shareMessage = 'Share functionality - to be implemented';
  
  // ==================== NUMBERS ====================
  
  /// Hadith count
  static const int totalHadithCount = 42;
  static const int minHadithNumber = 1;
  static const int maxHadithNumber = 42;
  
  /// Font sizes
  static const double defaultFontSize = 16.0;
  static const double minFontSize = 12.0;
  static const double maxFontSize = 32.0;
  static const double fontSizeIncrement = 2.0;
  
  // ==================== ASSET PATHS ====================
  
  /// Images
  static const String logoImage = 'assets/images/logo.png';
  static const String backgroundImage = 'assets/images/bg.jpg';
  static const String bismillahImage = 'assets/images/bismillah.png';
  
  /// Data files
  static const String hadithDataFile = 'assets/data/hadis40.json';
  static const String kataKataHikmahDataFile = 'assets/data/katakatahikmah.json';
  
  // ==================== ROUTES ====================
  
  static const String routeHome = '/home';
  static const String routeHadithReading = '/hadith-reading';
  static const String routeSettings = '/settings';
  static const String routeBookmarks = '/bookmarks';
  static const String routeKataKataHikmah = '/kata-kata-hikmah';
  static const String routePanduanSolatSunat = '/panduan-solat-sunat';
  static const String routeSurahCalculator = '/surah-calculator';
  static const String routeSenaraiSurauJumaat = '/senarai-surau-jumaat';
  static const String routeInfo = '/info';
  static const String routeAboutHadis40 = '/about-hadis40';
}

