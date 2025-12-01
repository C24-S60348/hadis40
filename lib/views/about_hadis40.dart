import 'package:flutter/material.dart';
import '../utils/app_constants.dart';

class AboutHadis40Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Hadis 40', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: AppConstants.appBarColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
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
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Center(
                      child: Text(
                        'الأربعون النووية',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.appBarColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Center(
                      child: Text(
                        'Hadis 40 Imam Nawawi',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.appBarColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(color: AppConstants.appBarColor, thickness: 2),
                    SizedBox(height: 20),

                    // Pengenalan
                    _buildSectionTitle('Apa itu Hadis 40 Imam Nawawi?'),
                    SizedBox(height: 10),
                    _buildParagraph(
                      'Hadis 40 Imam Nawawi atau dikenali sebagai "Al-Arba\'in An-Nawawiyyah" (الأربعون النووية) adalah koleksi 42 hadis pilihan yang dikumpulkan oleh Imam Yahya bin Syaraf An-Nawawi (631-676 H / 1233-1277 M).'
                    ),
                    _buildParagraph(
                      'Walaupun dinamakan "40 Hadis", koleksi ini sebenarnya mengandungi 42 hadis kerana dua hadis terakhir ditambah oleh ulama kemudian untuk melengkapkan karya Imam Nawawi.'
                    ),
                    SizedBox(height: 20),

                    // Tentang Imam Nawawi
                    _buildSectionTitle('Siapakah Imam Nawawi?'),
                    SizedBox(height: 10),
                    _buildParagraph(
                      'Nama penuh beliau ialah Abu Zakariya Muhyiddin Yahya bin Syaraf An-Nawawi. Beliau dilahirkan di Nawa, Syria pada tahun 631 Hijrah. Imam Nawawi adalah seorang ulama hadis, fiqh, dan tasawuf yang terkenal dalam mazhab Syafi\'i.'
                    ),
                    _buildParagraph(
                      'Antara karya beliau yang masyhur termasuklah Riyadhus Salihin, Syarah Sahih Muslim, Al-Majmu\' Syarh Al-Muhazzab, dan tentunya Hadis 40 ini.'
                    ),
                    SizedBox(height: 20),

                    // Muqaddimah
                    _buildSectionTitle('Muqaddimah (Pendahuluan)'),
                    SizedBox(height: 10),
                    _buildParagraph(
                      'Dalam muqaddimah kitab ini, Imam Nawawi menyatakan:'
                    ),
                    SizedBox(height: 10),
                    _buildQuoteBox(
                      'Telah meriwayatkan kepada kami Ali bin Abi Talib, Abdullah bin Mas\'ud, Muaz bin Jabal, Abu Darda\', Ibnu Umar, Ibnu Abbas, Anas bin Malik, Abu Hurairah, dan Abu Said Al-Khudri radhiyallahu \'anhum dari Nabi ﷺ bahawa baginda bersabda:\n\n'
                      '"Barangsiapa yang menghafal dan memelihara untuk umatku 40 hadis yang berkaitan dengan perkara agama mereka, maka Allah akan membangkitkannya pada hari kiamat dalam golongan ahli fiqh dan ulama."'
                    ),
                    SizedBox(height: 10),
                    _buildParagraph(
                      'Walaupun sanad hadis ini lemah, namun ramai ulama telah mengamalkan kandungannya dengan menyusun koleksi 40 hadis, termasuk Imam Nawawi.'
                    ),
                    SizedBox(height: 20),

                    // Kepentingan
                    _buildSectionTitle('Kepentingan Hadis 40 Imam Nawawi'),
                    SizedBox(height: 10),
                    _buildBulletPoint('Setiap hadis dalam koleksi ini merupakan "Qaidah Azimah" (asas besar) dalam agama Islam'),
                    _buildBulletPoint('Mencakupi pelbagai aspek kehidupan Muslim: akidah, ibadah, muamalat, akhlak, dan adab'),
                    _buildBulletPoint('Mudah dihafal dan difahami oleh semua peringkat'),
                    _buildBulletPoint('Menjadi rujukan utama dalam pengajian hadis di seluruh dunia'),
                    _buildBulletPoint('Telah disyarah oleh ratusan ulama sepanjang zaman'),
                    SizedBox(height: 20),

                    // Kata-kata Imam Nawawi
                    _buildSectionTitle('Kata-kata Imam Nawawi'),
                    SizedBox(height: 10),
                    _buildQuoteBox(
                      'Imam Nawawi berkata:\n\n'
                      '"Sesungguhnya para ulama - semoga Allah merahmati mereka - telah menyusun dalam hal ini (mengumpulkan 40 hadis) karya-karya yang banyak. Maka terdoronglah hatiku untuk menyusun 40 hadis, mengikuti jejak mereka, dengan harapan mendapat kebaikan yang mereka harapkan."\n\n'
                      '"Dan aku memilih untuk mengumpulkan 40 hadis yang lebih utama daripada semua yang telah mereka kumpulkan, iaitu setiap hadis daripadanya merupakan asas besar dari asas-asas agama, dan para ulama telah mengatakan bahawa agama Islam berputar padanya, atau ia adalah separuh Islam, atau sepertiganya atau yang seumpama dengannya."'
                    ),
                    SizedBox(height: 20),

                    // Kandungan Hadis
                    _buildSectionTitle('Kandungan Hadis 40'),
                    SizedBox(height: 10),
                    _buildParagraph(
                      'Antara hadis-hadis penting dalam koleksi ini:'
                    ),
                    SizedBox(height: 10),
                    _buildNumberedPoint('1', 'Hadis Niat - "Sesungguhnya setiap amalan bergantung kepada niat"'),
                    _buildNumberedPoint('2', 'Hadis Jibril - Tentang Islam, Iman, dan Ihsan'),
                    _buildNumberedPoint('3', 'Hadis Rukun Islam - Lima rukun Islam'),
                    _buildNumberedPoint('5', 'Hadis Bid\'ah - Menolak perkara yang diada-adakan dalam agama'),
                    _buildNumberedPoint('6', 'Hadis Halal dan Haram - Perkara yang jelas dan syubhat'),
                    _buildNumberedPoint('16', 'Hadis Jangan Marah - Nasihat ringkas namun padat'),
                    _buildNumberedPoint('42', 'Hadis Kasih Sayang Allah - Menutup dengan hadis Qudsi yang indah'),
                    SizedBox(height: 20),

                    // Penutup
                    _buildSectionTitle('Kesimpulan'),
                    SizedBox(height: 10),
                    _buildParagraph(
                      'Hadis 40 Imam Nawawi adalah permata dalam khazanah ilmu Islam. Ia merangkumi intipati ajaran Islam dalam bentuk yang ringkas namun komprehensif. Menghafal dan memahami hadis-hadis ini adalah satu pencapaian besar dalam perjalanan menuntut ilmu agama.'
                    ),
                    _buildParagraph(
                      'Semoga aplikasi ini dapat membantu kita semua untuk lebih mendekatkan diri kepada sunnah Rasulullah ﷺ dan mengamalkan ajaran Islam dengan lebih baik.'
                    ),
                    SizedBox(height: 30),

                    // Footer
                    Divider(color: AppConstants.appBarColor, thickness: 2),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.appBarColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppConstants.appBarColor,
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Colors.black87,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildQuoteBox(String text) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppConstants.appBarColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppConstants.appBarColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          height: 1.8,
          fontStyle: FontStyle.italic,
          color: Colors.black87,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppConstants.appBarColor,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedPoint(String number, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            child: Text(
              '$number.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppConstants.appBarColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

