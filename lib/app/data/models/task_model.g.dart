// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 1;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      id: fields[0] as String?,
      plantId: fields[1] as String,
      plantName: fields[2] as String,
      plantNameBn: fields[3] as String,
      title: fields[4] as String,
      titleBn: fields[5] as String,
      taskType: fields[6] as String,
      scheduledDate: fields[7] as DateTime,
      scheduledTime: fields[8] as String,
      timeSlot: fields[9] as String,
      isCompleted: fields[10] as bool,
      completedAt: fields[11] as DateTime?,
      isAIGenerated: fields[12] as bool,
      repeatType: fields[13] as String,
      priority: fields[14] as String,
      notes: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.plantId)
      ..writeByte(2)
      ..write(obj.plantName)
      ..writeByte(3)
      ..write(obj.plantNameBn)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.titleBn)
      ..writeByte(6)
      ..write(obj.taskType)
      ..writeByte(7)
      ..write(obj.scheduledDate)
      ..writeByte(8)
      ..write(obj.scheduledTime)
      ..writeByte(9)
      ..write(obj.timeSlot)
      ..writeByte(10)
      ..write(obj.isCompleted)
      ..writeByte(11)
      ..write(obj.completedAt)
      ..writeByte(12)
      ..write(obj.isAIGenerated)
      ..writeByte(13)
      ..write(obj.repeatType)
      ..writeByte(14)
      ..write(obj.priority)
      ..writeByte(15)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
