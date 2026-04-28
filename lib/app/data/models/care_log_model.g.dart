// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'care_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CareLogModelAdapter extends TypeAdapter<CareLogModel> {
  @override
  final int typeId = 2;

  @override
  CareLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CareLogModel(
      id: fields[0] as String?,
      plantId: fields[1] as String,
      plantName: fields[2] as String,
      logType: fields[3] as String,
      date: fields[4] as DateTime,
      notes: fields[5] as String?,
      photoPath: fields[6] as String?,
      amount: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CareLogModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.plantId)
      ..writeByte(2)
      ..write(obj.plantName)
      ..writeByte(3)
      ..write(obj.logType)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.photoPath)
      ..writeByte(7)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CareLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
