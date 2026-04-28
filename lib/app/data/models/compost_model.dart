import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'compost_model.g.dart';

@HiveType(typeId: 5)
class CompostModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime startDate;

  @HiveField(3)
  final int estimatedDays;

  @HiveField(4)
  final List<String> ingredients;

  @HiveField(5)
  final String? notes;

  @HiveField(6)
  final bool isReady;

  @HiveField(7)
  final DateTime? readyDate;

  @HiveField(8)
  final String? location;

  @HiveField(9)
  final bool notifyWhenReady;

  DateTime get expectedReadyDate => startDate.add(Duration(days: estimatedDays));

  CompostModel({
    String? id,
    required this.name,
    required this.startDate,
    required this.estimatedDays,
    required this.ingredients,
    this.notes,
    this.isReady = false,
    this.readyDate,
    this.location,
    this.notifyWhenReady = true,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'startDate': startDate.toIso8601String(),
        'estimatedDays': estimatedDays,
        'ingredients': ingredients,
        'notes': notes,
        'isReady': isReady,
        'readyDate': readyDate?.toIso8601String(),
        'location': location,
        'notifyWhenReady': notifyWhenReady,
      };

  factory CompostModel.fromJson(Map<String, dynamic> json) => CompostModel(
        id: json['id'],
        name: json['name'],
        startDate: DateTime.parse(json['startDate']),
        estimatedDays: json['estimatedDays'],
        ingredients: List<String>.from(json['ingredients']),
        notes: json['notes'],
        isReady: json['isReady'] ?? false,
        readyDate: json['readyDate'] != null ? DateTime.parse(json['readyDate']) : null,
        location: json['location'],
        notifyWhenReady: json['notifyWhenReady'] ?? true,
      );

  CompostModel copyWith({
    String? name,
    DateTime? startDate,
    int? estimatedDays,
    List<String>? ingredients,
    String? notes,
    bool? isReady,
    DateTime? readyDate,
    String? location,
    bool? notifyWhenReady,
  }) =>
      CompostModel(
        id: id,
        name: name ?? this.name,
        startDate: startDate ?? this.startDate,
        estimatedDays: estimatedDays ?? this.estimatedDays,
        ingredients: ingredients ?? this.ingredients,
        notes: notes ?? this.notes,
        isReady: isReady ?? this.isReady,
        readyDate: readyDate ?? this.readyDate,
        location: location ?? this.location,
        notifyWhenReady: notifyWhenReady ?? this.notifyWhenReady,
      );
}
