import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String plantId;

  @HiveField(2)
  final String plantName;

  @HiveField(3)
  final String plantNameBn;

  @HiveField(4)
  final String title;

  @HiveField(5)
  final String titleBn;

  @HiveField(6)
  final String taskType; // water/fertilize/prune/repot/pesticide/check

  @HiveField(7)
  final DateTime scheduledDate;

  @HiveField(8)
  final String scheduledTime; // HH:mm

  @HiveField(9)
  final String timeSlot; // morning/afternoon/evening

  @HiveField(10)
  final bool isCompleted;

  @HiveField(11)
  final DateTime? completedAt;

  @HiveField(12)
  final bool isAIGenerated;

  @HiveField(13)
  final String repeatType; // once/daily/weekly/monthly

  @HiveField(14)
  final String priority; // high/medium/low

  @HiveField(15)
  final String? notes;

  TaskModel({
    String? id,
    required this.plantId,
    required this.plantName,
    required this.plantNameBn,
    required this.title,
    required this.titleBn,
    required this.taskType,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.timeSlot,
    this.isCompleted = false,
    this.completedAt,
    this.isAIGenerated = false,
    required this.repeatType,
    required this.priority,
    this.notes,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'plantId': plantId,
        'plantName': plantName,
        'plantNameBn': plantNameBn,
        'title': title,
        'titleBn': titleBn,
        'taskType': taskType,
        'scheduledDate': scheduledDate.toIso8601String(),
        'scheduledTime': scheduledTime,
        'timeSlot': timeSlot,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
        'isAIGenerated': isAIGenerated,
        'repeatType': repeatType,
        'priority': priority,
        'notes': notes,
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'],
        plantId: json['plantId'],
        plantName: json['plantName'],
        plantNameBn: json['plantNameBn'],
        title: json['title'],
        titleBn: json['titleBn'],
        taskType: json['taskType'],
        scheduledDate: DateTime.parse(json['scheduledDate']),
        scheduledTime: json['scheduledTime'],
        timeSlot: json['timeSlot'],
        isCompleted: json['isCompleted'] ?? false,
        completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
        isAIGenerated: json['isAIGenerated'] ?? false,
        repeatType: json['repeatType'],
        priority: json['priority'],
        notes: json['notes'],
      );
  TaskModel copyWith({
    String? title,
    String? titleBn,
    String? taskType,
    DateTime? scheduledDate,
    String? scheduledTime,
    String? timeSlot,
    bool? isCompleted,
    DateTime? completedAt,
    bool? isAIGenerated,
    String? repeatType,
    String? priority,
    String? notes,
  }) =>
      TaskModel(
        id: id,
        plantId: plantId,
        plantName: plantName,
        plantNameBn: plantNameBn,
        title: title ?? this.title,
        titleBn: titleBn ?? this.titleBn,
        taskType: taskType ?? this.taskType,
        scheduledDate: scheduledDate ?? this.scheduledDate,
        scheduledTime: scheduledTime ?? this.scheduledTime,
        timeSlot: timeSlot ?? this.timeSlot,
        isCompleted: isCompleted ?? this.isCompleted,
        completedAt: completedAt ?? this.completedAt,
        isAIGenerated: isAIGenerated ?? this.isAIGenerated,
        repeatType: repeatType ?? this.repeatType,
        priority: priority ?? this.priority,
        notes: notes ?? this.notes,
      );
}
