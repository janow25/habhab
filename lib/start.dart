import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'model/habit.dart';
import 'HabitPages/add_habit_page.dart';
import 'HabitPages/habit_detail_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final List<Habit> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  void _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsJson = prefs.getString('habits');
    if (habitsJson != null) {
      setState(() {
        final List<dynamic> habitList = jsonDecode(habitsJson);
        _habits.clear();
        _habits.addAll(habitList.map((habitJson) => Habit.fromJson(habitJson)));
      });
    }
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
        title: const Text('Habit Tracker'),
      ),
      body: ListView.builder(
        itemCount: _habits.length,
        itemBuilder: (context, index) {
          final habit = _habits[index];
          return Dismissible(
            key: Key(habit.name),
            onDismissed: (_) {
              setState(() {
                _habits.removeAt(index);
                _saveHabits(); // Save habits after one is removed
              });
            },
            child: ListTile(
              title: Text(habit.name),
              subtitle: Text('Interval: ${habit.interval}, Streak: ${habit.getStreak()} days'),
              trailing: habit.isDone() ? null : IconButton(
                icon: const Icon(Icons.check),
                onPressed: habit.isDone() ? null : () {
                  setState(() {
                    habit.markDone();
                    _saveHabits(); // Save habits after marking one as done
                  });
                },
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HabitDetailPage(habit: habit)),
              ),
              tileColor: habit.isDone() ? Colors.green : null,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newHabit = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddHabitPage()),
          );
          if (newHabit != null) {
            setState(() {
              _habits.add(newHabit);
              _saveHabits(); // Save habits after adding a new one
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}