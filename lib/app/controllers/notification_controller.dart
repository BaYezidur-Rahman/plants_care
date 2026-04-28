import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import '../data/models/task_model.dart';
import '../data/models/compost_model.dart';
import '../data/models/weather_model.dart';

class NotificationController extends GetxController {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _notificationsPlugin.initialize(settings);
  }

  Future<void> scheduleTaskReminder(TaskModel task) async {
    final scheduledDate = task.scheduledDate;
    // Assume 8 AM if time not specified
    final scheduledTime = tz.TZDateTime(
      tz.local,
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      8,
      0,
    );

    if (scheduledTime.isBefore(DateTime.now())) return;

    await _notificationsPlugin.zonedSchedule(
      task.id.hashCode,
      task.titleBn,
      '${task.plantNameBn} এর যত্নের সময় হয়েছে',
      scheduledTime,
      _notificationDetails('plant_care'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleMorningDigest() async {
    final now = DateTime.now();
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 7, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      999, // Digest ID
      'শুভ সকাল! 🌿',
      'আজ আপনার বাগানে কিছু কাজ আছে। রুটিনটি দেখে নিন।',
      scheduledDate,
      _notificationDetails('morning_digest'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> rescheduleOnWeather(WeatherModel weather) async {
    if (weather.rainProbability > 60) {
      // Logic would go here to find today's water tasks and cancel/reschedule
      // This is a placeholder for the logic mentioned in Step 08/10
    }
  }

  Future<void> showInstantNotification(
      {required int id, required String title, required String body}) async {
    await _notificationsPlugin.show(
      id,
      title,
      body,
      _notificationDetails('instant'),
    );
  }

  Future<void> scheduleCompostReady(CompostModel batch) async {
    if (batch.isReady) return;

    await _notificationsPlugin.zonedSchedule(
      batch.id.hashCode,
      'কম্পোস্ট তৈরি! 🌱',
      'আপনার ${batch.name} কম্পোস্ট এখন ব্যবহারের জন্য প্রস্তুত।',
      tz.TZDateTime.from(batch.expectedReadyDate, tz.local),
      _notificationDetails('compost'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  NotificationDetails _notificationDetails(String channelId) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelId.capitalizeFirst!,
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }
}
