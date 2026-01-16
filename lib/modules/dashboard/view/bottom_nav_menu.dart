import 'package:flutter/material.dart';

class BottomNavMenu extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const BottomNavMenu({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onItemTapped,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.play_circle_outline),
          selectedIcon: Icon(Icons.play_circle_fill),
          label: 'Player',
        ),
        NavigationDestination(
          icon: Icon(Icons.music_note_outlined),
          selectedIcon: Icon(Icons.music_note),
          label: 'Song',
        ),
      ],
    );
  }
}