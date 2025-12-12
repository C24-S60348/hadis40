import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/kata_kata_hikmah.dart';

/// Service to load kata-kata hikmah data from JSON file
class KataKataHikmahLoader {
  static List<KataKataHikmah>? _cachedQuotes;
  
  /// Load all kata-kata hikmah from the JSON file
  /// Returns cached data if already loaded
  static Future<List<KataKataHikmah>> loadQuotes() async {
    if (_cachedQuotes != null) {
      return _cachedQuotes!;
    }
    
    try {
      // Load the JSON file from assets
      final String jsonString = await rootBundle.loadString('assets/data/pagekatakata.json');
      
      // Parse the JSON
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Extract the kata_kata_hikmah array
      final List<dynamic> quotesJson = jsonData['kata_kata_hikmah'] as List<dynamic>;
      
      // Convert to KataKataHikmah objects
      _cachedQuotes = quotesJson
          .map((json) => KataKataHikmah.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return _cachedQuotes!;
    } catch (e) {
      print('Error loading kata-kata hikmah: $e');
      rethrow;
    }
  }
  
  /// Get a specific quote by number
  static Future<KataKataHikmah?> getQuoteByNumber(int number) async {
    final quotes = await loadQuotes();
    
    try {
      return quotes.firstWhere((q) => q.nombor == number);
    } catch (e) {
      return null;
    }
  }
  
  /// Get all quotes (synchronous, only works if already loaded)
  static List<KataKataHikmah>? getCachedQuotes() {
    return _cachedQuotes;
  }
  
  /// Clear the cache (useful for testing or memory management)
  static void clearCache() {
    _cachedQuotes = null;
  }
}
