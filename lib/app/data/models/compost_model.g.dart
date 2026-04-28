// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compost_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompostModelAdapter extends TypeAdapter<CompostModel> {
  @override
  final int typeId = 5;

  @override
  CompostModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompostModel(
      id: fields[0] as String?,
      name: fields[1] as String,
      startDate: fields[2] as DateTime,
      estimatedDays: fields[3] as int,
      ingredients: (fields[4] as List).cast<String>(),
      notes: fields[5] as String?,
      isReady: fields[6] as bool,
      readyDate: fields[7] as DateTime?,
      location: fields[8] as String?,
      notifyWhenReady: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CompostModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.estimatedDays)
      ..writeByte(4)
      ..write(obj.ingredients)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.isReady)
      ..writeByte(7)
      ..write(obj.readyDate)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.notifyWhenReady);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompostModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
