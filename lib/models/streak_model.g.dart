// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StreakModelAdapter extends TypeAdapter<StreakModel> {
  @override
  final typeId = 2;

  @override
  StreakModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StreakModel(
      userId: fields[0] as String,
      streakCount: fields[1] == null ? 0 : (fields[1] as num).toInt(),
      lastCompletedDate: fields[2] as String?,
      dailyHistory: (fields[3] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, StreakModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.streakCount)
      ..writeByte(2)
      ..write(obj.lastCompletedDate)
      ..writeByte(3)
      ..write(obj.dailyHistory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreakModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
