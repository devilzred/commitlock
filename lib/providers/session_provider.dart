import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:commitlock/models/session_model.dart';

class SessionProvider extends ChangeNotifier {
  List<SessionModel> _sessions = [];
  Timer? _ticker;
  String? _runningSessionId;

  List<SessionModel> get sessions => _sessions;

  List<SessionModel> get activeSessions =>
      _sessions.where((s) => s.isActive).toList();

  // VoidCallback? _onSessionChanged;

// void setOnSessionChanged(VoidCallback cb) {
//   _onSessionChanged = cb;
// }


  void loadSessions(String userId) {

    final box = Hive.box<SessionModel>('sessions');

    _sessions = box.values.whereType<SessionModel>().where((u)=>u.userId == userId).toList();
    notifyListeners();
  }

  SessionModel? getById(String id) {
    try {
      return _sessions.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  String startSession({
    required String userId, 
    required String habitCategory,
    required int plannedMinutes,
    required double penaltyAmount,
    required String restrictionLevel,
    required List<String> blockedCategories,
  }) {
    final box = Hive.box<SessionModel>('sessions');

    final session = SessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      habitCategory: habitCategory,
      plannedDurationMinutes: plannedMinutes,
      remainingSeconds: plannedMinutes * 60,
      actualDurationSeconds: 0,
      restrictionLevel: restrictionLevel,
      penaltyAmount: penaltyAmount,
      isActive: true,
      isCompleted: false,
      blockedCategories: blockedCategories,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    box.put(session.id, session);
    _sessions.add(session);

    notifyListeners();
    return session.id;
  }

  void startTicker(String sessionId) {
    final session = getById(sessionId);
    if (session == null) return;

    if (!session.isActive || session.isCompleted) return;

    if (_runningSessionId == sessionId && _ticker != null) return;

    stopTicker();

    _runningSessionId = sessionId;

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      // final current = getById(sessionId);

      // if (current == null) {
      //   stopTicker();
      //   return;
      // }

      // if (!current.isActive || current.isCompleted) {
      //   stopTicker();
      //   return;
      // }

      session.remainingSeconds--;
      session.actualDurationSeconds++;

      if (session.remainingSeconds <= 0) {
        session.remainingSeconds = 0;
        session.isActive = false;
        session.isCompleted = true;
        stopTicker();
      }

      session.save();
      notifyListeners();
    });
  }

  void stopTicker() {
    _ticker?.cancel();
    _ticker = null;
    _runningSessionId = null;
  }

  void breakSession(String id) {
    final session = getById(id);
    if (session == null) return;

    session.isActive = false;
    session.isCompleted = false;
    session.save();

    if (_runningSessionId == id) {
      stopTicker();
    }

    notifyListeners();
    //  _onSessionChanged?.call();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

  List<SessionModel> get todaySessions {
  final today = DateTime.now();
  return _sessions.where((s) {
    if (s.createdAt == null) return false;
    return _isSameDay(DateTime.fromMillisecondsSinceEpoch(s.createdAt!), today);
  }).toList();
}

/// Total minutes the user committed to today
int get todayPlannedMinutes =>
    todaySessions.fold(0, (sum, s) => sum + s.plannedDurationMinutes);

/// Total minutes actually completed today
int get todayCompletedMinutes =>
    (todaySessions.fold(0, (sum, s) => sum + s.actualDurationSeconds) / 60)
        .floor();

/// True if at least one session was fully completed today
// bool get hasCompletedSessionToday =>
//     todaySessions.any((s) => s.isCompleted);

    void clearData(String userId) {
    final box = Hive.box<SessionModel>('sessions');
    box.clear();
    loadSessions(userId);
    notifyListeners();
  }
    

  @override
  void dispose() {
    stopTicker();
    super.dispose();
  }
}