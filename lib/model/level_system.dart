import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:math';

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

  // Method to add XP
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

    print('got XP: $amount');
  }

  // Improved level calculation using a quadratic formula
  static int calculateLevel(int xp) {
    return 1 + ((-1 + sqrt(1 + 8 * xp / 100)) / 2).floor();
  }

  // Calculate XP needed for the next level
  static int xpForNextLevel() {
    int nextLevel = _level + 1;
    // Inverse of calculateLevel formula to find XP needed for next level
    return (100 * (nextLevel * (nextLevel - 1) / 2)).ceil() - _xp;
  }

  // Calculate current level progress
  static int currentLevelProgress() {
    int xpForCurrentLevel = (100 * (_level * (_level - 1) / 2)).ceil();
    return _xp - xpForCurrentLevel;
  }

  // OnLevelUp event handler
  static void OnLevelUp(int newLevel) {
    var rewardCoins = 10 * (newLevel-1);

    print('Levelup $newLevel! Reward: $rewardCoins coins');

    // Show an error or a message indicating insufficient coins
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(content: Text('You reached Level $newLevel and got $rewardCoins coins!')),
    );

    _addCoins(rewardCoins);
  }

  static void _addCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    var coins = prefs.getInt('coins') ?? 0;
    coins += amount; // Add coins
    await prefs.setInt('coins', coins);
  }

  static void reset() async {
    _xp = 0;
    _level = 1;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('xp', _xp);
  }
}