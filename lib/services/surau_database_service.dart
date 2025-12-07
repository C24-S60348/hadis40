import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class SurauDatabaseService {
  static Database? _database;
  static const String _dbName = 'surau_jumaat.db';
  static const String _tableName = 'surau';

  // Get database instance
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final dbFile = path.join(dbPath, _dbName);

    // Check if database exists
    final exists = await databaseExists(dbFile);

    if (!exists) {
      // Database doesn't exist, copy from assets
      await _copyDatabaseFromAssets(dbFile);
    }

    return await openDatabase(
      dbFile,
      version: 1,
      readOnly: false,
    );
  }

  // Copy database from assets to app directory
  static Future<void> _copyDatabaseFromAssets(String dbFile) async {
    try {
      // Load database from assets
      final ByteData data = await rootBundle.load('assets/data/surau_jumaat.db');
      final List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      
      // Ensure directory exists
      final File file = File(dbFile);
      await file.parent.create(recursive: true);
      
      // Write to app directory
      await file.writeAsBytes(bytes);
      
      print('Successfully copied database from assets');
    } catch (e) {
      print('Error copying database from assets: $e');
      rethrow;
    }
  }


  // Search surau
  static Future<List<Map<String, dynamic>>> searchSurau(String query) async {
    final db = await database;
    
    if (query.isEmpty) {
      return await db.query(
        _tableName,
        orderBy: 'negeri, daerah, surau',
      );
    }

    final searchPattern = '%$query%';
    return await db.query(
      _tableName,
      where: '''
        negeri LIKE ? OR 
        surau LIKE ? OR 
        alamat LIKE ? OR 
        daerah LIKE ? OR 
        poskod LIKE ?
      ''',
      whereArgs: [
        searchPattern,
        searchPattern,
        searchPattern,
        searchPattern,
        searchPattern,
      ],
      orderBy: 'negeri, daerah, surau',
    );
  }

  // Get all surau
  static Future<List<Map<String, dynamic>>> getAllSurau() async {
    final db = await database;
    return await db.query(
      _tableName,
      orderBy: 'negeri, daerah, surau',
    );
  }

  // Get surau by negeri
  static Future<List<Map<String, dynamic>>> getSurauByNegeri(String negeri) async {
    final db = await database;
    return await db.query(
      _tableName,
      where: 'negeri = ?',
      whereArgs: [negeri],
      orderBy: 'daerah, surau',
    );
  }

  // Get surau by daerah
  static Future<List<Map<String, dynamic>>> getSurauByDaerah(String daerah) async {
    final db = await database;
    return await db.query(
      _tableName,
      where: 'daerah = ?',
      whereArgs: [daerah],
      orderBy: 'surau',
    );
  }

  // Get distinct negeri list
  static Future<List<String>> getNegeriList() async {
    final db = await database;
    final result = await db.rawQuery('SELECT DISTINCT negeri FROM $_tableName ORDER BY negeri');
    return result.map((row) => row['negeri'] as String).toList();
  }

  // Get distinct daerah list for a negeri
  static Future<List<String>> getDaerahList(String negeri) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT DISTINCT daerah FROM $_tableName WHERE negeri = ? ORDER BY daerah',
      [negeri],
    );
    return result.map((row) => row['daerah'] as String).toList();
  }

  // Get total count
  static Future<int> getTotalCount() async {
    final db = await database;
    final result = await Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $_tableName'),
    );
    return result ?? 0;
  }

  // Close database
  static Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}

