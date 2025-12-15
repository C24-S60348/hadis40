import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/app_constants.dart';

class InformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informasi', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppConstants.appBarColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/bg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tentang Aplikasi',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),

                    Divider(color: Colors.black),
                    SizedBox(height: 10),
                    
                    Text(
                      'Aplikasi Hadis 40 ini dibangunkan untuk memudahkan umat Islam mempelajari dan menghafal koleksi hadis yang mulia ini. Dengan antara muka yang mudah dan kandungan yang lengkap, semoga aplikasi ini dapat membantu dalam perjalanan menuntut ilmu agama.\n\n'
                      'Ciri-ciri aplikasi:\n'
                      '▪42 hadis pilihan Imam Nawawi lengkap\n'
                      '▪Teks hadis dengan terjemahan dan penjelasan\n'
                      '▪Audio bacaan hadis\n'
                      '▪Fungsi bookmark untuk hadis kegemaran\n'
                      '▪Saiz font boleh diubah mengikut kesesuaian\n'
                      '▪Kata-kata hikmah dari Al-Quran\n'
                      '▪Panduan solat sunat\n'
                      '▪Kalkulator surah\n'
                      '▪Boleh digunakan secara offline\n\n'
                      'Semoga dengan aplikasi ini, kita dapat lebih mendekatkan diri kepada sunnah Rasulullah ﷺ dan mengamalkan ajaran Islam dengan lebih baik.',
                      style: TextStyle(fontSize: 16, height: 1.6),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.black),
                    SizedBox(height: 10),
                    Text(
                      'Versi: 3.0.16',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Divider(color: Colors.black),
                    SizedBox(height: 10),
                    Text(
                      'Sebarang pertanyaan, saran, sila hubungi: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrl(Uri.parse('mailto:af1gaming01@gmail.com'));
                      },
                      child: Center(
                        child: Text(
                          'af1gaming01@gmail.com',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 51, 135, 54), decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
