import 'package:commitlock/components/custombottombar.dart';
import 'package:commitlock/core/constants/app_theme.dart';
import 'package:commitlock/providers/session_provider.dart';
import 'package:commitlock/providers/streak_provider.dart';
import 'package:commitlock/screens/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:commitlock/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

Future<void> _checkAuthStatus() async {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  await authProvider.loadAuthData(); // Ensure auth data is loaded before checking status

  if (authProvider.currentUser == null) {
    // If currentUser is null, navigate to login screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    });
    return;
  }

  final userId = authProvider.currentUser!.id; 
  context.read<SessionProvider>().loadSessions(userId);
  context.read<StreakProvider>().loadStreak(userId);

  // Wait for the authentication status to load
  await Future.delayed(Duration(seconds: 2));

  if (authProvider.isAuthenticated) {
    // Navigate to Custombottombar after authentication
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Custombottombar()),
      );
    });
  } else {
    // Navigate to LoginScreen if not authenticated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
        ), // Splash screen loading indicator
      ),
    );
  }
}