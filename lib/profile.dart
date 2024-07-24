import 'package:flutter/material.dart';
import 'model/level_system.dart'; // Ensure this import is correct

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // Check if LevelSystem is initialized
    if (!LevelSystem.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()), // Loading indicator
      );
    }

    // Calculate some level values
    int currentLevel = LevelSystem.calculateLevel(LevelSystem.xp);
    int xpNeededForNextLevel = LevelSystem.xpForNextLevel();
    int currentLevelXP = LevelSystem.currentLevelProgress();
    double progress = currentLevelXP / (xpNeededForNextLevel + currentLevelXP).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Level: $currentLevel', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
              minHeight: 20,
            ),
            const SizedBox(height: 20),
            Text('XP: $currentLevelXP / ${xpNeededForNextLevel + currentLevelXP}', style: TextStyle(fontSize: 16)),
            //test button to add xp
            ElevatedButton(
              onPressed: () {
                setState(() {
                  LevelSystem.addXp(10);
                });
              },
              child:const Text('Add XP'),
            ),
          ],
        ),
      ),
    );
  }
}