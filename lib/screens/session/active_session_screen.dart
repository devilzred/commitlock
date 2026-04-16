import 'dart:async';
import 'package:commitlock/components/custombottombar.dart';
import 'package:commitlock/core/constants/app_theme.dart';
import 'package:commitlock/providers/session_provider.dart';
import 'package:commitlock/providers/streak_provider.dart';
import 'package:commitlock/screens/session/session_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveSessionScreen extends StatefulWidget {
  const ActiveSessionScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  State<ActiveSessionScreen> createState() => _ActiveSessionScreenState();
}

class _ActiveSessionScreenState extends State<ActiveSessionScreen> {
  // late String sessionId;
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<String> texts = [
    "You can do this! Stay focused and avoid distractions",
    "Every minute counts towards building your habit",
    "Keep going! The reward is worth the effort",
    "Almost there! Stay strong and finish what you started",
  ];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<SessionProvider>(context, listen: false);

    provider.startTicker(widget.sessionId); // Start ticker for the session.
    startTextScroll();
  }

  void startTextScroll() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!_controller.hasClients) return;

      _currentPage = (_currentPage + 1) % texts.length;

      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    // final provider = Provider.of<SessionProvider>(context, listen: false);
    // final active = provider.activeSessions;
    // if (active.isNotEmpty) {
    //   provider.breakSession(active.first.id);
    // }

    super.dispose();
  }

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final streakProvider = Provider.of<StreakProvider>(context, listen: false);
    return Consumer<SessionProvider>(
      builder: (context, provider, child) {
        // Retrieve the session by its ID
        final session = provider.getById(widget.sessionId);

        // If no session is found, show a message
        if (session == null) {
          return const Scaffold(body: Center(child: Text("Session not found")));
        }

        final remaining = session.remainingSeconds;
        final total = session.plannedDurationMinutes * 60;
        final progress = remaining / total;

        // Navigate to result page when session completes
        if (remaining <= 0 && session.isCompleted) {
          streakProvider.markTodayCompleted();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    SessionResultScreen(sessionId: session.id),
              ),
            );
          });
        }

        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Display session habit category and restriction level
                    Text(session.habitCategory, style: Textfont.large),
                    const SizedBox(height: 10),
                    Text(session.restrictionLevel, style: Textfont.large),
              
                    const SizedBox(height: 40),
              
                    // Circular progress indicator with time display
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: CircularProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            strokeWidth: 6,
                            color: AppColors.primaryColor,
                            backgroundColor: Colors.grey.shade300,
                          ),
                        ),
                        Text(formatTime(remaining), style: Textfont.large),
                      ],
                    ),
              
                    const SizedBox(height: 40),
              
                    // Scrollable motivational texts
                    SizedBox(
                      height: 40,
                      child: PageView.builder(
                        controller: _controller,
                        scrollDirection: Axis.vertical,
                        itemCount: texts.length,
                        itemBuilder: (context, index) {
                          return Center(
                            child: Text(
                              texts[index],
                              style: Textfont.button,
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
              
                    const SizedBox(height: 40),
              
                    // Penalty display
                    Text(
                      "Penalty: \$${session.penaltyAmount} if you fail",
                      style: Textfont.body.copyWith(color: AppColors.dangerColor),
                    ),
              
                    const SizedBox(height: 40),
              
                    // Attempt exit button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentColor,
                        foregroundColor: AppColors.subTextColor,
                      ),
                      onPressed: () async {
                        print("Restriction level: ${session.restrictionLevel}");
                        if (session.restrictionLevel == "Normal") {
                          showNormalDialog(context);
                        }
                        if (session.restrictionLevel == "Strict") {
                          showStrictDialog(context);
                        }
                        if (session.restrictionLevel == "Extreme") {
                          showExtremeDialog(context);
                        }
                      },
                      icon: const Icon(Icons.exit_to_app_rounded),
                      label: const Text("Attempt Exit"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showNormalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Action"),
          content: Text("Do you want to break the session?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Textfont.button.copyWith(color: AppColors.primaryColor),
              ),
              onPressed: () {
                // Mark session as broken
                final sessionProvider = Provider.of<SessionProvider>(
                  context,
                  listen: false,
                );
                sessionProvider.breakSession(widget.sessionId);
                Navigator.of(context).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const Custombottombar(),
                  ),
                  (Route<dynamic> route) => false, // Predicate
                );
              },
              child: Text("Confirm"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Textfont.button.copyWith(color: AppColors.dangerColor),
                foregroundColor: AppColors.dangerColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void showStrictDialog(BuildContext context) {
    int countdown = 5;
    Timer? timer;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Countdown Timer Logic
            if (countdown > 0) {
              timer = Timer.periodic(Duration(seconds: 1), (timer) {
                if (countdown > 0) {
                  setState(() {
                    countdown--;
                  });
                } else {
                  timer.cancel();
                }
              });
            }

            return AlertDialog(
              title: Text("Strict Confirmation"),
              content: Text("Are you sure? Time left: $countdown seconds"),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                textStyle: Textfont.button,
                foregroundColor: AppColors.primaryColor,
              ),
                  onPressed: countdown > 0
                      ? null
                      : () {
                          // Mark session as broken
                          final sessionProvider = Provider.of<SessionProvider>(
                            context,
                            listen: false,
                          );
                          sessionProvider.breakSession(widget.sessionId);
                          Navigator.of(context).pop();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const Custombottombar(),
                            ),
                            (Route<dynamic> route) => false, // Predicate
                          );
                        },
                  child: Text("Confirm"),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                textStyle: Textfont.button,
                foregroundColor: AppColors.dangerColor,
              ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    timer?.cancel();
                  },
                  child: Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showExtremeDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    // Listen to text field changes to update the state
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text("Extreme Confirmation"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    
                    controller: controller,
                    onChanged: (text) {
                      // Rebuild the widget when the text changes
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Type "I am breaking my commitment"',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "The button will be enabled once you type exactly as requested.",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              actions: [
                // Button is enabled only when the correct text is entered
                TextButton(
                  style: TextButton.styleFrom(
                textStyle: Textfont.button,
                foregroundColor: AppColors.primaryColor,
              ),
                  onPressed: controller.text == 'I am breaking my commitment'
                      ? () {
                          // Mark session as broken
                          final sessionProvider = Provider.of<SessionProvider>(
                            context,
                            listen: false,
                          );
                          sessionProvider.breakSession(widget.sessionId);
                          Navigator.of(context).pop();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const Custombottombar(),
                            ),
                            (Route<dynamic> route) => false, // Predicate
                          );
                        }
                      : null,
                  child: Text("Break"),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                textStyle: Textfont.button,
                foregroundColor: AppColors.dangerColor,
              ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
