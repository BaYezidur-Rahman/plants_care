import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/library_controller.dart';
import '../../../widgets/app_card.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class OrganicRecipesTab extends GetView<LibraryController> {
  const OrganicRecipesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: controller.recipes.length,
        itemBuilder: (context, index) {
          final recipe = controller.recipes[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: AppColors.accentWarm,
                  child: Text(_getCategoryIcon(recipe['category']), style: const TextStyle(fontSize: 20)),
                ),
                title: Text(recipe['nameBn'] as String, style: AppTextStyles.titleMedium(context)),
                subtitle: Text('${recipe['category']} • ${recipe['prepTimeMinutes']} মিনিট', style: AppTextStyles.bodyMedium(context)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textHint),
              ),
            ),
          );
        },
      );
    });
  }

  String _getCategoryIcon(String? category) {
    switch (category) {
      case 'সার': return '🌿';
      case 'কীটনাশক': return '🐜';
      case 'ছত্রাকনাশক': return '🍄';
      default: return '🍃';
    }
  }
}
