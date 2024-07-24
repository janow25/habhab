import 'package:flutter/material.dart';
import 'package:habhab/model/habit.dart';

class HabitDetailPage extends StatelessWidget {
  final Habit habit;

  const HabitDetailPage({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    int streak = habit.getStreak();
    double progress =  streak % 30 / 30;

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
                leading: const Icon(Icons.loop),
                title: Text('Interval: ${habit.interval}'),
              ),
            ),
            Card(
              child: ListTile(
                  leading: const Icon(Icons.local_fire_department),
                  title: Text('Streak: ${habit.getStreak()} days'),
                  trailing: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value:
                            progress,
                        semanticsLabel: 'Habit progress',
                        backgroundColor: const Color.fromARGB(255, 220, 220, 220),
                      ),
                      Text('${habit.getStreak()}/30'),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
