import 'package:flutter/material.dart';
import 'package:habhab/model/habit.dart';

class HabitDetailPage extends StatelessWidget {
  final Habit habit;

  const HabitDetailPage({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    // Example progress calculation (replace with actual logic)
    int streak = habit.getStreak();
    double progress =  streak % 30 / 30; // Assuming a 30-day goal

    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.loop),
                title: Text('Interval: ${habit.interval}'),
              ),
            ),
            Card(
              child: ListTile(
                  leading: Icon(Icons.local_fire_department),
                  title: Text('Streak: ${habit.getStreak()} days'),
                  trailing: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value:
                            progress, // Assuming progress is a value between 0.0 and 1.0
                        semanticsLabel: 'Habit progress',
                        backgroundColor: Color.fromARGB(255, 220, 220, 220),
                      ),
                      Text('${habit.getStreak()}/30'),
                    ],
                  )),
            ), // Add more interactive or creative parts as needed
          ],
        ),
      ),
    );
  }
}
