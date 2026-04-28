import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'journal_entry_model.g.dart';

@HiveType(typeId: 3)
class JournalEntryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String plantId;

  @HiveField(2)
  final String plantName;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String note;

  @HiveField(5)
  final String? photoPath;

  @HiveField(6)
  final String mood; // happy/concerned/neutral

  JournalEntryModel({
    String? id,
    required this.plantId,
    required this.plantName,
    required this.date,
    required this.note,
    this.photoPath,
    required this.mood,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'plantId': plantId,
        'plantName': plantName,
        'date': date.toIso8601String(),
        'note': note,
        'photoPath': photoPath,
        'mood': mood,
      };

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) => JournalEntryModel(
        id: json['id'],
        plantId: json['plantId'],
        plantName: json['plantName'],
        date: DateTime.parse(json['date']),
        note: json['note'],
        photoPath: json['photoPath'],
        mood: json['mood'],
      );
}
