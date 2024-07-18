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
    // Ensure LevelSystem is initialized before accessing its properties
    if (!LevelSystem.isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Loading indicator
      );
    }

    // Calculate the progress towards the next level
    int xpForNextLevel = LevelSystem.level * 10;
    double progress = LevelSystem.xp / xpForNextLevel;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Level: ${LevelSystem.level}', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
              minHeight: 20,
            ),
            SizedBox(height: 20),
            Text('XP: ${LevelSystem.xp} / $xpForNextLevel', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}