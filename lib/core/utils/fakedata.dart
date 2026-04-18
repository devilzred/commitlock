// import 'package:hive_ce_flutter/hive_flutter.dart';
// import 'package:commitlock/models/session_model.dart';
// import 'package:commitlock/models/streak_model.dart';

// class FakeDataSeeder {
//   static const _userId = '1';

//   static String _fmt(DateTime d) =>
//       '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

//   static Future<void> seed() async {
//     await _seedStreak();
//     await _seedSessions();
//   }

//   // static Future<void> _seedStreak() async {
//   //   final box = Hive.box<StreakModel>('streaks');

//   //   // Clear existing streak for this user
//   //   final existing = box.values.where((s) => s.userId == _userId).toList();
//   //   for (final s in existing) {
//   //     await s.delete();
//   //   }

//   //   final today = DateTime.now();
//   //   final history = <String, String>{};

//   //   // Mon=completed, Tue=missed, Wed–Sat=completed, Sun(today)=pending
//   //   // Relative to today (index 0 = 6 days ago):
//   //   //   days ago:  6       5        4        3        2        1      0(today)
//   //   //   status:  compl  missed   compl    compl    compl   pending  pending
//   //   final plan = [
//   //     (6, 'completed'),
//   //     (5, 'missed'),
//   //     (4, 'completed'),
//   //     (3, 'completed'),
//   //     (2, 'completed'),
//   //     (1, 'completed'), // yesterday = last completed
//   //   ];

//   //   for (final (daysAgo, status) in plan) {
//   //     final day = today.subtract(Duration(days: daysAgo));
//   //     history[_fmt(day)] = status;
//   //   }

//   //   final lastCompleted = _fmt(today.subtract(const Duration(days: 1)));

//   //   final streak = StreakModel(
//   //     userId: _userId,
//   //     streakCount: 4,           // 4 consecutive completed days
//   //     lastCompletedDate: lastCompleted,
//   //     dailyHistory: history,
//   //   );

//   //   await box.add(streak);
//   // }

//   static Future<void> _seedStreak() async {
//   final box = Hive.box<StreakModel>('streaks');

//   // Clear existing
//   final existing = box.values.where((s) => s.userId == _userId).toList();
//   for (final s in existing) {
//     await s.delete();
//   }

//   // Create EMPTY streak (will be calculated later)
//   final streak = StreakModel(
//     userId: _userId,
//     streakCount: 0,
//     lastCompletedDate: null,
//     dailyHistory: {},
//   );

//   await box.add(streak);
// }

//   // static Future<void> _seedSessions() async {
//   //   final box = Hive.box<SessionModel>('sessions');

//   //   // Clear existing sessions for this user
//   //   final existing = box.values.where((s) => s.userId == _userId).toList();
//   //   for (final s in existing) {
//   //     await s.delete();
//   //   }

//   //   final now = DateTime.now();

//   //   final sessions = [
//   //     // Two active sessions today
//   //     SessionModel(
//   //       id: '${now.millisecondsSinceEpoch}_1',
//   //       userId: _userId,
//   //       habitCategory: 'Study',
//   //       plannedDurationMinutes: 45,
//   //       remainingSeconds: 1800,   // 30 min left
//   //       actualDurationSeconds: 900,
//   //       restrictionLevel: 'Strict',
//   //       penaltyAmount: 50,
//   //       isActive: true,
//   //       isCompleted: false,
//   //       blockedCategories: ['social_media', 'entertainment'],
//   //       createdAt: now.millisecondsSinceEpoch,
//   //     ),
//   //     SessionModel(
//   //       id: '${now.millisecondsSinceEpoch}_2',
//   //       userId: _userId,
//   //       habitCategory: 'Exercise',
//   //       plannedDurationMinutes: 30,
//   //       remainingSeconds: 600,
//   //       actualDurationSeconds: 1200,
//   //       restrictionLevel: 'Normal',
//   //       penaltyAmount: 20,
//   //       isActive: true,
//   //       isCompleted: false,
//   //       blockedCategories: ['games'],
//   //       createdAt: now.millisecondsSinceEpoch - 60000,
//   //     ),
//   //     // One completed session today
//   //     SessionModel(
//   //       id: '${now.millisecondsSinceEpoch}_3',
//   //       userId: _userId,
//   //       habitCategory: 'Reading',
//   //       plannedDurationMinutes: 15,
//   //       remainingSeconds: 0,
//   //       actualDurationSeconds: 900, // exactly 15 min
//   //       restrictionLevel: 'Extreme',
//   //       penaltyAmount: 10,
//   //       isActive: false,
//   //       isCompleted: true,
//   //       blockedCategories: [],
//   //       createdAt: now.subtract(const Duration(hours: 2)).millisecondsSinceEpoch,
//   //     ),
//   //     // Completed session yesterday
//   //     SessionModel(
//   //       id: '${now.millisecondsSinceEpoch}_4',
//   //       userId: _userId,
//   //       habitCategory: 'Study',
//   //       plannedDurationMinutes: 60,
//   //       remainingSeconds: 0,
//   //       actualDurationSeconds: 3600,
//   //       restrictionLevel: 'Strict',
//   //       penaltyAmount: 100,
//   //       isActive: false,
//   //       isCompleted: true,
//   //       blockedCategories: ['social_media'],
//   //       createdAt: now.subtract(const Duration(days: 1)).millisecondsSinceEpoch,
//   //     ),
//   //     // Broken (quit early) session 2 days ago
//   //     SessionModel(
//   //       id: '${now.millisecondsSinceEpoch}_5',
//   //       userId: _userId,
//   //       habitCategory: 'Meditation',
//   //       plannedDurationMinutes: 20,
//   //       remainingSeconds: 900,
//   //       actualDurationSeconds: 300,
//   //       restrictionLevel: 'Normal',
//   //       penaltyAmount: 5,
//   //       isActive: false,
//   //       isCompleted: false,
//   //       blockedCategories: [],
//   //       createdAt: now.subtract(const Duration(days: 2)).millisecondsSinceEpoch,
//   //     ),
//   //   ];

//   //   for (final s in sessions) {
//   //     await box.put(s.id, s);
//   //   }
//   // }

// static Future<void> _seedSessions() async {
//   final box = Hive.box<SessionModel>('sessions');

//   final existing = box.values.where((s) => s.userId == _userId).toList();
//   for (final s in existing) {
//     await s.delete();
//   }

//   final now = DateTime.now();

//   SessionModel buildSession({
//     required DateTime date,
//     required bool completed,
//   }) {
//     return SessionModel(
//       id: '${date.millisecondsSinceEpoch}_${completed ? 1 : 0}',
//       userId: _userId,
//       habitCategory: 'Test',
//       plannedDurationMinutes: 30,
//       remainingSeconds: completed ? 0 : 600,
//       actualDurationSeconds: completed ? 1800 : 600,
//       restrictionLevel: 'Normal',
//       penaltyAmount: 10,
//       isActive: false,
//       isCompleted: completed,
//       blockedCategories: [],
//       createdAt: date.millisecondsSinceEpoch,
//     );
//   }

//   final sessions = <SessionModel>[
//     // 6 days ago → completed
//     buildSession(date: now.subtract(const Duration(days: 6)), completed: true),

//     // 5 days ago → missed (broken)
//     buildSession(date: now.subtract(const Duration(days: 5)), completed: false),

//     // 4 days ago → completed
//     buildSession(date: now.subtract(const Duration(days: 4)), completed: true),

//     // 3 days ago → completed
//     buildSession(date: now.subtract(const Duration(days: 3)), completed: true),

//     // 2 days ago → completed
//     buildSession(date: now.subtract(const Duration(days: 2)), completed: true),

//     // yesterday → completed ✅
//     buildSession(date: now.subtract(const Duration(days: 1)), completed: true),

//     // TODAY → mixed (should NOT count yet)
//     buildSession(date: now, completed: true),
//     buildSession(date: now.add(const Duration(minutes: 1)), completed: false),
//   ];

//   for (final s in sessions) {
//     await box.put(s.id, s);
//   }
// }


//   static Future<void> clear() async {
//     final sessionBox = Hive.box<SessionModel>('sessions');
//     final streakBox = Hive.box<StreakModel>('streaks');

//     final sessions = sessionBox.values.where((s) => s.userId == _userId).toList();
//     for (final s in sessions) await s.delete();

//     final streaks = streakBox.values.where((s) => s.userId == _userId).toList();
//     for (final s in streaks) await s.delete();
//   }
// }

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:commitlock/models/session_model.dart';
import 'package:commitlock/models/streak_model.dart';

class FakeDataSeeder {
  static const _userId = '1';

  // ─── Public API ────────────────────────────────────────────────────────────

  static Future<void> seed() async {
    await clear();
    await _seedSessions();
    await _seedStreak();
  }

  static Future<void> clear() async {
    final sessionBox = Hive.box<SessionModel>('sessions');
    final streakBox = Hive.box<StreakModel>('streaks');

    for (final s in sessionBox.values.where((s) => s.userId == _userId).toList()) {
      await s.delete();
    }
    for (final s in streakBox.values.where((s) => s.userId == _userId).toList()) {
      await s.delete();
    }
  }

  // ─── Sessions ──────────────────────────────────────────────────────────────
  //
  // Day layout (relative to today):
  //
  //  6 days ago → 2 sessions, both completed   → streak: completed ✅
  //  5 days ago → 1 session,  broken           → streak: missed    ❌
  //  4 days ago → 2 sessions, both completed   → streak: completed ✅  (resets here)
  //  3 days ago → 2 sessions, both completed   → streak: completed ✅
  //  2 days ago → 2 sessions, both completed   → streak: completed ✅
  //  yesterday  → 2 sessions, both completed   → streak: completed ✅  (count = 4)
  //  today      → 2 sessions, 1 active 1 done  → pending ⏳

  static Future<void> _seedSessions() async {
    final box = Hive.box<SessionModel>('sessions');
    final now = DateTime.now();

    // Helper to get epoch ms for a given day offset + hour
    int ts(int daysAgo, {int hour = 9}) {
      final d = now.subtract(Duration(days: daysAgo));
      return DateTime(d.year, d.month, d.day, hour)
          .millisecondsSinceEpoch;
    }

    final sessions = [
      // ── 6 days ago: all completed ─────────────────────────────────────────
      _make(id: 's_6a', daysAgo: 6, hour: 9,
        category: 'Study', planned: 60,
        actual: 3600, remaining: 0,
        isActive: false, isCompleted: true,
        restriction: 'strict', penalty: 100,
        blocked: ['social_media', 'entertainment'],
      ),
      _make(id: 's_6b', daysAgo: 6, hour: 11,
        category: 'Exercise', planned: 30,
        actual: 1800, remaining: 0,
        isActive: false, isCompleted: true,
        restriction: 'moderate', penalty: 20,
        blocked: ['games'],
      ),

      // ── 5 days ago: broken (missed day) ───────────────────────────────────
      _make(id: 's_5a', daysAgo: 5, hour: 9,
        category: 'Study', planned: 45,
        actual: 600, remaining: 2100,   // quit early
        isActive: false, isCompleted: false,
        restriction: 'strict', penalty: 50,
        blocked: ['social_media'],
      ),

      // ── 4 days ago: all completed (streak resets here after miss) ──────────
      _make(id: 's_4a', daysAgo: 4, hour: 8,
        category: 'Reading', planned: 20,
        actual: 1200, remaining: 0,
        isActive: false, isCompleted: true,
        restriction: 'light', penalty: 10,
        blocked: [],
      ),
      _make(id: 's_4b', daysAgo: 4, hour: 10,
        category: 'Study', planned: 60,
        actual: 3600, remaining: 0,
        isActive: false, isCompleted: true,
        restriction: 'strict', penalty: 100,
        blocked: ['social_media'],
      ),

      // ── 3 days ago: all completed ─────────────────────────────────────────
      _make(id: 's_3a', daysAgo: 3, hour: 9,
        category: 'Meditation', planned: 15,
        actual: 900, remaining: 0,
        isActive: false, isCompleted: true,
        restriction: 'light', penalty: 5,
        blocked: [],
      ),
      _make(id: 's_3b', daysAgo: 3, hour: 14,
        category: 'Exercise', planned: 45,
        actual: 2700, remaining: 0,
        isActive: false, isCompleted: true,
        restriction: 'moderate', penalty: 30,
        blocked: ['games', 'entertainment'],
      ),

      // ── 2 days ago: all completed ─────────────────────────────────────────
      _make(id: 's_2a', daysAgo: 2, hour: 8,
        category: 'Study', planned: 90,
        actual: 5400, remaining: 0,
        isActive: false, isCompleted: true,
        restriction: 'strict', penalty: 150,
        blocked: ['social_media', 'entertainment', 'games'],
      ),
      _make(id: 's_2b', daysAgo: 2, hour: 11,
        category: 'Reading', planned: 30,
        actual: 1800, remaining: 0,
        isActive: false, isCompleted: true,
        restriction: 'light', penalty: 10,
        blocked: [],
      ),

      // ── Yesterday: all completed ───────────────────────────────────────────
      _make(id: 's_1a', daysAgo: 1, hour: 9,
        category: 'Study', planned: 60,
        actual: 3600, remaining: 0,
        isActive: false, isCompleted: true,
        restriction: 'strict', penalty: 100,
        blocked: ['social_media'],
      ),
      _make(id: 's_1b', daysAgo: 1, hour: 14,
        category: 'Exercise', planned: 30,
        actual: 1800, remaining: 0,
        isActive: false, isCompleted: true,
        restriction: 'moderate', penalty: 20,
        blocked: ['games'],
      ),

      // ── Today: 1 completed, 1 still active ────────────────────────────────
      _make(id: 's_0a', daysAgo: 0, hour: 8,
        category: 'Reading', planned: 20,
        actual: 1200, remaining: 0,
        isActive: false, isCompleted: true,
        restriction: 'light', penalty: 10,
        blocked: [],
      ),
      _make(id: 's_0b', daysAgo: 0, hour: 10,
        category: 'Study', planned: 45,
        actual: 900, remaining: 1800,   // 30 min left
        isActive: true, isCompleted: false,
        restriction: 'strict', penalty: 50,
        blocked: ['social_media', 'entertainment'],
      ),
    ];

    for (final s in sessions) {
      await box.put(s.id, s);
    }
  }

  // ─── Streak ────────────────────────────────────────────────────────────────
  //
  // We only write dailyHistory here.
  // streakCount + lastCompletedDate are intentionally left at defaults (0 / null)
  // because StreakProvider._recalculateStreak() will recompute them on loadStreak().
  //
  // Expected result after provider loads:
  //   streakCount = 4  (4 days ago → yesterday, consecutive)
  //   lastCompletedDate = yesterday

  static Future<void> _seedStreak() async {
    final box = Hive.box<StreakModel>('streaks');
    final now = DateTime.now();

    String fmt(int daysAgo) {
      final d = now.subtract(Duration(days: daysAgo));
      return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }

    final history = <String, String>{
      fmt(6): 'completed',
      fmt(5): 'missed',      // broken day — streak resets after this
      fmt(4): 'completed',
      fmt(3): 'completed',
      fmt(2): 'missed',
      fmt(1): 'completed',
      // today (fmt(0)) intentionally absent — provider keeps it pending
    };

    final streak = StreakModel(
      userId: _userId,
      // streakCount and lastCompletedDate deliberately omitted —
      // _recalculateStreak() owns those values
      dailyHistory: history,
    );

    await box.add(streak);
  }

  // ─── Factory helper ────────────────────────────────────────────────────────

  static SessionModel _make({
    required String id,
    required int daysAgo,
    required int hour,
    required String category,
    required int planned,
    required int actual,
    required int remaining,
    required bool isActive,
    required bool isCompleted,
    required String restriction,
    required double penalty,
    required List<String> blocked,
  }) {
    final now = DateTime.now();
    final d = now.subtract(Duration(days: daysAgo));
    final createdAt = DateTime(d.year, d.month, d.day, hour)
        .millisecondsSinceEpoch;

    return SessionModel(
      id: id,
      userId: _userId,
      habitCategory: category,
      plannedDurationMinutes: planned,
      remainingSeconds: remaining,
      actualDurationSeconds: actual,
      restrictionLevel: restriction,
      penaltyAmount: penalty,
      isActive: isActive,
      isCompleted: isCompleted,
      blockedCategories: blocked,
      createdAt: createdAt,
    );
  }
}