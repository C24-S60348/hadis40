import 'package:flutter/material.dart';

class SurahCalculatorPage extends StatefulWidget {
  @override
  _SurahCalculatorPageState createState() => _SurahCalculatorPageState();
}

class _SurahCalculatorPageState extends State<SurahCalculatorPage> {
  // Sample surah data - replace with actual surah list
  final List<Map<String, dynamic>> _surahList = [
    {'name': 'Al-Fatihah', 'juz': 1, 'ayat': 7, 'pages': 1, 'checked': false},
    {'name': 'Al-Baqarah', 'juz': 1, 'ayat': 286, 'pages': 48, 'checked': false},
    {'name': 'Ali Imran', 'juz': 3, 'ayat': 200, 'pages': 60, 'checked': false},
    // Add all 114 surahs here with their juz, ayat, and pages
  ];

  int _totalJuz = 0;
  int _totalAyat = 0;
  int _totalSurah = 0;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _calculateTotals();
  }

  void _toggleSurah(int index) {
    setState(() {
      _surahList[index]['checked'] = !_surahList[index]['checked'];
      _calculateTotals();
    });
  }

  void _calculateTotals() {
    _totalJuz = 0;
    _totalAyat = 0;
    _totalSurah = 0;
    _totalPages = 0;

    Set<int> uniqueJuz = {};

    for (var surah in _surahList) {
      if (surah['checked'] == true) {
        _totalSurah++;
        _totalAyat += surah['ayat'] as int;
        _totalPages += surah['pages'] as int;
        uniqueJuz.add(surah['juz'] as int);
      }
    }

    _totalJuz = uniqueJuz.length;
  }

  void _clearAll() {
    setState(() {
      for (var surah in _surahList) {
        surah['checked'] = false;
      }
      _calculateTotals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Surah Calculator',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 52, 21, 104),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all, color: Colors.white),
            onPressed: _clearAll,
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Summary Card
            Container(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'Ringkasan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem('Juz', _totalJuz.toString()),
                      _buildSummaryItem('Ayat', _totalAyat.toString()),
                      _buildSummaryItem('Surah', _totalSurah.toString()),
                      _buildSummaryItem('Halaman', _totalPages.toString()),
                    ],
                  ),
                ],
              ),
            ),
            // Surah List
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: _surahList.length,
                  itemBuilder: (context, index) {
                    final surah = _surahList[index];
                    return CheckboxListTile(
                      title: Text(surah['name']),
                      subtitle: Text(
                        'Juz ${surah['juz']} • ${surah['ayat']} ayat • ${surah['pages']} halaman',
                      ),
                      value: surah['checked'],
                      onChanged: (value) => _toggleSurah(index),
                      activeColor: const Color.fromARGB(255, 52, 21, 104),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 52, 21, 104),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

