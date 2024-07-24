// Importing necessary Flutter packages
import 'package:flutter/material.dart';
import 'start.dart';
import 'shop.dart';
import 'profile.dart';
import 'model/level_system.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const HabHab());

class HabHab extends StatelessWidget {
  const HabHab({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarMenu(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BottomNavigationBarMenu extends StatefulWidget {
  const BottomNavigationBarMenu({super.key});

  @override
  State<BottomNavigationBarMenu> createState() =>
      _BottomNavigationBarMenuState();
}

class _BottomNavigationBarMenuState extends State<BottomNavigationBarMenu> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    LevelSystem.setContext(context); // Set the context for LevelSystem
    LevelSystem.init(); // Initialize LevelSystem
  }

  static const List<Widget> _pages = <Widget>[
    StartPage(),
    ShopPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[400],
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Reset Level'),
            onTap: LevelSystem.reset,
            trailing: Icon(Icons.refresh),
          ),
          ListTile(
            title: const Text('Reset Coins'),
            onTap: resetCoins,
            trailing: const Icon(Icons.refresh),
          ),
          ListTile(
            title: const Text('Notification Settings'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Notification Settings'),
                    content: Column(
                      children: [
                        CheckboxListTile(
                          title: const Text('Enable Notifications'),
                          value: false,
                          onChanged: (bool? value) {
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('Enable Sound'),
                          value: false,
                          onChanged: (bool? value) {
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('Enable Vibration'),
                          value: false,
                          onChanged: (bool? value) {
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            },
            trailing: const Icon(Icons.notifications),
          ),
        ],
      ),
    );
  }

  void resetCoins() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', 0);
  }
}
