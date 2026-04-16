import 'package:commitlock/core/constants/app_theme.dart';
import 'package:commitlock/screens/history/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:commitlock/providers/session_provider.dart';

class SessionResultScreen extends StatelessWidget {
  final String sessionId;

  SessionResultScreen({required this.sessionId});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final session = sessionProvider.getById(sessionId);

    if (session == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Session Not Found"),
        ),
        body: Center(child: Text("Session data could not be found.")),
      );
    }

    final outcome = session.isCompleted ? 'Completed' : 'Broken';
    final outcomeColor = session.isCompleted ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text("Session Result",)
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Outcome Section
            Text(
              outcome == 'Completed' ? 'Session Completed' : 'Session Broken',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: outcomeColor,
              ),
            ),
            SizedBox(height: 20),
            // Habit Category
            Text('Habit Category: ${session.habitCategory}', style: Textfont.body),
            SizedBox(height: 10),
            // Planned Duration
            Text('Planned Duration: ${session.plannedDurationMinutes} min', style: Textfont.body),
            SizedBox(height: 10),
            // Actual Time Spent
            Text('Actual Time Spent: ${session.actualDurationSeconds ~/ 60} min', style: Textfont.body),
            SizedBox(height: 10),
            // Restriction Level
            Text('Restriction Level: ${session.restrictionLevel}', style: Textfont.body),
            SizedBox(height: 10),
            // Penalty Amount
            Text('Penalty Amount: \$${session.penaltyAmount.toString()}', style: Textfont.body),
            SizedBox(height: 30),

            // Outcome Specific Section
            if (session.isCompleted) ...[
              // Completed Outcome
              Text(
                'Great Job! You’ve maintained your streak!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
              ),
              SizedBox(height: 10),
              // Current Streak (you can track this separately in your provider if needed)
              // Text('Current Streak: ${session.streakCount}', style: TextStyle(fontSize: 18)),
            ] else ...[
              // Broken Outcome
              Text(
                'You broke your streak. Don’t worry, you can try again!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.dangerColor),
              ),
              SizedBox(height: 10),
              Text('Penalty Reminder: \$${session.penaltyAmount.toString()} will be deducted.', style: Textfont.body),
            ],

            Spacer(),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Return to Dashboard Logic
                    Navigator.pop(context);
                  },
                  child: Text('Return to Dashboard'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // View History Logic
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HistoryScreen(),
                        ),
                      );
                  },
                  child: Text('View History'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}