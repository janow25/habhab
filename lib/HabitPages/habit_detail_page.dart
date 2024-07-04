import 'package:flutter/material.dart';
import 'package:habhab/model/habit.dart';

class HabitDetailPage extends StatelessWidget {
  final Habit habit;

  const HabitDetailPage({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${habit.name}', style: TextStyle(fontSize: 20)),
            Text('Interval: ${habit.interval}', style: TextStyle(fontSize: 20)),
            Text('Streak: ${habit.getStreak()} days', style: TextStyle(fontSize: 20)),
            // Add more stats as needed
          ],
        ),
      ),
    );
  }
}