// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../controllers/routine_controller.dart';
import '../../../widgets/app_card.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../utils/date_helpers.dart';

class RoutineView extends GetView<RoutineController> {
  const RoutineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('যত্নের রুটিন 📅'),
        actions: [
          Obx(() => controller.isGenerating.value 
            ? const Center(child: Padding(padding: EdgeInsets.all(16), child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))))
            : IconButton(
                icon: const Icon(IconsaxPlusLinear.magic_star),
                onPressed: () => controller.generateAiRoutine(),
                tooltip: 'AI রুটিন তৈরি করুন',
              )),
        ],
      ),
      body: Column(
        children: [
          _buildCalendarStrip(context),
          const SizedBox(height: 20),
          Expanded(child: _buildTaskList(context)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskSheet(context),
        backgroundColor: AppColors.primary,
        child: const Icon(IconsaxPlusLinear.add, color: Colors.white),
      ),
    );
  }

  Widget _buildCalendarStrip(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 30, // Month view
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 3));
          
          return Obx(() {
            final isSelected = controller.selectedDate.value.year == date.year &&
                               controller.selectedDate.value.month == date.month &&
                               controller.selectedDate.value.day == date.day;
            final isToday = DateTime.now().day == date.day && DateTime.now().month == date.month;

            return GestureDetector(
              onTap: () => controller.selectedDate.value = date,
              child: Container(
                width: 60,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : (isToday ? AppColors.accentWarm : Colors.white),
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected ? null : Border.all(color: Colors.grey[200]!),
                  boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateHelpers.getBanglaDay(date),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  Widget _buildTaskList(BuildContext context) {
    return Obx(() {
      final tasks = controller.getTasksForDate(controller.selectedDate.value);
      
      if (tasks.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(IconsaxPlusLinear.calendar_tick, size: 80, color: AppColors.textHint),
              const SizedBox(height: 16),
              Text('আজ কোনো কাজ নেই!', style: AppTextStyles.titleMedium(context)),
              const SizedBox(height: 8),
              Text('উপরের বাটনে ক্লিক করে রুটিন তৈরি করুন', style: AppTextStyles.labelSmall(context)),
            ],
          ).animate().fadeIn(),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Dismissible(
            key: Key(task.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) {
              // Delete logic
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                color: task.isCompleted ? Colors.grey[50] : Colors.white,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: _getTaskColor(task.taskType).withOpacity(0.1),
                    child: Icon(_getTaskIcon(task.taskType), color: _getTaskColor(task.taskType), size: 20),
                  ),
                  title: Text(
                    task.titleBn, 
                    style: AppTextStyles.titleMedium(context).copyWith(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      color: task.isCompleted ? Colors.grey : AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(task.plantNameBn, style: AppTextStyles.labelSmall(context)),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (val) => controller.toggleTask(task.id),
                    activeColor: AppColors.primary,
                    shape: const CircleBorder(),
                  ),
                ),
              ),
            ),
          ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1);
        },
      );
    });
  }

  void _showAddTaskSheet(BuildContext context) {
    // Basic manual task creation sheet
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('নতুন কাজ যোগ করুন', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            // Form fields... (simplified for now)
            ElevatedButton(onPressed: () => Get.back(), child: const Text('সংরক্ষণ করুন')),
          ],
        ),
      ),
    );
  }

  IconData _getTaskIcon(String type) {
    switch (type) {
      case 'water': return IconsaxPlusBold.drop;
      case 'fertilize': return IconsaxPlusBold.element_plus;
      case 'prune': return IconsaxPlusBold.scissor_1;
      default: return IconsaxPlusBold.task_square;
    }
  }

  Color _getTaskColor(String type) {
    switch (type) {
      case 'water': return AppColors.water;
      case 'fertilize': return AppColors.soil;
      case 'prune': return AppColors.primary;
      default: return AppColors.success;
    }
  }
}
