import 'package:habhab/model/level_system.dart';

class Habit {
  String name;
  String interval;
  Set<DateTime> completedDates;

  Habit({required this.name, required this.interval, Set<DateTime>? completedDates})
      : this.completedDates = completedDates ?? {};

  Map<String, dynamic> toJson() => {
        'name': name,
        'interval': interval,
        'completedDates': completedDates.map((date) => date.toIso8601String()).toList(),
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        name: json['name'],
        interval: json['interval'],
        completedDates: Set.from(json['completedDates'].map((dateStr) => DateTime.parse(dateStr))),
      );

  void markDone() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    completedDates.add(today);

    LevelSystem.init();
    LevelSystem.addXp(10);
  }

  bool isDoneToday() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    return completedDates.contains(today);
  }

  int getStreak() {
    List<DateTime> sortedDates = completedDates.toList()
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime? prevDate;

    for (var date in sortedDates) {
      if (prevDate == null || prevDate.difference(date).inDays == 1) {
        streak++;
        prevDate = date;
      } else if (prevDate.difference(date).inDays > 1) {
        break;
      }
    }

    return streak;
  }
}