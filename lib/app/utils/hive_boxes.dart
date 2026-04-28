import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/plant_model.dart';
import '../data/models/task_model.dart';
import '../data/models/care_log_model.dart';
import '../data/models/journal_entry_model.dart';
import '../data/models/chat_message_model.dart';
import '../data/models/compost_model.dart';
import '../data/models/badge_model.dart';

class HiveBoxes {
  static const String settings = 'settings';
  static const String plants = 'plants';
  static const String tasks = 'tasks';
  static const String careLogs = 'care_logs';
  static const String journals = 'journals';
  static const String chats = 'chats';
  static const String composts = 'composts';
  static const String badges = 'badges';
  static const String library = 'library';
  static const String bookmarks = 'bookmarks';

  static Future<void> openRemainingBoxes() async {
    await Future.wait([
      Hive.openBox<PlantModel>(plants),
      Hive.openBox<TaskModel>(tasks),
      Hive.openBox<CareLogModel>(careLogs),
      Hive.openBox<JournalEntryModel>(journals),
      Hive.openBox<ChatMessageModel>(chats),
      Hive.openBox<CompostModel>(composts),
      Hive.openBox<BadgeModel>(badges),
      Hive.openBox(library),
      Hive.openBox(bookmarks),
    ]);
  }
}
