import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'model/habit.dart'; // Assuming this is the file name where Habit class is defined

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Habit> _habits = [];
  int _coins = 0; // Step 1: Add a coin variable

  @override
  void initState() {
    super.initState();
    _loadAllHabits();
    _loadCoins(); // Load coins when the widget is initialized
  }

  void _loadAllHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsJson = prefs.getString('habits');
    if (habitsJson != null) {
      setState(() {
        final List<dynamic> habitList = jsonDecode(habitsJson);
        _habits = habitList.map((habitJson) => Habit.fromJson(habitJson)).toList();
      });
    }
  }

  void _loadCoins() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _coins = prefs.getInt('coins') ?? 0; // Load coins, default to 0 if not found
    });
  }

  void _addCoins(int amount) {
    setState(() {
      _coins += amount; // Add the specified amount of coins
    });
    _saveCoins();
  }

  void _saveCoins() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', _coins); // Persist the coin count
  }

  void _buyCheatDay() {
    // Example: Buying a Cheat Day costs 10 coins
    if (_coins >= 10) {
      for (var habit in _habits) {
        habit.markDone();
      }
      _addCoins(-10); // Deduct 10 coins for the purchase
      // Optionally, save habits if they are modified
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cheat Day purchased! All habits marked as done for today.')),
      );
    } else {
      // Show an error or a message indicating insufficient coins
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Insufficient coins!')),
      );
    }
  }

  void _addSomeCoins() {
    _addCoins(10); // Add 10 coins
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Coins: $_coins'), // Display the current coin count
            ElevatedButton(
              onPressed: _buyCheatDay,
              child: Text('Buy Cheat Day (10 Coins)'),
            ),

            ElevatedButton(onPressed: _addSomeCoins, child: Text('Get coins'))
            // Add more shop items or functionality here
          ],
        ),
      ),
    );
  }
}