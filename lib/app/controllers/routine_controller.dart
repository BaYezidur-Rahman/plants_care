import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../data/models/task_model.dart';
import '../data/models/plant_model.dart';
import '../utils/hive_boxes.dart';
import 'notification_controller.dart';

class RoutineController extends GetxController {
  late Box<TaskModel> _taskBox;
  late Box<PlantModel> _plantBox;
  final _notifController = Get.find<NotificationController>();

  final tasks = <TaskModel>[].obs;
  final selectedDate = DateTime.now().obs;
  final isGenerating = false.obs;

  @override
  void onInit() {
    super.onInit();
    _taskBox = Hive.box<TaskModel>(HiveBoxes.tasks);
    _plantBox = Hive.box<PlantModel>(HiveBoxes.plants);
  }

  @override
  void onReady() {
    super.onReady();
    _loadTasks();
  }

  void _loadTasks() {
    tasks.assignAll(_taskBox.values.toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate)));
  }

  List<TaskModel> getTasksForDate(DateTime date) {
    return tasks.where((task) {
      return task.scheduledDate.year == date.year &&
          task.scheduledDate.month == date.month &&
          task.scheduledDate.day == date.day;
    }).toList();
  }

  Future<void> generateAiRoutine() async {
    final plants = _plantBox.values.toList();
    if (plants.isEmpty) {
      Get.snackbar('Empty Garden', 'Please add some plants first!');
      return;
    }

    isGenerating.value = true;
    try {
      // For simplicity, we create basic tasks based on plant frequencies
      // but AI could provide more complex intervals
      final now = DateTime.now();
      for (var plant in plants) {
        final taskId = 'task_${plant.id}_${now.millisecondsSinceEpoch}';
        final task = TaskModel(
          id: taskId,
          plantId: plant.id,
          plantName: plant.name,
          plantNameBn: plant.nameBn,
          title: 'Water ${plant.name}',
          titleBn: '${plant.nameBn} এ পানি দিন',
          taskType: 'water',
          scheduledDate: now,
          scheduledTime: '08:00 AM',
          timeSlot: 'morning',
          isCompleted: false,
          repeatType: 'daily',
          priority: 'medium',
        );
        await addTask(task);
      }
      Get.snackbar('সফল!', 'AI আপনার গাছের জন্য রুটিন তৈরি করেছে');
    } catch (e) {
      Get.snackbar('Error', 'রুটিন তৈরি করতে সমস্যা হয়েছে');
    } finally {
      isGenerating.value = false;
    }
  }

  Future<void> addTask(TaskModel task) async {
    await _taskBox.put(task.id, task);

    // Schedule notification
    await _notifController.scheduleTaskReminder(task);

    _loadTasks();
  }

  Future<void> toggleTask(String taskId) async {
    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = tasks[index];
      final updatedTask = task.copyWith(
        isCompleted: !task.isCompleted,
        completedAt: !task.isCompleted ? DateTime.now() : null,
      );
      await _taskBox.put(task.id, updatedTask);
      _loadTasks();
    }
  }

  Future<void> completeTask(String taskId) async {
    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final task = tasks[index];
      if (!task.isCompleted) {
        final updatedTask = task.copyWith(
          isCompleted: true,
          completedAt: DateTime.now(),
        );
        await _taskBox.put(task.id, updatedTask);
        _loadTasks();
      }
    }
  }

  Future<void> postponeWateringTasks() async {
    final today = DateTime.now();
    final todayTasks = getTasksForDate(today);

    for (var task in todayTasks) {
      if (task.taskType == 'water' && !task.isCompleted) {
        final tomorrow = today.add(const Duration(days: 1));
        final updatedTask = task.copyWith(scheduledDate: tomorrow);
        await _taskBox.put(task.id, updatedTask);
      }
    }
    _loadTasks();
  }
}
