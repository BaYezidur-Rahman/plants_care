import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'plant_model.g.dart';

@HiveType(typeId: 0)
class PlantModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String nameBn;

  @HiveField(3)
  final String category; // ফলের গাছ/ফুলের গাছ/সবজি/ভেষজ/অন্যান্য

  @HiveField(4)
  final String location; // ছাদ/বাগান/বারান্দা/ঘরের ভেতর

  @HiveField(5)
  final DateTime datePlanted;

  @HiveField(6)
  final String? photoPath;

  @HiveField(7)
  final String? notes;

  @HiveField(8)
  final int healthScore; // 0-100, default 100

  @HiveField(9)
  final String waterFrequency; // প্রতিদিন/২দিনে/সপ্তাহে/প্রয়োজনে

  @HiveField(10)
  final String sunlightNeed; // পূর্ণ রোদ/আংশিক ছায়া/ছায়া

  @HiveField(11)
  final DateTime? lastWatered;

  @HiveField(12)
  final DateTime? lastFertilized;

  @HiveField(13)
  final DateTime? lastPruned;

  @HiveField(14)
  final DateTime createdAt;

  @HiveField(15)
  final String nickname;

  @HiveField(16)
  final String nicknameBn;

  @HiveField(17)
  final bool isFavorite;

  PlantModel({
    String? id,
    required this.name,
    required this.nameBn,
    required this.category,
    required this.location,
    required this.datePlanted,
    this.photoPath,
    this.notes,
    this.healthScore = 100,
    required this.waterFrequency,
    required this.sunlightNeed,
    this.lastWatered,
    this.lastFertilized,
    this.lastPruned,
    DateTime? createdAt,
    required this.nickname,
    required this.nicknameBn,
    this.isFavorite = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'nameBn': nameBn,
        'nickname': nickname,
        'nicknameBn': nicknameBn,
        'category': category,
        'location': location,
        'datePlanted': datePlanted.toIso8601String(),
        'photoPath': photoPath,
        'notes': notes,
        'healthScore': healthScore,
        'waterFrequency': waterFrequency,
        'sunlightNeed': sunlightNeed,
        'isFavorite': isFavorite,
        'lastWatered': lastWatered?.toIso8601String(),
        'lastFertilized': lastFertilized?.toIso8601String(),
        'lastPruned': lastPruned?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory PlantModel.fromJson(Map<String, dynamic> json) => PlantModel(
        id: json['id'],
        name: json['name'],
        nameBn: json['nameBn'],
        nickname: json['nickname'] ?? json['name'],
        nicknameBn: json['nicknameBn'] ?? json['nameBn'],
        category: json['category'],
        location: json['location'],
        datePlanted: DateTime.parse(json['datePlanted']),
        photoPath: json['photoPath'],
        notes: json['notes'],
        healthScore: json['healthScore'] ?? 100,
        waterFrequency: json['waterFrequency'],
        sunlightNeed: json['sunlightNeed'],
        isFavorite: json['isFavorite'] ?? false,
        lastWatered: json['lastWatered'] != null ? DateTime.parse(json['lastWatered']) : null,
        lastFertilized: json['lastFertilized'] != null ? DateTime.parse(json['lastFertilized']) : null,
        lastPruned: json['lastPruned'] != null ? DateTime.parse(json['lastPruned']) : null,
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      );
  String get healthStatus {
    if (healthScore >= 80) return 'সুস্থ';
    if (healthScore >= 50) return 'মাঝারি';
    return 'অসুস্থ';
  }
}
