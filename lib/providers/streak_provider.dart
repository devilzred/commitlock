import 'package:commitlock/components/streakmenu.dart';
import 'package:commitlock/models/streak_model.dart';
import 'package:commitlock/providers/session_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class StreakProvider extends ChangeNotifier {
  StreakModel? _streak;

  int get streakCount => _streak?.streakCount ?? 0;
  String? get lastCompletedDate => _streak?.lastCompletedDate;

  // ─── Load ────────────────────────────────────────────────────────────────

  void loadStreak(String userId, SessionProvider sessionProvider) {
    final box = Hive.box<StreakModel>('streaks');

    _streak = box.values.firstWhere(
      (s) => s.userId == userId,
      orElse: () {
        final newStreak = StreakModel(userId: userId);
        box.add(newStreak);
        return newStreak;
      },
    );

    // Evaluate all past unresolved days every time app opens
    _evaluatePastDays(sessionProvider);

    _recalculateStreak();

    notifyListeners();
  }

  void clear() {
    _streak = null;
    notifyListeners();
  }

  // ─── Core evaluation ─────────────────────────────────────────────────────

  /// Called on load. Walks every day from the earliest session up to
  /// (but NOT including) today, and resolves any that are still pending.
  void _evaluatePastDays(SessionProvider sessionProvider) {
    if (_streak == null) return;

    final today = _dateOnly(DateTime.now());

    // Collect all distinct past session dates (excluding today)
    final pastDates = sessionProvider.sessions
        .where((s) => s.createdAt != null)
        .map((s) => _dateOnly(DateTime.fromMillisecondsSinceEpoch(s.createdAt!)))
        .where((d) => d.isBefore(today))
        .toSet()
        .toList()
      ..sort();

    if (pastDates.isEmpty) return;

    bool changed = false;

    for (final date in pastDates) {
      final key = _fmt(date);

      // Skip already-resolved days
      if (_streak!.dailyHistory.containsKey(key)) continue;

      final sessionsOnDay = sessionProvider.sessions.where((s) {
        if (s.createdAt == null) return false;
        return _dateOnly(
          DateTime.fromMillisecondsSinceEpoch(s.createdAt!),
        ) == date;
      }).toList();

      // No sessions on this day → skip (don't mark as missed,
      // user may not have planned anything)
      if (sessionsOnDay.isEmpty) continue;

      final allCompleted = sessionsOnDay.every((s) => s.isCompleted);
      _streak!.dailyHistory[key] = allCompleted ? 'completed' : 'missed';
      changed = true;
    }

    if (changed) {
      _recalculateStreak();
      _streak!.save();
    }
  }

  /// Called when a session is broken or completed during the day.
  /// Does NOT touch today's streak count — only updates history for past days.
  /// Today's streak is resolved tomorrow when app opens.
  void onSessionChanged(SessionProvider sessionProvider) {
    _evaluatePastDays(sessionProvider);
    notifyListeners();
  }

  // ─── Streak count recalculation ──────────────────────────────────────────

  /// Recomputes streakCount from scratch by walking dailyHistory in order.
  /// This is the only place streak math lives — no more +1/-1 scattered around.
  void _recalculateStreak() {
    if (_streak == null) return;

    final completed = _streak!.dailyHistory.entries
        .where((e) => e.value == 'completed')
        .map((e) => DateTime.parse(e.key))
        .toList()
      ..sort();

    if (completed.isEmpty) {
      _streak!.streakCount = 0;
      _streak!.lastCompletedDate = null;
      return;
    }

    // Walk backwards from most recent completed day,
    // count consecutive days with no gap
    int streak = 1;
    for (int i = completed.length - 1; i > 0; i--) {
      final diff = completed[i].difference(completed[i - 1]).inDays;
      if (diff == 1) {
        streak++;
      } else {
        // Gap found — streak resets here
        break;
      }
    }

    _streak!.streakCount = streak;
    _streak!.lastCompletedDate = _fmt(completed.last);
  }

  // ─── UI data ─────────────────────────────────────────────────────────────

  List<StreakStatus> get weekData {
    final today = DateTime.now();
    // Mon = start of week
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));

    return List.generate(7, (i) {
      final day = startOfWeek.add(Duration(days: i));
      final key = _fmt(day);

      // Today and future days are always pending
      if (!_dateOnly(day).isBefore(_dateOnly(today))) {
        return StreakStatus.pending;
      }

      final status = _streak?.dailyHistory[key];
      return switch (status) {
        'completed' => StreakStatus.completed,
        'missed' => StreakStatus.missed,
        _ => StreakStatus.pending, // past day with no sessions → neutral
      };
    });
  }

  Map<String, StreakStatus> getMonthData(int year, int month) {
    final result = <String, StreakStatus>{};
    final today = _dateOnly(DateTime.now());
    final daysInMonth = DateUtils.getDaysInMonth(year, month);

    for (int d = 1; d <= daysInMonth; d++) {
      final date = DateTime(year, month, d);
      final key = _fmt(date);

      if (!date.isBefore(today)) {
        result[key] = StreakStatus.pending;
        continue;
      }

      final status = _streak?.dailyHistory[key];
      result[key] = switch (status) {
        'completed' => StreakStatus.completed,
        'missed' => StreakStatus.missed,
        _ => StreakStatus.pending,
      };
    }
    return result;
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}