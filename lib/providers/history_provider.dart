import 'package:commitlock/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
class HistoryProvider with ChangeNotifier {
  Box<SessionModel>? _sessionBox;
  List<SessionModel> allSessions = []; // All sessions before filtering
  List<SessionModel> filteredsessions = [];
  List<SessionModel> get sessions => filteredsessions;

  // Initialize Hive Box and load sessions
  Future<void> init() async {
    _sessionBox = await Hive.openBox<SessionModel>('sessions');
    loadSessions(); // Load sessions initially
    notifyListeners();
  }

  // Load sessions from the Hive Box
  void loadSessions() {
    allSessions = (_sessionBox?.values
        .where((s) => s.createdAt! <= DateTime.now().microsecondsSinceEpoch)
        .toList()
      ?? [])
  ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));// Store all sessions
  
    filteredsessions = List.from(allSessions); // Initially show all sessions
    notifyListeners();
  }

  // Filter sessions by completion status
  void filterSessions({required bool isCompleted}) {
    // Reset filteredsessions to the full list before applying the filter
    filteredsessions = allSessions.where((session) => session.isCompleted == isCompleted).toList();
    notifyListeners();
  }
}