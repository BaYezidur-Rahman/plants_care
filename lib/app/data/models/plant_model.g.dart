// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantModelAdapter extends TypeAdapter<PlantModel> {
  @override
  final int typeId = 0;

  @override
  PlantModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantModel(
      id: fields[0] as String?,
      name: fields[1] as String,
      nameBn: fields[2] as String,
      category: fields[3] as String,
      location: fields[4] as String,
      datePlanted: fields[5] as DateTime,
      photoPath: fields[6] as String?,
      notes: fields[7] as String?,
      healthScore: fields[8] as int,
      waterFrequency: fields[9] as String,
      sunlightNeed: fields[10] as String,
      lastWatered: fields[11] as DateTime?,
      lastFertilized: fields[12] as DateTime?,
      lastPruned: fields[13] as DateTime?,
      createdAt: fields[14] as DateTime?,
      nickname: fields[15] as String,
      nicknameBn: fields[16] as String,
      isFavorite: fields[17] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PlantModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.nameBn)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.datePlanted)
      ..writeByte(6)
      ..write(obj.photoPath)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.healthScore)
      ..writeByte(9)
      ..write(obj.waterFrequency)
      ..writeByte(10)
      ..write(obj.sunlightNeed)
      ..writeByte(11)
      ..write(obj.lastWatered)
      ..writeByte(12)
      ..write(obj.lastFertilized)
      ..writeByte(13)
      ..write(obj.lastPruned)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.nickname)
      ..writeByte(16)
      ..write(obj.nicknameBn)
      ..writeByte(17)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
