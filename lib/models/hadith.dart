class Hadith {
  final int number;
  final String title;
  final String arabicTitle;
  final String imagePath;
  final String? audioPath;
  final String bismillahImagePath;
  final List<String> hadithImages; // Can be 1 or 2 images
  final String htmlDescription;

  Hadith({
    required this.number,
    required this.title,
    required this.arabicTitle,
    required this.imagePath,
    this.audioPath,
    required this.bismillahImagePath,
    required this.hadithImages,
    required this.htmlDescription,
  });

  /// Create a Hadith object from JSON
  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      number: json['number'] as int,
      title: json['title'] as String,
      arabicTitle: json['arabicTitle'] as String? ?? '',
      imagePath: json['imagePath'] as String,
      audioPath: json['audioPath'] as String?,
      bismillahImagePath: json['bismillahImagePath'] as String,
      hadithImages: (json['hadithImages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      htmlDescription: json['htmlDescription'] as String,
    );
  }

  /// Convert Hadith object to JSON
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'title': title,
      'arabicTitle': arabicTitle,
      'imagePath': imagePath,
      'audioPath': audioPath,
      'bismillahImagePath': bismillahImagePath,
      'hadithImages': hadithImages,
      'htmlDescription': htmlDescription,
    };
  }
}

/// Legacy wrapper class for backward compatibility with existing code
/// This class is deprecated - use HadithDataLoader directly instead
class HadithData {
  /// Returns empty list - use HadithDataLoader.loadHadiths() instead
  @Deprecated('Use HadithDataLoader.loadHadiths() instead')
  static List<Hadith> getAllHadith() {
    return [];
  }

  /// Returns null - use HadithDataLoader.getHadithByNumber() instead
  @Deprecated('Use HadithDataLoader.getHadithByNumber() instead')
  static Hadith? getHadithByNumber(int number) {
    return null;
  }
}

