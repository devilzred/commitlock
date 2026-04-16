import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:commitlock/models/session_model.dart';
import 'package:commitlock/models/streak_model.dart';

class FakeDataSeeder {
  static const _userId = '1';

  static String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static Future<void> seed() async {
    await _seedStreak();
    await _seedSessions();
  }

  static Future<void> _seedStreak() async {
    final box = Hive.box<StreakModel>('streaks');

    // Clear existing streak for this user
    final existing = box.values.where((s) => s.userId == _userId).toList();
    for (final s in existing) {
      await s.delete();
    }

    final today = DateTime.now();
    final history = <String, String>{};

    // Mon=completed, Tue=missed, Wed–Sat=completed, Sun(today)=pending
    // Relative to today (index 0 = 6 days ago):
    //   days ago:  6       5        4        3        2        1      0(today)
    //   status:  compl  missed   compl    compl    compl   pending  pending
    final plan = [
      (6, 'completed'),
      (5, 'missed'),
      (4, 'completed'),
      (3, 'completed'),
      (2, 'completed'),
      (1, 'completed'), // yesterday = last completed
    ];

    for (final (daysAgo, status) in plan) {
      final day = today.subtract(Duration(days: daysAgo));
      history[_fmt(day)] = status;
    }

    final lastCompleted = _fmt(today.subtract(const Duration(days: 1)));

    final streak = StreakModel(
      userId: _userId,
      streakCount: 4,           // 4 consecutive completed days
      lastCompletedDate: lastCompleted,
      dailyHistory: history,
    );

    await box.add(streak);
  }

  static Future<void> _seedSessions() async {
    final box = Hive.box<SessionModel>('sessions');

    // Clear existing sessions for this user
    final existing = box.values.where((s) => s.userId == _userId).toList();
    for (final s in existing) {
      await s.delete();
    }

    final now = DateTime.now();

    final sessions = [
      // Two active sessions today
      SessionModel(
        id: '${now.millisecondsSinceEpoch}_1',
        userId: _userId,
        habitCategory: 'Study',
        plannedDurationMinutes: 45,
        remainingSeconds: 1800,   // 30 min left
        actualDurationSeconds: 900,
        restrictionLevel: 'Strict',
        penaltyAmount: 50,
        isActive: true,
        isCompleted: false,
        blockedCategories: ['social_media', 'entertainment'],
        createdAt: now.millisecondsSinceEpoch,
      ),
      SessionModel(
        id: '${now.millisecondsSinceEpoch}_2',
        userId: _userId,
        habitCategory: 'Exercise',
        plannedDurationMinutes: 30,
        remainingSeconds: 600,
        actualDurationSeconds: 1200,
        restrictionLevel: 'Normal',
        penaltyAmount: 20,
        isActive: true,
        isCompleted: false,
        blockedCategories: ['games'],
        createdAt: now.millisecondsSinceEpoch - 60000,
      ),
      // One completed session today
      SessionModel(
        id: '${now.millisecondsSinceEpoch}_3',
        userId: _userId,
        habitCategory: 'Reading',
        plannedDurationMinutes: 15,
        remainingSeconds: 0,
        actualDurationSeconds: 900, // exactly 15 min
        restrictionLevel: 'Extreme',
        penaltyAmount: 10,
        isActive: false,
        isCompleted: true,
        blockedCategories: [],
        createdAt: now.subtract(const Duration(hours: 2)).millisecondsSinceEpoch,
      ),
      // Completed session yesterday
      SessionModel(
        id: '${now.millisecondsSinceEpoch}_4',
        userId: _userId,
        habitCategory: 'Study',
        plannedDurationMinutes: 60,
        remainingSeconds: 0,
        actualDurationSeconds: 3600,
        restrictionLevel: 'Strict',
        penaltyAmount: 100,
        isActive: false,
        isCompleted: true,
        blockedCategories: ['social_media'],
        createdAt: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
      ),
      // Broken (quit early) session 2 days ago
      SessionModel(
        id: '${now.millisecondsSinceEpoch}_5',
        userId: _userId,
        habitCategory: 'Meditation',
        plannedDurationMinutes: 20,
        remainingSeconds: 900,
        actualDurationSeconds: 300,
        restrictionLevel: 'Normal',
        penaltyAmount: 5,
        isActive: false,
        isCompleted: false,
        blockedCategories: [],
        createdAt: now.subtract(const Duration(days: 2)).millisecondsSinceEpoch,
      ),
    ];

    for (final s in sessions) {
      await box.put(s.id, s);
    }
  }

  static Future<void> clear() async {
    final sessionBox = Hive.box<SessionModel>('sessions');
    final streakBox = Hive.box<StreakModel>('streaks');

    final sessions = sessionBox.values.where((s) => s.userId == _userId).toList();
    for (final s in sessions) await s.delete();

    final streaks = streakBox.values.where((s) => s.userId == _userId).toList();
    for (final s in streaks) await s.delete();
  }
}