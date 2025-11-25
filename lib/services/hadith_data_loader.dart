import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/hadith.dart';

/// Service to load hadith data from JSON file
class HadithDataLoader {
  static List<Hadith>? _cachedHadiths;
  
  /// Load all hadiths from the JSON file
  /// Returns cached data if already loaded
  static Future<List<Hadith>> loadHadiths() async {
    if (_cachedHadiths != null) {
      return _cachedHadiths!;
    }
    
    try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString('assets/data/hadis40.json');
      
      // Parse the JSON
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Extract the hadiths array
      final List<dynamic> hadithsJson = jsonData['hadiths'] as List<dynamic>;
      
      // Convert to Hadith objects
      _cachedHadiths = hadithsJson
          .map((json) => Hadith.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return _cachedHadiths!;
    } catch (e) {
      print('Error loading hadiths: $e');
      rethrow;
    }
  }
  
  /// Get a specific hadith by number
  static Future<Hadith?> getHadithByNumber(int number) async {
    final hadiths = await loadHadiths();
    
    try {
      return hadiths.firstWhere((h) => h.number == number);
    } catch (e) {
      return null;
    }
  }
  
  /// Get all hadiths (synchronous, only works if already loaded)
  static List<Hadith>? getCachedHadiths() {
    return _cachedHadiths;
  }
  
  /// Clear the cache (useful for testing or memory management)
  static void clearCache() {
    _cachedHadiths = null;
  }
}

