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
    if (isDone()) return;

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    completedDates.add(today);

    // Assuming LevelSystem.init() is asynchronous and returns a Future
    LevelSystem.init().then((_) {
      LevelSystem.addXp(10 + getStreak()); // Assuming addXp is also asynchronous
    });
  }

  bool isDone() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (interval.toLowerCase() == 'daily') {
      return completedDates.contains(today);
    } else if (interval.toLowerCase() == 'weekly') {
      // Find the first day of the week (assuming Sunday as the first day)
      DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      // Check if any date in the completedDates falls within this week
      return completedDates.any((date) {
        return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) && date.isBefore(startOfWeek.add(const Duration(days: 7)));
      });
    } else {
      // Default to false if intervalType is not recognized
      return false;
    }
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