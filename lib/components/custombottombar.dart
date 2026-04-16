import 'package:commitlock/screens/dashboard/dashboard.dart';
import 'package:commitlock/screens/history/history_screen.dart';
import 'package:commitlock/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:commitlock/core/constants/app_theme.dart';

class Custombottombar extends StatefulWidget {
  const Custombottombar({super.key});

  @override
  State<Custombottombar> createState() => _CustombottombarState();
}

class _CustombottombarState extends State<Custombottombar> {
  int _currentIndex = 0;

  final List _pages = const [
    Dashboard(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;

    return IconButton(
      onPressed: () => onItemTapped(index),
      icon: Icon(
        icon,
        color: isSelected
            ? AppColors.primaryColor
            : AppColors.subTextColor,
        size: isSelected ? 30 : 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // IMPORTANT for floating effect

      body: _pages[_currentIndex],

      bottomNavigationBar: Padding(
  padding: const EdgeInsets.all(20),
  child: Container(
    height: 80,
    decoration: BoxDecoration(
      color: AppColors.accentColor,
      borderRadius: BorderRadius.circular(35),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 20,
          spreadRadius: 5,
        )
      ],
    ),// notch for FAB
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home, 0),
                _buildNavItem(Icons.history, 1),
                _buildNavItem(Icons.settings, 2),
              ],
            ),
          ),
      ),
    );
  }
}