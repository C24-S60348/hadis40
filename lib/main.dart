import 'package:flutter/material.dart';
import 'views/splashscreen.dart';
import 'views/home_page.dart';
import 'views/hadith_reading_page.dart';
import 'views/bookmarks.dart';
import 'views/settings.dart';
import 'views/panduan_solat_sunat.dart';
import 'views/kata_kata_hikmah.dart';
import 'views/surah_calculator.dart';
import 'views/senarai_surau_jumaat.dart';
import 'views/information.dart';
import 'views/about_hadis40.dart';
import 'utils/uihelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hadis 40 Imam Nawawi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      onGenerateRoute: (settings) {
        Widget page;
        
        switch (settings.name) {
          case '/home':
            page = HomePage();
            break;
          case '/hadith-reading':
            page = HadithReadingPage();
            break;
          case '/bookmarks':
            page = BookmarksPage();
            break;
          case '/settings':
            page = SettingsPage();
            break;
          case '/panduan-solat-sunat':
            page = PanduanSolatSunatPage();
            break;
          case '/kata-kata-hikmah':
            page = KataKataHikmahPage();
            break;
          case '/surah-calculator':
            page = SurahCalculatorPage();
            break;
          case '/senarai-surau-jumaat':
            page = SenaraiSurauJumaatPage();
            break;
          case '/info':
            page = InformationPage();
            break;
          case '/about-hadis40':
            page = AboutHadis40Page();
            break;
          default:
            page = SplashScreen();
        }
        
        return slideRoute(page, arguments: settings.arguments);
      },
      home: SplashScreen(),
    );
  }
}

