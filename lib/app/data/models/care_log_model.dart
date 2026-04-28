import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'care_log_model.g.dart';

@HiveType(typeId: 2)
class CareLogModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String plantId;

  @HiveField(2)
  final String plantName;

  @HiveField(3)
  final String logType; // water/fertilize/prune/pesticide/repot/note

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String? notes;

  @HiveField(6)
  final String? photoPath;

  @HiveField(7)
  final String? amount; // for fertilizer/pesticide amount

  CareLogModel({
    String? id,
    required this.plantId,
    required this.plantName,
    required this.logType,
    required this.date,
    this.notes,
    this.photoPath,
    this.amount,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'plantId': plantId,
        'plantName': plantName,
        'logType': logType,
        'date': date.toIso8601String(),
        'notes': notes,
        'photoPath': photoPath,
        'amount': amount,
      };

  factory CareLogModel.fromJson(Map<String, dynamic> json) => CareLogModel(
        id: json['id'],
        plantId: json['plantId'],
        plantName: json['plantName'],
        logType: json['logType'],
        date: DateTime.parse(json['date']),
        notes: json['notes'],
        photoPath: json['photoPath'],
        amount: json['amount'],
      );
}
