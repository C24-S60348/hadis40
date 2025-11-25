import 'package:flutter/material.dart';
import '../services/hadith_service.dart';
import '../services/hadith_data_loader.dart';
import '../models/hadith.dart' as hadithModel;

class BookmarksPage extends StatefulWidget {
  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  List<int> favoriteHadith = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  void _loadBookmarks() async {
    try {
      final favorites = await HadithService.getFavoriteHadith();
      setState(() {
        favoriteHadith = favorites;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading bookmarks: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _removeBookmark(int hadithNumber) async {
    try {
      await HadithService.removeFavorite(hadithNumber);
      setState(() {
        favoriteHadith.remove(hadithNumber);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bookmark removed'),
          duration: Duration(seconds: 2),
          backgroundColor: const Color.fromARGB(255, 52, 21, 104),
        ),
      );
    } catch (e) {
      print('Error removing bookmark: $e');
    }
  }

  void _navigateToHadith(int hadithNumber) {
    Navigator.of(context).pushNamed('/hadith-reading', arguments: {
      'hadithNumber': hadithNumber,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favourites Hadith', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 52, 21, 104),
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
            padding: EdgeInsets.all(16.0),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color.fromARGB(255, 52, 21, 104),
                      ),
                    ),
                  )
                : favoriteHadith.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bookmark_border,
                              size: 64,
                              color: Colors.grey[600],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Tiada bookmark',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Bookmark hadith semasa membaca untuk melihatnya di sini',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : FutureBuilder<List<hadithModel.Hadith>>(
                        future: HadithDataLoader.loadHadiths(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          
                          final allHadiths = snapshot.data!;
                          
                          return ListView.builder(
                            itemCount: favoriteHadith.length,
                            itemBuilder: (context, index) {
                              final hadithNumber = favoriteHadith[index];
                              final hadith = allHadiths.firstWhere(
                                (h) => h.number == hadithNumber,
                                orElse: () => hadithModel.Hadith(
                                  number: hadithNumber,
                                  title: 'Hadis $hadithNumber',
                                  arabicTitle: '',
                                  imagePath: '',
                                  bismillahImagePath: '',
                                  hadithImages: [],
                                  htmlDescription: '',
                                ),
                              );
                              
                              return Card(
                            margin: EdgeInsets.only(bottom: 12),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () => _navigateToHadith(hadithNumber),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Hadis ${hadith.number}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(255, 52, 21, 104),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            hadith.title,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => _removeBookmark(hadithNumber),
                                      icon: Icon(
                                        Icons.bookmark_remove,
                                        color: Colors.red[400],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
