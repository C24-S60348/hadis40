import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/hadith.dart' as hadithModel;
import '../services/hadith_service.dart';
import '../services/hadith_data_loader.dart';
import '../services/sidebar_menu.dart';
import '../utils/app_constants.dart';

class HadithReadingPage extends StatefulWidget {
  @override
  _HadithReadingPageState createState() => _HadithReadingPageState();
}

class _HadithReadingPageState extends State<HadithReadingPage> {
  int _currentHadithNumber = 1;
  hadithModel.Hadith? _currentHadith;
  bool _isFavorite = false;
  bool _isPlaying = false;
  AudioPlayer? _audioPlayer;
  double _fontSize = 16.0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PageController _pageController;
  bool _isInitialized = false;
  List<hadithModel.Hadith>? _allHadiths;
  bool _isIncreasing = true; // Toggle direction for font size

  @override
  void initState() {
    super.initState();
    _loadFontSize();
    _loadAllHadiths();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      // Get initial hadith number from arguments
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is Map<String, dynamic>) {
        _currentHadithNumber = args['hadithNumber'] as int? ?? 1;
      }
      
      // Initialize page controller with the correct initial page
      _pageController = PageController(initialPage: _currentHadithNumber - 1);
      _isInitialized = true;
      _loadHadith();
    }
  }

  Future<void> _loadAllHadiths() async {
    final hadiths = await HadithDataLoader.loadHadiths();
    setState(() {
      _allHadiths = hadiths;
    });
  }

  Future<void> _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fontSize = prefs.getDouble('font_size') ?? 16.0;
    });
  }

  Future<void> _loadHadith() async {
    final hadith = await HadithDataLoader.getHadithByNumber(_currentHadithNumber);
    final isFav = await HadithService.isFavorite(_currentHadithNumber);
    
    setState(() {
      _currentHadith = hadith;
      _isFavorite = isFav;
    });
  }

  void _toggleFontSize() {
    setState(() {
      if (_isIncreasing) {
        _fontSize = (_fontSize + 2).clamp(12.0, 32.0);
      } else {
        _fontSize = (_fontSize - 2).clamp(12.0, 32.0);
      }
      // Toggle direction on each click
      _isIncreasing = !_isIncreasing;
    });
    _saveFontSize();
  }

  Future<void> _saveFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('font_size', _fontSize);
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await HadithService.removeFavorite(_currentHadithNumber);
    } else {
      await HadithService.addFavorite(_currentHadithNumber);
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Future<void> _toggleAudio() async {
    if (_currentHadith?.audioPath == null) return;

    if (_audioPlayer == null) {
      _audioPlayer = AudioPlayer();
    }

    if (_isPlaying) {
      await _audioPlayer!.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      try {
        await _audioPlayer!.play(AssetSource(_currentHadith!.audioPath!.replaceFirst('assets/', '')));
        setState(() {
          _isPlaying = true;
        });
        
        _audioPlayer!.onPlayerComplete.listen((event) {
          if (mounted) {
            setState(() {
              _isPlaying = false;
            });
          }
        });
      } catch (e) {
        print('Error playing audio: $e');
      }
    }
  }

  void _nextHadith() {
    if (_currentHadithNumber < 42 && _pageController.hasClients) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousHadith() {
    if (_currentHadithNumber > 1 && _pageController.hasClients) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    final newHadithNumber = index + 1;
    if (newHadithNumber != _currentHadithNumber) {
      setState(() {
        _currentHadithNumber = newHadithNumber;
      });
      _loadHadith();
    }
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator until hadiths are loaded
    if (_allHadiths == null || !_isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: SidebarMenu(),
      appBar: AppBar(
        backgroundColor: AppConstants.appBarColor,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorite,
            onLongPress: () {
              Navigator.of(context).pushNamed('/bookmarks');
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward, color: Colors.white),
            onPressed: _nextHadith,
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _allHadiths!.length,
            itemBuilder: (context, index) {
              final hadith = _allHadiths![index];
              return _buildHadithContent(hadith);
            },
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              heroTag: "font_toggle",
              onPressed: _toggleFontSize,
              child: Icon(_isIncreasing ? Icons.add : Icons.remove),
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHadithContent(hadithModel.Hadith hadith) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage('assets/images/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                // Title
                Text(
                  "- Hadis ${hadith.number} -",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  hadith.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 10),
                
                // Main Image
                if (hadith.imagePath.isNotEmpty)
                  Image.asset(
                    hadith.imagePath,
                    fit: BoxFit.contain,
                    height: 200,
                    // width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox.shrink();
                    },
                  ),
                
                SizedBox(height: 10),
                
                // Audio Player Controls
                if (hadith.audioPath != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous, color: Colors.black, size: 30),
                        onPressed: _previousHadith,
                      ),
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause_circle : Icons.play_circle,
                          color: Colors.black,
                          size: 50,
                        ),
                        onPressed: _toggleAudio,
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next, color: Colors.black, size: 30),
                        onPressed: _nextHadith,
                      ),
                    ],
                  ),
                
                SizedBox(height: 20),
                
                // Bismillah Image
                Image.asset(
                  "assets/images/bismillah.png",
                  fit: BoxFit.contain,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return SizedBox.shrink();
                  },
                ),
                
                SizedBox(height: 20),
                
                // Hadith Images (can be 1 or 2)
                ...hadith.hadithImages.map((imagePath) => Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return SizedBox.shrink();
                    },
                  ),
                )),
                
                SizedBox(height: 20),
                
                // HTML Description
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Html(
                    data: hadith.htmlDescription,
                    style: {
                      "body": Style(
                        fontSize: FontSize(_fontSize),
                        color: Colors.black,
                      ),
                      "p": Style(
                        fontSize: FontSize(_fontSize),
                        margin: Margins.zero,
                        padding: HtmlPaddings.only(bottom: 10),
                      ),
                    },
                  ),
                ),
                
                SizedBox(height: 80), // Extra space for floating buttons
              ],
            ),
          ),
        );
  }
}

