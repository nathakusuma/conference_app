import 'package:flutter/material.dart';

import '../conferences/browse_screen.dart';
import '../profile/profile_screen.dart';
import '../registrations/registrations_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  static const routeName = '/main';

  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;

  final List<Widget> _screens = [
    const BrowseScreen(),
    const Center(child: Text("Proposals -- TODO")),
    const RegistrationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (idx) => setState(() => _index = idx),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Proposals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available),
            label: 'Registrations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
