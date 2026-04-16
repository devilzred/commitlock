import 'package:commitlock/core/constants/app_theme.dart';
import 'package:commitlock/screens/session/active_session_screen.dart';
import 'package:flutter/material.dart';
class ActiveSessionCard extends StatelessWidget {
  final dynamic session; // replace with your model type

  const ActiveSessionCard({
    super.key,
    required this.session,
  });

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final remaining = session.remainingSeconds;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accentColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Project ${session.habitCategory}',
                style: Textfont.body,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text('Pending Time: ', style: Textfont.subText),
                  Text(
                    _formatTime(remaining),
                    style: Textfont.button,
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ActiveSessionScreen(sessionId: session.id),
                ),
              );
            },
            child: const Text('Resume'),
          ),
        ],
      ),
    );
  }
}