import 'package:hive/hive.dart';
import '../models/task_model.dart';
import '../../utils/hive_boxes.dart';

class TaskRepository {
  late Box<TaskModel> _box;

  Future<void> init() async {
    _box = Hive.box<TaskModel>(HiveBoxes.tasks);
  }

  List<TaskModel> getAllTasks() {
    return _box.values.toList();
  }

  List<TaskModel> getTasksByPlant(String plantId) {
    return _box.values.where((task) => task.plantId == plantId).toList();
  }

  Future<void> addTask(TaskModel task) async {
    await _box.put(task.id, task);
  }

  Future<void> updateTask(TaskModel task) async {
    await task.save();
  }

  Future<void> deleteTask(String id) async {
    await _box.delete(id);
  }

  Future<void> completeTask(String id) async {
    final task = _box.get(id);
    if (task != null) {
      final updatedTask = TaskModel(
        id: task.id,
        plantId: task.plantId,
        plantName: task.plantName,
        plantNameBn: task.plantNameBn,
        title: task.title,
        titleBn: task.titleBn,
        taskType: task.taskType,
        scheduledDate: task.scheduledDate,
        scheduledTime: task.scheduledTime,
        timeSlot: task.timeSlot,
        repeatType: task.repeatType,
        priority: task.priority,
        isCompleted: true,
        completedAt: DateTime.now(),
      );
      await _box.put(id, updatedTask);
    }
  }
}
