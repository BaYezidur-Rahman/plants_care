import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/plant_model.dart';
import '../data/models/task_model.dart';
import '../data/models/care_log_model.dart';
import '../data/models/journal_entry_model.dart';
import '../data/models/chat_message_model.dart';
import '../data/models/compost_model.dart';
import '../data/models/badge_model.dart';

class HiveBoxes {
  static const String plants = 'plants_box';
  static const String tasks = 'tasks_box';
  static const String careLogs = 'care_logs_box';
  static const String journal = 'journal_box';
  static const String chat = 'chat_box';
  static const String compost = 'compost_box';
  static const String badges = 'badges_box';
  static const String settings = 'settings_box';
  static const String library = 'library_box';
  static const String bookmarks = 'bookmarks_box';

  static Future<void> openRemainingBoxes() async {
    await Future.wait([
      Hive.openBox<PlantModel>(plants),
      Hive.openBox<TaskModel>(tasks),
      Hive.openBox<CareLogModel>(careLogs),
      Hive.openBox<JournalEntryModel>(journal),
      Hive.openBox<ChatMessageModel>(chat),
      Hive.openBox<CompostModel>(compost),
      Hive.openBox<BadgeModel>(badges),
      Hive.openBox(library),
      Hive.openBox(bookmarks),
    ]);
  }
}
