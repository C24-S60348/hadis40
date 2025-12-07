import 'package:flutter/material.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';

class NavigationService {
  // Navigate to a specific route
  static void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  // Navigate and replace current route
  static void navigateReplaceTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }

  // Pop current route
  static void goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Navigate to home
  static void goToHome(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  // Navigate to hadith reading page
  static void goToHadithReading(BuildContext context, int hadithNumber) {
    Navigator.of(context).pushNamed(
      '/hadith-reading',
      arguments: {'hadithNumber': hadithNumber},
    );
  }

  // Navigate to settings
  static void goToSettings(BuildContext context) {
    Navigator.of(context).pushNamed('/settings');
  }

  // Navigate to bookmarks/favorites
  static void goToBookmarks(BuildContext context) {
    Navigator.of(context).pushNamed('/bookmarks');
  }

  // Navigate to kata-kata hikmah
  static void goToKataKataHikmah(BuildContext context) {
    Navigator.of(context).pushNamed('/kata-kata-hikmah');
  }

  // Navigate to panduan solat sunat
  static void goToPanduanSolatSunat(BuildContext context) {
    Navigator.of(context).pushNamed('/panduan-solat-sunat');
  }

  // Navigate to surah calculator
  static void goToSurahCalculator(BuildContext context) {
    Navigator.of(context).pushNamed('/surah-calculator');
  }

  // Navigate to senarai surau jumaat
  static void goToSenaraiSurauJumaat(BuildContext context) {
    Navigator.of(context).pushNamed('/senarai-surau-jumaat');
  }

  // Navigate to info/help
  static void goToInfo(BuildContext context) {
    Navigator.of(context).pushNamed('/info');
  }

  // Navigate to about hadis 40
  static void goToAboutHadis40(BuildContext context) {
    Navigator.of(context).pushNamed('/about-hadis40');
  }

  // Show share dialog
  static void showShareDialog(BuildContext context) {
    const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.af1productions.hadis40&hl=ms';
    Share.share(
      playStoreUrl,
      subject: 'Hadis 40 - Aplikasi Hadis 40 Imam Nawawi',
    );
  }

  // Show exit confirmation dialog
  static void showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Keluar Aplikasi'),
          content: Text('Adakah anda pasti ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                exit(0);
              },
              child: Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  // Open drawer
  static void openDrawer(GlobalKey<ScaffoldState> scaffoldKey) {
    scaffoldKey.currentState?.openDrawer();
  }

  // Close drawer
  static void closeDrawer(BuildContext context) {
    Navigator.of(context).pop();
  }
}

