// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionModelAdapter extends TypeAdapter<SessionModel> {
  @override
  final typeId = 0;

  @override
  SessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SessionModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      habitCategory: fields[2] as String,
      plannedDurationMinutes: (fields[3] as num).toInt(),
      remainingSeconds: (fields[4] as num).toInt(),
      actualDurationSeconds: (fields[5] as num).toInt(),
      restrictionLevel: fields[6] as String,
      penaltyAmount: (fields[7] as num).toDouble(),
      isActive: fields[8] as bool,
      isCompleted: fields[9] as bool,
      blockedCategories: (fields[10] as List).cast<String>(),
      createdAt: (fields[11] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, SessionModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.habitCategory)
      ..writeByte(3)
      ..write(obj.plannedDurationMinutes)
      ..writeByte(4)
      ..write(obj.remainingSeconds)
      ..writeByte(5)
      ..write(obj.actualDurationSeconds)
      ..writeByte(6)
      ..write(obj.restrictionLevel)
      ..writeByte(7)
      ..write(obj.penaltyAmount)
      ..writeByte(8)
      ..write(obj.isActive)
      ..writeByte(9)
      ..write(obj.isCompleted)
      ..writeByte(10)
      ..write(obj.blockedCategories)
      ..writeByte(11)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
