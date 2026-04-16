import 'package:commitlock/components/streakmenu.dart';
import 'package:commitlock/models/streak_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class StreakProvider extends ChangeNotifier {
  StreakModel? _streak;

  int get streakCount => _streak?.streakCount ?? 0;
  String? get lastCompletedDate => _streak?.lastCompletedDate;


  void loadStreak(String userId) {
    final box = Hive.box<StreakModel>('streaks');

    // Find existing or create new for this user
    _streak = box.values.firstWhere(
      (s) => s.userId == userId,
      orElse: () {
        final newStreak = StreakModel(userId: userId);
        box.add(newStreak);
        return newStreak;
      },
    );

    _advanceWindow(); // mark any missed days since last open
    notifyListeners();
  }

  void clear() {
    _streak = null;
    notifyListeners();
  }

  // Always computed fresh from dailyHistory — last 7 days including today
  List<StreakStatus> get weekData {
    final today = DateTime.now();
    return List.generate(7, (i) {
      final day = today.subtract(Duration(days: 6 - i));
      final key = _fmt(day);
      final status = _streak?.dailyHistory[key];
      return switch (status) {
        'completed' => StreakStatus.completed,
        'missed' => StreakStatus.missed,
        _ => StreakStatus.pending,
      };
    });
  }

  // You can also expose monthly data later:
  Map<String, StreakStatus> getMonthData(int year, int month) {
    final result = <String, StreakStatus>{};
    final daysInMonth = DateUtils.getDaysInMonth(year, month);

    for (int d = 1; d <= daysInMonth; d++) {
      final key = _fmt(DateTime(year, month, d));
      final status = _streak?.dailyHistory[key];
      result[key] = switch (status) {
        'completed' => StreakStatus.completed,
        'missed' => StreakStatus.missed,
        _ => StreakStatus.pending,
      };
    }
    return result;
  }

  Future<void> markTodayCompleted() async {
    if (_streak == null) return;

    final today = _fmt(DateTime.now());
    if (_streak!.lastCompletedDate == today) return;

    final lastDate = _streak!.lastCompletedDate;

    if (lastDate != null) {
      final last = DateTime.parse(lastDate);
      final todayDate = _dateOnly(DateTime.now());
      final diff = todayDate.difference(_dateOnly(last)).inDays;

      if (diff == 1) {
        _streak!.streakCount++; // continued streak
      } else if (diff > 1) {
        _streak!.streakCount = 1; // gap found, reset
      }
    } else {
      _streak!.streakCount = 1; // first ever
    }

    _streak!.dailyHistory[today] = 'completed';
    _streak!.lastCompletedDate = today;
    await _streak!.save();
    notifyListeners();
  }

  // Marks past pending days as missed + reduces streak
  void _advanceWindow() {
    if (_streak == null) return;
    final lastDate = _streak!.lastCompletedDate;
    if (lastDate == null) return;

    final last = _dateOnly(DateTime.parse(lastDate));
    final today = _dateOnly(DateTime.now());
    final missedDays = today.difference(last).inDays - 1;

    if (missedDays <= 0) return;

    bool changed = false;
    for (int i = 1; i <= missedDays; i++) {
      final missed = last.add(Duration(days: i));
      if (missed.isBefore(today)) {
        final key = _fmt(missed);
        _streak!.dailyHistory[key] = 'missed';
        changed = true;
      }
    }

    if (changed) {
      _streak!.streakCount = (_streak!.streakCount - missedDays).clamp(0, 999);
      _streak!.save();
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}