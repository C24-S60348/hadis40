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
  bool _isLoadingAudio = false;
  AudioPlayer? _audioPlayer;
  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;
  double _audioProgress = 0.0;
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
    _initializeAudioPlayer();
  }

  void _initializeAudioPlayer() {
    _audioPlayer = AudioPlayer();
    // Set player mode for better network audio handling
    _audioPlayer!.setPlayerMode(PlayerMode.mediaPlayer);
    
    // Listen to player state changes
    _audioPlayer!.onPlayerStateChanged.listen((PlayerState state) {
      if (mounted) {
        print('Audio player state changed: $state');
        setState(() {
          _isPlaying = state == PlayerState.playing;
          if (state == PlayerState.playing) {
            _isLoadingAudio = false;
          } else if (state == PlayerState.completed) {
            _audioProgress = 0.0;
            _audioPosition = Duration.zero;
            _audioDuration = Duration.zero;
          }
        });
      }
    });

    // Listen for duration changes
    _audioPlayer!.onDurationChanged.listen((Duration duration) {
      if (mounted) {
        setState(() {
          _audioDuration = duration;
        });
      }
    });

    // Listen for position changes to update progress
    _audioPlayer!.onPositionChanged.listen((Duration position) {
      if (mounted && _audioDuration.inMilliseconds > 0) {
        setState(() {
          _audioPosition = position;
          _audioProgress = position.inMilliseconds / _audioDuration.inMilliseconds;
          // Clamp between 0 and 1
          _audioProgress = _audioProgress.clamp(0.0, 1.0);
          // print('Audio progress: ${(_audioProgress * 100).toStringAsFixed(1)}%');
        });
      }
    });

    // Listen for errors
    _audioPlayer!.onLog.listen((message) {
      print('Audio player log: $message');
    });
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

  Future<void> _playAudio() async {
    if (_audioPlayer == null) {
      _initializeAudioPlayer();
    }

    // Check current state
    final currentState = _audioPlayer!.state;
    
    // If paused, resume
    if (currentState == PlayerState.paused) {
      try {
        await _audioPlayer!.resume();
        setState(() {
          _isPlaying = true;
          _isLoadingAudio = false;
        });
        // Show resume snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Audio disambung semula'),
              duration: Duration(seconds: 2),
              backgroundColor: const Color.fromARGB(255, 64, 163, 69),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        return;
      } catch (e) {
        print('Error resuming audio: $e');
        // If resume fails, continue to play new audio
      }
    }
    
    // If already playing, restart from beginning
    if (currentState == PlayerState.playing || _isPlaying) {
      try {
        await _audioPlayer!.stop();
        // Small delay to ensure stop completes
        await Future.delayed(Duration(milliseconds: 100));
        // Continue to play new audio below
      } catch (e) {
        print('Error restarting audio: $e');
      }
    }

    // If not paused and not playing, start new playback
    setState(() {
      _isLoadingAudio = true;
      _isPlaying = false;
    });

    // Show snackbar for loading
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Audio sedang dimuat turun, akan dimainkan sebentar lagi...'),
          duration: Duration(seconds: 3),
          backgroundColor: const Color.fromARGB(255, 64, 163, 69),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    try {
      final audioUrl = 'https://c24-s60348.github.io/Hadis40Revamp/Hadith${_currentHadithNumber}.mp3';
      print('Attempting to play audio from: $audioUrl');
      
      // Set volume to ensure audio plays
      await _audioPlayer!.setVolume(1.0);
      
      // Play the audio
      await _audioPlayer!.play(UrlSource(audioUrl));
      
      print('Audio play command sent successfully');
      
      // Listen for completion (only set up once)
      _audioPlayer!.onPlayerComplete.listen((event) {
        if (mounted) {
          print('Audio playback completed');
          setState(() {
            _isPlaying = false;
            _audioProgress = 0.0;
            _audioPosition = Duration.zero;
            _audioDuration = Duration.zero;
          });
        }
      });
    } catch (e, stackTrace) {
      print('Error playing audio: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _isLoadingAudio = false;
        });
        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ralat memuat audio. Sila cuba lagi.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.red[700],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _pauseAudio() async {
    if (_audioPlayer != null) {
      try {
        final currentState = _audioPlayer!.state;
        if (currentState == PlayerState.playing) {
          await _audioPlayer!.pause();
          setState(() {
            _isPlaying = false;
          });
          // Show pause snackbar
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Audio diberhentikan sementara'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.orange[700],
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      } catch (e) {
        print('Error pausing audio: $e');
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
      // Stop audio when changing hadith
      _audioPlayer?.stop();
      setState(() {
        _currentHadithNumber = newHadithNumber;
        _isPlaying = false;
        _audioProgress = 0.0;
        _audioPosition = Duration.zero;
        _audioDuration = Duration.zero;
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
              backgroundColor: const Color.fromARGB(255, 111, 191, 113),
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
                SizedBox(height: 10),
                // Title
                Text(
                  "Hadis ${hadith.number}",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Pause button (square, on the left)
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isPlaying ? _pauseAudio : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            disabledBackgroundColor: Colors.grey[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                            elevation: 0, // Remove default elevation since we're using custom shadow
                          ),
                          child: Icon(
                            Icons.pause,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Play button (rectangle, 2x wider, on the right) with progress indicator
                    SizedBox(
                      width: 120,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // Base button - must fill the SizedBox
                            SizedBox(
                              width: 120,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: _playAudio,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 64, 163, 69),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(120, 60),
                                  elevation: 0, // Remove default elevation since we're using custom shadow
                                ),
                                child: SizedBox.shrink(), // Empty child, icon will be in separate layer
                              ),
                            ),
                            // Progress overlay (darker color filling from left to right)
                            if (_isPlaying)
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Stack(
                                    children: [
                                      // Progress fill from left - darker green overlay
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: FractionallySizedBox(
                                          widthFactor: _audioProgress.clamp(0.0, 1.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  const Color.fromARGB(255, 17, 60, 20).withOpacity(0.95),
                                                  const Color.fromARGB(255, 17, 60, 20).withOpacity(0.85),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            // Play icon - always on top
                            Center(
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
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

