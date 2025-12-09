import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';

import '../utils/app_constants.dart';

class PanduanSolatSunatPage extends StatefulWidget {
  @override
  _PanduanSolatSunatPageState createState() => _PanduanSolatSunatPageState();
}

class _PanduanSolatSunatPageState extends State<PanduanSolatSunatPage> {
  int _currentPage = 0;
  bool _isLoading = true;
  List<Map<String, String>> _solatSunatList = [];

  @override
  void initState() {
    super.initState();
    _loadSolatSunat();
  }

  Future<void> _loadSolatSunat() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/solatsunat.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> items = jsonData['solat_sunat'] ?? [];

      setState(() {
        _solatSunatList = items
            .map((e) => {
                  'title': e['name']?.toString() ?? '',
                  'content': e['content']?.toString() ?? '',
                })
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading solat sunat data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _nextPage() {
    if (_currentPage < _solatSunatList.length - 1) {
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Panduan Solat Sunat',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppConstants.appBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
            : _solatSunatList.isEmpty
                ? Center(
                    child: Text(
                      'Tiada kandungan',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(16),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _solatSunatList[_currentPage]['title'] ?? '',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Html(
                                  data: _solatSunatList[_currentPage]['content'] ?? '',
                                  style: {
                                    'body': Style(
                                      fontSize: FontSize(16),
                                      color: Colors.black87,
                                    ),
                                    'p': Style(
                                      fontSize: FontSize(16),
                                      color: Colors.black87,
                                      margin: Margins.only(bottom: 12),
                                    ),
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Navigation buttons
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: _currentPage > 0 ? _previousPage : null,
                              icon: Icon(Icons.arrow_back),
                              label: Text('Sebelum'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.appBarColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            Text(
                              '${_currentPage + 1} / ${_solatSunatList.length}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _currentPage < _solatSunatList.length - 1
                                  ? _nextPage
                                  : null,
                              icon: Icon(Icons.arrow_forward),
                              label: Text('Seterusnya'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.appBarColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

