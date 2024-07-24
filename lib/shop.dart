import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'model/habit.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Habit> _habits = [];
  int _coins = 0;

  @override
  void initState() {
    super.initState();
    _loadAllHabits();
    _loadCoins();
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
      // Load coins, defaults to 0
      _coins = prefs.getInt('coins') ?? 0;
    });
  }

  void _addCoins(int amount) {
    setState(() {
      _coins += amount;
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
          const SnackBar(content: Text('No habits found!')),
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
          const SnackBar(content: Text('All habits are already done today!')),
        );
        return;
      }

      _saveHabits(); // Save habits after marking them as done

      _addCoins(-costs); // Remove 10 coins for the purchase

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cheat Day purchased! All habits marked as done for today.')),
      );
    } else {
      // Show an error or a message indicating insufficient coins
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient coins!')),
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
      title: const Text('Shop'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Center(child: Text('Coins: $_coins')),
        ),
      ],
    ),
    body: ListView(
      children: [
        ListTile(
          title: const Text('Buy Cheat Day'),
          subtitle: const Text('10 Coins'),
          onTap: _buyCheatDay,
          trailing: const Icon(Icons.shopping_cart),
        ),
        // Free coins for testing
        ListTile(
          title: const Text('Get Coins'),
          subtitle: const Text('Free'),
          onTap: _addSomeCoins,
          trailing: const Icon(Icons.monetization_on),
        ),
      ],
    ),
  );
}
}