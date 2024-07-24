import 'package:flutter/material.dart';
import 'package:habhab/model/habit.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final _habitNameController = TextEditingController();
  String _selectedInterval = 'Daily';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _habitNameController,
              decoration: const InputDecoration(labelText: 'Habit Name'),
            ),
            DropdownButton<String>(
              value: _selectedInterval,
              onChanged: (value) {
                setState(() {
                  _selectedInterval = value!;
                });
              },
              items: const ['Daily', 'Weekly']
                  .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                final newHabit = Habit(
                  name: _habitNameController.text,
                  interval: _selectedInterval,
                );
                Navigator.pop(context, newHabit);
              },
              child: const Text('Add Habit'),
            ),
          ],
        ),
      ),
    );
  }
}