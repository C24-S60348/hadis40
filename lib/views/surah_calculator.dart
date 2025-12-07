import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../utils/app_constants.dart';

class SurahCalculatorPage extends StatefulWidget {
  @override
  _SurahCalculatorPageState createState() => _SurahCalculatorPageState();
}

class _SurahCalculatorPageState extends State<SurahCalculatorPage> {
  List<Map<String, dynamic>> _surahList = [];
  bool _isLoading = true;

  int _totalJuz = 0;
  int _totalAyat = 0;
  int _totalSurah = 0;
  double _totalPages = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSurahData();
  }

  Future<void> _loadSurahData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/surahcalculator.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> surahsData = jsonData['surahs'] ?? [];
      
      setState(() {
        _surahList = surahsData.map((surah) {
          // Convert juz to proper format (handle both int and List)
          dynamic juz = surah['juz'];
          if (juz is List) {
            juz = juz.map((j) => _toInt(j)).toList();
          } else {
            juz = _toInt(juz);
          }
          
          return {
            'name': surah['name']?.toString() ?? '',
            'juz': juz,
            'ayat': _toInt(surah['ayat']),
            'pages': _toDouble(surah['pages']),
            'checked': false,
          };
        }).toList();
        _isLoading = false;
        _calculateTotals();
      });
    } catch (e) {
      print('Error loading surah data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleSurah(int index) {
    setState(() {
      _surahList[index]['checked'] = !_surahList[index]['checked'];
      _calculateTotals();
    });
  }

  // Helper function to safely convert number to int (handles both int and double)
  int _toInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is double) {
      return value.round();
    } else if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  // Helper function to safely convert number to double (keep full precision from JSON)
  double _toDouble(dynamic value) {
    if (value is double) {
      return value; // Keep original precision
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  void _calculateTotals() {
    _totalJuz = 0;
    _totalAyat = 0;
    _totalSurah = 0;
    _totalPages = 0.0;

    Set<int> uniqueJuz = {};

    for (var surah in _surahList) {
      if (surah['checked'] == true) {
        _totalSurah++;
        _totalAyat += _toInt(surah['ayat']);
        _totalPages += _toDouble(surah['pages']);
        
        // Handle juz - can be int or List<int>
        if (surah['juz'] is int) {
          uniqueJuz.add(_toInt(surah['juz']));
        } else if (surah['juz'] is List) {
          for (var juz in surah['juz'] as List) {
            uniqueJuz.add(_toInt(juz));
          }
        }
      }
    }

    _totalJuz = uniqueJuz.length;
    
    // Keep full precision for calculation, round to 1 decimal only for display
    // Don't round here, let display handle it
  }

  bool get _allSelected {
    if (_surahList.isEmpty) return false;
    return _surahList.every((surah) => surah['checked'] == true);
  }

  void _toggleSelectAll() {
    setState(() {
      final shouldSelectAll = !_allSelected;
      for (var surah in _surahList) {
        surah['checked'] = shouldSelectAll;
      }
      _calculateTotals();
    });
  }

  String _getJuzDisplay(dynamic juz) {
    if (juz is int) {
      return juz.toString();
    } else if (juz is List) {
      return juz.join(', ');
    }
    return '';
  }

  String _formatNumber(dynamic value) {
    if (value is double) {
      // Round to 1 decimal place for display
      return value.toStringAsFixed(1);
    } else if (value is int) {
      return value.toString();
    }
    return value.toString();
  }

  // Format total pages for display (rounds 0.99 to 1.0)
  String _formatTotalPages(double value) {
    // Round to 1 decimal place
    return value.toStringAsFixed(1);
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
        backgroundColor: AppConstants.appBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _allSelected ? Icons.clear_all : Icons.select_all,
              color: Colors.white,
            ),
            onPressed: _toggleSelectAll,
            tooltip: _allSelected ? 'Clear All' : 'Select All',
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
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppConstants.appBarColor,
                ),
              )
            : Column(
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
                            _buildSummaryItem('Halaman', _formatTotalPages(_totalPages)),
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
                              'Juz ${_getJuzDisplay(surah['juz'])} • ${surah['ayat']} ayat • ${_formatNumber(surah['pages'])} halaman',
                            ),
                            value: surah['checked'],
                            onChanged: (value) => _toggleSurah(index),
                            activeColor: AppConstants.appBarColor,
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
            color: AppConstants.appBarColor,
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
