import 'package:hive_ce_flutter/hive_flutter.dart';
part 'session_model.g.dart';

@HiveType(typeId: 0)
class SessionModel extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String userId;
  @HiveField(2) String habitCategory;
  @HiveField(3) int plannedDurationMinutes;
  @HiveField(4) int remainingSeconds;
  @HiveField(5) int actualDurationSeconds;
  @HiveField(6) String restrictionLevel;
  @HiveField(7) double penaltyAmount;
  @HiveField(8) bool isActive;
  @HiveField(9) bool isCompleted;
  @HiveField(10) List<String> blockedCategories;
  @HiveField(11) int? createdAt; // NEW — epoch ms, nullable for old records

  SessionModel({
    required this.id,
    required this.userId,
    required this.habitCategory,
    required this.plannedDurationMinutes,
    required this.remainingSeconds,
    required this.actualDurationSeconds,
    required this.restrictionLevel,
    required this.penaltyAmount,
    required this.isActive,
    required this.isCompleted,
    required this.blockedCategories,
    int? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch;
}