import 'package:commitlock/core/constants/app_theme.dart';
import 'package:commitlock/models/session_model.dart';
import 'package:commitlock/models/streak_model.dart';
import 'package:commitlock/models/user_model.dart';
import 'package:commitlock/providers/auth_provider.dart';
import 'package:commitlock/providers/history_provider.dart';
import 'package:commitlock/providers/session_provider.dart';
import 'package:commitlock/providers/streak_provider.dart';
import 'package:commitlock/screens/auth/spalshscreen.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await Hive.initFlutter();
    

  Hive.registerAdapter(SessionModelAdapter());
  await Hive.openBox<SessionModel>('sessions');

  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('users');

  Hive.registerAdapter(StreakModelAdapter());
  await Hive.openBox<StreakModel>('streaks');
  


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StreakProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        
      ],
    child: const MyApp()
    )
    );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor:AppColors.backgroundColor,
        appBarTheme: const AppBarTheme(
          titleTextStyle: Textfont.appBar,
          centerTitle: true,
          backgroundColor: AppColors.backgroundColor,
          foregroundColor: AppColors.textColor,
          elevation: 1,
          
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.backgroundColor,
            textStyle: Textfont.button2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        
        
      ),
      debugShowCheckedModeBanner: false,
      home:SplashScreen(),
    );
  }

}


