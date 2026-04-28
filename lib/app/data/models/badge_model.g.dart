// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BadgeModelAdapter extends TypeAdapter<BadgeModel> {
  @override
  final int typeId = 6;

  @override
  BadgeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BadgeModel(
      id: fields[0] as String,
      name: fields[1] as String,
      nameBn: fields[2] as String,
      description: fields[3] as String,
      descriptionBn: fields[4] as String,
      category: fields[5] as String,
      iconEmoji: fields[6] as String,
      iconColor: fields[7] as int,
      isEarned: fields[8] as bool,
      earnedDate: fields[9] as DateTime?,
      requiredCount: fields[10] as int,
      currentCount: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BadgeModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.nameBn)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.descriptionBn)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.iconEmoji)
      ..writeByte(7)
      ..write(obj.iconColor)
      ..writeByte(8)
      ..write(obj.isEarned)
      ..writeByte(9)
      ..write(obj.earnedDate)
      ..writeByte(10)
      ..write(obj.requiredCount)
      ..writeByte(11)
      ..write(obj.currentCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BadgeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
