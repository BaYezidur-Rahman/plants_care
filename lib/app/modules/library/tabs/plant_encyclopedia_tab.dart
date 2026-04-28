import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/library_controller.dart';
import '../../../widgets/app_card.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class PlantEncyclopediaTab extends GetView<LibraryController> {
  const PlantEncyclopediaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: controller.encyclopedia.length,
        itemBuilder: (context, index) {
          final plant = controller.encyclopedia[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppCard(
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.accentWarm,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.eco, color: AppColors.primary, size: 40),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(plant['nameBn'] as String, style: AppTextStyles.titleMedium(context)),
                        Text(plant['category'] as String, style: AppTextStyles.labelSmall(context)),
                        const SizedBox(height: 4),
                        Text(
                          plant['description'] as String,
                          style: AppTextStyles.bodyMedium(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
