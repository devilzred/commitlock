import 'package:commitlock/core/constants/app_theme.dart';
import 'package:flutter/material.dart';

enum StreakStatus { completed, missed, pending }

class WeeklyStreak extends StatelessWidget {
  final List<StreakStatus> weekData;
  final List<String> days;

  const WeeklyStreak({
    super.key,
    required this.weekData,
    this.days = const ["M", "T", "W", "T", "F", "S", "S"],
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StreakCircle(status: weekData[index]),
            const SizedBox(height: 6),
            Text(
              days[index],
              style: Textfont.subText,
            ),
          ],
        );
      }),
    );
  }
}

class _StreakCircle extends StatelessWidget {
  final StreakStatus status;

  const _StreakCircle({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    IconData? icon;

    switch (status) {
      case StreakStatus.completed:
        bgColor = AppColors.primaryColor;
        icon = Icons.check;
        break;
      case StreakStatus.missed:
        bgColor = AppColors.dangerColor;
        icon = Icons.close;
        break;
      case StreakStatus.pending:
        bgColor = AppColors.accentColor;
        icon = null;
        break;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: icon != null
          ? Icon(icon, color: Colors.white, size: 20)
          : null,
    );
  }
}