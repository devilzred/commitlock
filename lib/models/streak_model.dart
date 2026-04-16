import 'package:hive_ce_flutter/hive_flutter.dart';
part 'streak_model.g.dart';

@HiveType(typeId: 2)
class StreakModel extends HiveObject {
  @HiveField(0)
  String userId;

  @HiveField(1)
  int streakCount;

  @HiveField(2)
  String? lastCompletedDate; // 'YYYY-MM-DD' format

  @HiveField(3)
  Map<String, String> dailyHistory;

  StreakModel({
    required this.userId,
    this.streakCount = 0,
    this.lastCompletedDate,
    Map<String, String>? dailyHistory,
  }) : dailyHistory = dailyHistory ?? {};
}