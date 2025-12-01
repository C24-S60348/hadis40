import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'Bahasa Melayu';
  String _selectedBackgroundColor = 'Default';
  double _fontSize = 16.0;
  bool _isInitialized = false;

  final List<String> _languageOptions = [
    'Bahasa Melayu',
    'English',
    'العربية',
  ];

  final List<Map<String, dynamic>> _backgroundColorOptions = [
    {'name': 'Putih', 'color': Colors.white},
    {'name': 'Hitam', 'color': Colors.black},
    {'name': 'Kuning Perak', 'color': Color(0xFFF5F5DC)},
    {'name': 'Biru Muda', 'color': Color(0xFFE3F2FD)},
    {'name': 'Hijau Muda', 'color': Color(0xFFE8F5E9)},
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selected_language') ?? 'Bahasa Melayu';
      _selectedBackgroundColor = prefs.getString('selected_background_color') ?? 'Default';
      _fontSize = prefs.getDouble('font_size') ?? 16.0;
      _isInitialized = true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', _selectedLanguage);
    await prefs.setString('selected_background_color', _selectedBackgroundColor);
    await prefs.setDouble('font_size', _fontSize);
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Bahasa'),
          content: SingleChildScrollView(
            child: Column(
              children: _languageOptions.map((language) {
                return RadioListTile<String>(
                  title: Text(language),
                  value: language,
                  groupValue: _selectedLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLanguage = value!;
                    });
                    _saveSettings();
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showBackgroundColorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih warna latar belakang'),
          content: SingleChildScrollView(
            child: Column(
              children: _backgroundColorOptions.map((option) {
                return RadioListTile<String>(
                  title: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: option['color'] as Color,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(option['name']),
                    ],
                  ),
                  value: option['name'],
                  groupValue: _selectedBackgroundColor,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedBackgroundColor = value!;
                    });
                    _saveSettings();
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showHowToUse() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cara Menggunakan'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Pilih Surah',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Tap pada surah yang ingin dibaca'),
                SizedBox(height: 10),
                Text(
                  '2. Navigasi Halaman',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Gunakan tombol panah untuk berpindah halaman'),
                SizedBox(height: 10),
                Text(
                  '3. Bookmark',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Tap ikon bookmark untuk menyimpan halaman'),
                SizedBox(height: 10),
                Text(
                  '4. Pengaturan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Ubah font, ukuran, dan tema sesuai preferensi'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tutup'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/tutorial'),
              child: Text('Tutorial'),
            ),
          ],
        );
      },
    );
  }

  void _resetFontSize() {
    setState(() {
      _fontSize = 16.0;
    });
    _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Pengaturan'),
          backgroundColor: const Color.fromARGB(255, 52, 21, 104),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengaturan',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 52, 21, 104),
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
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Language Selection
                // Container(
                //   padding: EdgeInsets.all(16.0),
                //   decoration: BoxDecoration(
                //     color: Colors.white.withOpacity(0.9),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'Pilih Bahasa',
                //         style: TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.black,
                //         ),
                //       ),
                //       SizedBox(height: 10),
                //       InkWell(
                //         onTap: _showLanguageDialog,
                //         child: Container(
                //           padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                //           decoration: BoxDecoration(
                //             border: Border.all(color: Colors.grey),
                //             borderRadius: BorderRadius.circular(8),
                //           ),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Text(_selectedLanguage),
                //               Icon(Icons.arrow_drop_down),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: 16),

                // Background Color Selection
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih warna latar belakang',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: _showBackgroundColorDialog,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: _backgroundColorOptions.firstWhere(
                                        (opt) => opt['name'] == _selectedBackgroundColor,
                                        orElse: () => _backgroundColorOptions[0],
                                      )['color'] as Color,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(_selectedBackgroundColor),
                                ],
                              ),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Font Size
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Saiz Tulisan'),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            ),
                            onPressed: _resetFontSize,
                            child: Text('Reset'),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('Kecil'),
                          Expanded(
                            child: Slider(
                              value: _fontSize,
                              min: 12.0,
                              max: 24.0,
                              divisions: 12,
                              onChanged: (value) {
                                setState(() {
                                  _fontSize = value;
                                });
                                _saveSettings();
                              },
                            ),
                          ),
                          Text('Besar'),
                        ],
                      ),
                      Center(
                        child: Text(
                          'Saiz: ${_fontSize.round()}',
                          style: TextStyle(fontSize: _fontSize),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // // Theme Selection
                // Container(
                //   padding: EdgeInsets.all(16.0),
                //   decoration: BoxDecoration(
                //     color: Colors.white.withOpacity(0.9),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'Tema',
                //         style: TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.black,
                //         ),
                //       ),
                //       SizedBox(height: 10),
                //       InkWell(
                //         onTap: _showThemeDialog,
                //         child: Container(
                //           padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                //           decoration: BoxDecoration(
                //             border: Border.all(color: Colors.grey),
                //             borderRadius: BorderRadius.circular(8),
                //           ),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Text(_selectedTheme),
                //               Icon(Icons.arrow_drop_down),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(height: 16),

                // App Info
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Maklumat Aplikasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Made by: AF1 Productions',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'App Version: 1.0.0',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
