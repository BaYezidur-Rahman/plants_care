import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'chat_message_model.g.dart';

@HiveType(typeId: 4)
class ChatMessageModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String message;

  @HiveField(2)
  final bool isUser;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final String? imagePath; // Path for locally stored images

  @HiveField(5)
  final bool isLoading;

  @HiveField(6)
  final String? imageBase64; // For temporary AI transfer or cloud storage

  ChatMessageModel({
    String? id,
    required this.message,
    required this.isUser,
    required this.timestamp,
    this.imagePath,
    this.isLoading = false,
    this.imageBase64,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'isUser': isUser,
        'timestamp': timestamp.toIso8601String(),
        'imagePath': imagePath,
        'isLoading': isLoading,
        'imageBase64': imageBase64,
      };

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => ChatMessageModel(
        id: json['id'],
        message: json['message'],
        isUser: json['isUser'],
        timestamp: DateTime.parse(json['timestamp']),
        imagePath: json['imagePath'],
        isLoading: json['isLoading'] ?? false,
        imageBase64: json['imageBase64'],
      );
}
