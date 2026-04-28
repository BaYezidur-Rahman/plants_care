import 'package:hive/hive.dart';

part 'badge_model.g.dart';

@HiveType(typeId: 6)
class BadgeModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String nameBn;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String descriptionBn;

  @HiveField(5)
  final String category; // beginner/consistency/collection/special

  @HiveField(6)
  final String iconEmoji;

  @HiveField(7)
  final int iconColor; // Color value

  @HiveField(8)
  final bool isEarned;

  @HiveField(9)
  final DateTime? earnedDate;

  @HiveField(10)
  final int requiredCount;

  @HiveField(11)
  final int currentCount;

  BadgeModel({
    required this.id,
    required this.name,
    required this.nameBn,
    required this.description,
    required this.descriptionBn,
    required this.category,
    required this.iconEmoji,
    required this.iconColor,
    this.isEarned = false,
    this.earnedDate,
    required this.requiredCount,
    this.currentCount = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameBn': nameBn,
        'description': description,
        'descriptionBn': descriptionBn,
        'category': category,
        'iconEmoji': iconEmoji,
        'iconColor': iconColor,
        'isEarned': isEarned,
        'earnedDate': earnedDate?.toIso8601String(),
        'requiredCount': requiredCount,
        'currentCount': currentCount,
      };

  factory BadgeModel.fromJson(Map<String, dynamic> json) => BadgeModel(
        id: json['id'],
        name: json['name'],
        nameBn: json['nameBn'],
        description: json['description'],
        descriptionBn: json['descriptionBn'],
        category: json['category'],
        iconEmoji: json['iconEmoji'],
        iconColor: json['iconColor'],
        isEarned: json['isEarned'] ?? false,
        earnedDate: json['earnedDate'] != null ? DateTime.parse(json['earnedDate']) : null,
        requiredCount: json['requiredCount'],
        currentCount: json['currentCount'] ?? 0,
      );
}
