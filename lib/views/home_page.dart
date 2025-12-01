import 'package:flutter/material.dart';
import '../services/hadith_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedHadithNumber = 1;
  String _randomQuote = '';
  bool _isLoadingQuote = true;

  @override
  void initState() {
    super.initState();
    _loadRandomQuote();
  }

  Future<void> _loadRandomQuote() async {
    final quote = await HadithService.getRandomQuote();
    setState(() {
      _randomQuote = quote;
      _isLoadingQuote = false;
    });
  }

  void _decrementHadith() {
    if (_selectedHadithNumber > 1) {
      setState(() {
        _selectedHadithNumber--;
      });
    }
  }

  void _incrementHadith() {
    if (_selectedHadithNumber < 42) {
      setState(() {
        _selectedHadithNumber++;
      });
    }
  }

  void _navigateToHadith() {
    Navigator.of(context).pushNamed(
      '/hadith-reading',
      arguments: {'hadithNumber': _selectedHadithNumber},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          // color: Colors.black,
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Logo
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 240,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.mosque, size: 120, color: Colors.white);
                  },
                ),
              ),

              Spacer(),

              Column(
                children: [
                  Text(
                    'Pilih nombor Hadis',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 10),

                  // Hadith number display
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        136,
                        202,
                        138,
                      ).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '$_selectedHadithNumber',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Slider and +/- buttons
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        // Minus button
                        IconButton(
                          onPressed: _decrementHadith,
                          icon: Icon(
                            Icons.remove_circle,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),

                        // Slider
                        Expanded(
                          child: Slider(
                            value: _selectedHadithNumber.toDouble(),
                            min: 1,
                            max: 42,
                            divisions: 41,
                            label: '$_selectedHadithNumber',
                            onChanged: (value) {
                              setState(() {
                                _selectedHadithNumber = value.round();
                              });
                            },
                            activeColor: Colors.green,
                          ),
                        ),

                        // Plus button
                        IconButton(
                          onPressed: _incrementHadith,
                          icon: Icon(
                            Icons.add_circle,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),

                  // Tick/Green button
                  ElevatedButton(
                    onPressed: _navigateToHadith,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Icon(Icons.check, color: Colors.black, size: 40),
                  ),

                  SizedBox(height: 10),

                  // Random Quote placeholder
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: _isLoadingQuote
                        ? CircularProgressIndicator()
                        : Text(
                            _randomQuote,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.black87,
                            ),
                          ),
                  ),

                  // Spacer(),

                  // Settings and Favorites buttons
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Settings button
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/settings');
                          },
                          icon: Icon(Icons.settings, color: Colors.white),
                          label: Text(
                            'Tetapan',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),

                        // Favorites button
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/bookmarks');
                          },
                          icon: Icon(Icons.favorite, color: Colors.white),
                          label: Text(
                            'Favorit Saya',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
