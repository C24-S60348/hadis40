import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../services/kata_kata_hikmah_loader.dart';
import '../models/kata_kata_hikmah.dart';

class KataKataHikmahPage extends StatefulWidget {
  @override
  _KataKataHikmahPageState createState() => _KataKataHikmahPageState();
}

class _KataKataHikmahPageState extends State<KataKataHikmahPage> {
  int _currentIndex = 0;
  List<KataKataHikmah> _quotes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    try {
      final quotes = await KataKataHikmahLoader.loadQuotes();
      setState(() {
        _quotes = quotes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading quotes: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _nextQuote() {
    if (_currentIndex < _quotes.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void _previousQuote() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kata-kata Hikmah',
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
            ? Center(child: CircularProgressIndicator())
            : _quotes.isEmpty
                ? Center(
                    child: Text(
                      'Tiada kata-kata hikmah',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.all(20),
                            padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _quotes[_currentIndex].kutipan,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black87,
                                    height: 1.6,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppConstants.appBarColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _quotes[_currentIndex].sumber,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppConstants.appBarColor,
                                    ),
                                  ),
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
                              onPressed: _currentIndex > 0 ? _previousQuote : null,
                              icon: Icon(Icons.arrow_back),
                              label: Text('Sebelum'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.appBarColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            Text(
                              '${_currentIndex + 1} / ${_quotes.length}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _currentIndex < _quotes.length - 1
                                  ? _nextQuote
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

