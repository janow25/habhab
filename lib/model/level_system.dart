import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LevelSystem {
  static int _xp = 0; // User's current XP
  static int _level = 1; // User's current level
  static bool _isInitialized = false; // Flag to check if initialization is done
  static late BuildContext _context; // Context to show SnackBar

  // Method to set the context
  static void setContext(BuildContext context) {
    _context = context;
  }

  // Method to initialize the LevelSystem asynchronously
  static Future<void> init() async {
    if (!_isInitialized) {
      final prefs = await SharedPreferences.getInstance();
      _xp = prefs.getInt('xp') ?? 0;
      _level = calculateLevel(_xp);
      _isInitialized = true;
    }
  }

  // Getter for current level
  static int get level {
    if (!_isInitialized) {
      throw Exception("LevelSystem not initialized. Call init() first.");
    }
    return _level;
  }

  // Getter for current XP
  static int get xp {
    if (!_isInitialized) {
      throw Exception("LevelSystem not initialized. Call init() first.");
    }
    return _xp;
  }

  // Getter for initialization status
  static bool get isInitialized => _isInitialized;

  // Method to add XP and automatically update the level if necessary
  static Future<void> addXp(int amount) async {
    if (!_isInitialized) {
      throw Exception("LevelSystem not initialized. Call init() first.");
    }
    _xp += amount;
    int newLevel = calculateLevel(_xp);
    if (newLevel > _level) {
      _level = newLevel;

      OnLevelUp(newLevel);
      // Optionally, trigger some event or notification about level up
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xp', _xp);
  }

  // Calculate level based on XP
  static int calculateLevel(int xp) {
    return 1 + xp ~/ 10; // Integer division discards remainder
  }

  // OnLevelUp event handler
  static void OnLevelUp(int newLevel) {
    print('Levelup $newLevel!');

    // Show an error or a message indicating insufficient coins
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(content: Text('You reached Level $newLevel!')),
    );
  }
}