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
    const costs = 10;

    if (_coins >= costs) {

      if (_habits.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No habits found!')),
        );
        return;
      }

      // Mark all habits as done
      var usedItem = false;
      for (var habit in _habits) {
        if (!habit.isDone()) {
          habit.markDone();
          usedItem = true;
        }
      }
      
      // If no habits were marked as done, show a message
      if (!usedItem) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('All habits are already done today!')),
        );
        return;
      }

      _saveHabits(); // Save habits after marking them as done

      _addCoins(-costs); // Remove 10 coins for the purchase

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

  void _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String habitsJson = jsonEncode(_habits.map((habit) => habit.toJson()).toList());
    await prefs.setString('habits', habitsJson);
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Shop'),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Center(child: Text('Coins: $_coins')), // Display the coin count here
        ),
      ],
    ),
    body: ListView(
      children: [
        ListTile(
          title: Text('Buy Cheat Day'),
          subtitle: Text('10 Coins'), // Display the price here
          onTap: _buyCheatDay,
          trailing: Icon(Icons.shopping_cart),
        ),
        ListTile(
          title: Text('Get Coins'),
          subtitle: Text('Free'), // Example of a free item
          onTap: _addSomeCoins,
          trailing: Icon(Icons.monetization_on),
        ),
        // Add more shop items as ListTiles here with their prices in the subtitle
      ],
    ),
  );
}
}