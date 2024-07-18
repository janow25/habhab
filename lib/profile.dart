import 'package:flutter/material.dart';
import 'model/level_system.dart'; // Ensure this import is correct

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // Assuming LevelSystem has a method to check if it's initialized and a method to get current XP
    // These parts might need to be adjusted based on the actual implementation of LevelSystem
    if (!LevelSystem.isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Loading indicator
      );
    }

    // Use the new methods for level and XP calculations
    int currentLevel = LevelSystem.calculateLevel(LevelSystem.xp);
    int xpNeededForNextLevel = LevelSystem.xpForNextLevel();
    int currentLevelXP = LevelSystem.currentLevelProgress();
    double progress = currentLevelXP / (xpNeededForNextLevel + currentLevelXP).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Level: $currentLevel', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
              minHeight: 20,
            ),
            SizedBox(height: 20),
            Text('XP: $currentLevelXP / ${xpNeededForNextLevel + currentLevelXP}', style: TextStyle(fontSize: 16)),
            //test button to add xp
            ElevatedButton(
              onPressed: () {
                setState(() {
                  LevelSystem.addXp(10);
                });
              },
              child: Text('Add XP'),
            ),
          ],
        ),
      ),
    );
  }
}