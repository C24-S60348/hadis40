import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HadithService {
  static const String _favoritesKey = 'favorite_hadith';
  static const String _quoteKey = 'random_quotes';
  static const String _currentQuoteIndexKey = 'current_quote_index';

  // Get favorite hadith numbers
  static Future<List<int>> getFavoriteHadith() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson == null) return [];
    
    try {
      final List<dynamic> favorites = json.decode(favoritesJson);
      return favorites.cast<int>();
    } catch (e) {
      return [];
    }
  }

  // Add hadith to favorites
  static Future<void> addFavorite(int hadithNumber) async {
    final favorites = await getFavoriteHadith();
    if (!favorites.contains(hadithNumber)) {
      favorites.add(hadithNumber);
      await _saveFavorites(favorites);
    }
  }

  // Remove hadith from favorites
  static Future<void> removeFavorite(int hadithNumber) async {
    final favorites = await getFavoriteHadith();
    favorites.remove(hadithNumber);
    await _saveFavorites(favorites);
  }

  // Check if hadith is favorited
  static Future<bool> isFavorite(int hadithNumber) async {
    final favorites = await getFavoriteHadith();
    return favorites.contains(hadithNumber);
  }

  // Save favorites
  static Future<void> _saveFavorites(List<int> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favoritesKey, json.encode(favorites));
  }

  // Get random quote from katakatahikmah.json
  static Future<String> getRandomQuote() async {
    final prefs = await SharedPreferences.getInstance();
    
    List<String> quotes = [];
    
    try {
      // Load quotes from JSON file
      final String jsonString = await rootBundle.loadString('assets/data/katakatahikmah.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      quotes = List<String>.from(jsonData['kata-kata-hikmah'] ?? []);
    } catch (e) {
      // Fallback to default quote if file loading fails
      quotes = ['Kata-kata hikmah akan muncul di sini'];
    }
    
    // Default quote if none provided
    if (quotes.isEmpty) {
      quotes = ['Kata-kata hikmah akan muncul di sini'];
    }
    
    // Get current index and rotate
    int currentIndex = prefs.getInt(_currentQuoteIndexKey) ?? 0;
    String quote = quotes[currentIndex % quotes.length];
    
    // Increment for next time
    await prefs.setInt(_currentQuoteIndexKey, (currentIndex + 1) % quotes.length);
    
    return quote;
  }

  // Save quotes (for admin/settings)
  static Future<void> saveQuotes(List<String> quotes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_quoteKey, json.encode(quotes));
  }
}

