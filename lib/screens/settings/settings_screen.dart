import 'package:commitlock/core/constants/app_theme.dart';
import 'package:commitlock/providers/auth_provider.dart';
import 'package:commitlock/providers/session_provider.dart';
import 'package:commitlock/screens/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Assume AppColors & Textfont are already defined as given

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool soundEffects = true;
  bool sessionNotification = true;
  String themeMode = 'System';

  Map<String, bool> blockedApps = {
    'Social Media': true,
    'Games': false,
    'Streaming': true,
    'Shopping': false,
  };

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.accentColor,
        title: Text("Clear History", style: Textfont.heading2),
        content: Text(
          "Are you sure you want to clear all history?",
          style: Textfont.subText,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: Textfont.button),
          ),
          TextButton(
            onPressed: () async {
              // Clear history
              final SessionProvider provider = Provider.of<SessionProvider>(
                context,
                listen: false,
              );
              final AuthProvider auth = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              provider.clearData(auth.currentUser!.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("History cleared successfully!"),
                ),
              );
              // Close the dialog
              Navigator.pop(context);
            },
            child: Text(
              "Clear",
              style: TextStyle(color: AppColors.dangerColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(title, style: Textfont.heading2),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.accentColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        title: Text("Settings", style: Textfont.appBar),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GENERAL SETTINGS
            _sectionTitle("General"),
            _card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: soundEffects,
                    onChanged: (val) => setState(() => soundEffects = val),
                    title: Text("Sound Effects", style: Textfont.body),
                    activeColor: AppColors.primaryColor,
                  ),
                  SwitchListTile(
                    value: sessionNotification,
                    onChanged: (val) =>
                        setState(() => sessionNotification = val),
                    title: Text(
                      "Session Completion Notification",
                      style: Textfont.body,
                    ),
                    activeColor: AppColors.primaryColor,
                  ),
                ],
              ),
            ),

            // THEME
            _sectionTitle("Theme"),
            _card(
              child: Column(
                children: ['Light', 'Dark', 'System'].map((mode) {
                  return RadioListTile(
                    value: mode,
                    groupValue: themeMode,
                    activeColor: AppColors.primaryColor,
                    onChanged: (val) => setState(() => themeMode = val!),
                    title: Text(mode, style: Textfont.body),
                  );
                }).toList(),
              ),
            ),

            // RESTRICTION LEVEL
            _sectionTitle("Restriction Levels"),
            _card(
              child: Column(
                children: [
                  ListTile(
                    title: Text("Normal", style: Textfont.body),
                    trailing: Icon(
                      Icons.info_outline,
                      color: AppColors.primaryColor,
                    ),
                    onTap: () {
                      _showInformationDialog(
                        context,
                        'Normal',
                        'Warning dialog on exit attempt. User can exit freely after confirming once.',
                      );
                    },
                  ),
                  ListTile(
                    title: Text("Strict", style: Textfont.body),
                    trailing: Icon(
                      Icons.info_outline,
                      color: AppColors.primaryColor,
                    ),
                    onTap: () {
                      _showInformationDialog(
                        context,
                        'Strict',
                        'Exit requires two-step confirmation with a 5-second countdown before the confirm button becomes active.',
                      );
                    },
                  ),
                  ListTile(
                    title: Text("Extreme", style: Textfont.body),
                    trailing: Icon(
                      Icons.info_outline,
                      color: AppColors.primaryColor,
                    ),
                    onTap: () {
                      _showInformationDialog(
                        context,
                        'Extreme',
                        'Full-screen overlay with back navigation disabled. Exit requires typing a confirmation phrase.',
                      );
                    },
                  ),
                ],
              ),
            ),

            // BLOCKED APPS
            _sectionTitle("Blocked Categories"),
            _card(
              child: Column(
                children: blockedApps.keys.map((key) {
                  return SwitchListTile(
                    value: blockedApps[key]!,
                    onChanged: (val) {
                      setState(() => blockedApps[key] = val);
                    },
                    title: Text(key, style: Textfont.body),
                    activeColor: AppColors.primaryColor,
                  );
                }).toList(),
              ),
            ),

            // ACCOUNT
            _sectionTitle("Account"),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("John Doe", style: Textfont.heading2),
                  Text("johndoe@email.com", style: Textfont.subText),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      // Handle logout
                      Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      ).logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false, // Predicate
                      );
                    },
                    child: Text("Logout", style: Textfont.button2),
                  ),
                ],
              ),
            ),

            // DATA
            _sectionTitle("Data"),
            _card(
              child: ListTile(
                title: Text("Clear All History", style: Textfont.body),
                trailing: Icon(Icons.delete, color: AppColors.dangerColor),
                onTap: _showClearDialog,
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _showInformationDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
