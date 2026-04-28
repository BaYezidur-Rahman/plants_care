// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../controllers/garden_controller.dart';
import '../../widgets/app_card.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../data/models/plant_model.dart';
import '../../routes/app_routes.dart';
import 'widgets/add_plant_bottom_sheet.dart';

class GardenScreen extends GetView<GardenController> {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildSearchBar(context),
                _buildCategoryFilter(context),
                _buildStatsRow(context),
              ],
            ),
          ),
          Obx(() {
            final plants = controller.filteredPlants;
            if (plants.isEmpty) {
              return SliverFillRemaining(child: _buildEmptyState(context));
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              sliver: controller.isGridView.value
                  ? SliverAlignedGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      itemCount: plants.length,
                      itemBuilder: (context, index) => _buildPlantCard(context, plants[index]),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildPlantListTile(context, plants[index]),
                        childCount: plants.length,
                      ),
                    ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPlantBottomSheet(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(IconsaxPlusBold.add, color: Colors.white),
        label: const Text('নতুন গাছ যোগ করুন', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 100,
      title: Text('আমার বাগান 🌿', style: AppTextStyles.titleLarge(context).copyWith(fontWeight: FontWeight.bold)),
      actions: [
        Obx(() => IconButton(
          icon: Icon(controller.isGridView.value ? IconsaxPlusLinear.menu_1 : IconsaxPlusLinear.element_3),
          onPressed: () => controller.isGridView.toggle(),
        )),
        IconButton(
          icon: const Icon(IconsaxPlusLinear.filter_edit),
          onPressed: () => _showSortOptions(context),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        onChanged: (val) => controller.searchQuery.value = val,
        decoration: InputDecoration(
          hintText: 'গাছের নাম দিয়ে খুঁজুন...',
          prefixIcon: const Icon(IconsaxPlusLinear.search_normal),
          filled: true,
          fillColor: AppColors.accentWarm.withOpacity(0.3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildCategoryFilter(BuildContext context) {
    final categories = ['সব', 'ফলের গাছ', 'সবজি', 'ফুলের গাছ', 'ভেষজ', 'অন্যান্য'];
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Obx(() {
            final isSelected = controller.filterCategory.value == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (val) => controller.filterCategory.value = cat,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
              ),
            );
          });
        },
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildStatsRow(BuildContext context) {
    return Obx(() {
      final stats = controller.stats;
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            _statCard('মোট গাছ', '${stats['total']}', AppColors.primary),
            const SizedBox(width: 12),
            _statCard('যত্ন চাই', '${stats['needCare']}', AppColors.warning),
            const SizedBox(width: 12),
            _statCard('সুস্থ', '${stats['healthy']}', AppColors.success),
          ],
        ),
      );
    }).animate().fadeIn(delay: 200.ms);
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: AppCard(
        color: color.withOpacity(0.1),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantCard(BuildContext context, PlantModel plant) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.plantDetail, arguments: plant),
      onLongPress: () => _showPlantOptions(context, plant),
      child: Hero(
        tag: 'plant_${plant.id}',
        child: AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: plant.photoPath != null && plant.photoPath!.isNotEmpty
                      ? Image.file(File(plant.photoPath!), fit: BoxFit.cover)
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.accentWarm, AppColors.accent.withOpacity(0.5)],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _getCategoryEmoji(plant.category),
                              style: const TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plant.nameBn, style: AppTextStyles.titleMedium(context), maxLines: 1),
                    Text(controller.calculateAge(plant.datePlanted), style: AppTextStyles.labelSmall(context)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildHealthRing(plant.healthScore.toDouble()),
                        Text(
                          controller.getUrgencyLabel(plant),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: plant.healthScore < 50 ? AppColors.error : AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().scale(duration: 300.ms);
  }

  Widget _buildPlantListTile(BuildContext context, PlantModel plant) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        child: ListTile(
          onTap: () => Get.toNamed(AppRoutes.plantDetail, arguments: plant),
          contentPadding: EdgeInsets.zero,
          leading: Hero(
            tag: 'plant_thumb_${plant.id}',
            child: CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.accentWarm,
              backgroundImage: plant.photoPath != null && plant.photoPath!.isNotEmpty 
                ? FileImage(File(plant.photoPath!)) 
                : null,
              child: plant.photoPath == null || plant.photoPath!.isEmpty 
                ? Text(_getCategoryEmoji(plant.category), style: const TextStyle(fontSize: 24)) 
                : null,
            ),
          ),
          title: Text(plant.nameBn, style: AppTextStyles.titleMedium(context)),
          subtitle: Text(controller.calculateAge(plant.datePlanted), style: AppTextStyles.labelSmall(context)),
          trailing: _buildHealthRing(plant.healthScore.toDouble()),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.1);
  }

  Widget _buildHealthRing(double score) {
    Color color = score > 80 ? AppColors.success : (score > 50 ? AppColors.warning : AppColors.error);
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            value: score / 100,
            strokeWidth: 3,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        Text('${score.round()}', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  String _getCategoryEmoji(String cat) {
    switch (cat) {
      case 'ফলের গাছ': return '🍎';
      case 'সবজি': return '🥬';
      case 'ফুলের গাছ': return '🌸';
      case 'ভেষজ': return '🌿';
      default: return '🪴';
    }
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(IconsaxPlusLinear.tree, size: 80, color: AppColors.textHint),
          const SizedBox(height: 16),
          Text('আপনার বাগানে কোনো গাছ নেই', style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: 8),
          Text('শুরু করতে নিচের বাটনে ক্লিক করুন', style: AppTextStyles.labelSmall(context)),
        ],
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('সাজানোর পদ্ধতি', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _sortOption('প্রয়োজনীয়তা', 'urgent', IconsaxPlusLinear.danger),
            _sortOption('নাম (অ আ ক খ)', 'name', IconsaxPlusLinear.sort),
            _sortOption('স্বাস্থ্য', 'health', IconsaxPlusLinear.heart),
            _sortOption('রোপণের তারিখ', 'date', IconsaxPlusLinear.calendar),
          ],
        ),
      ),
    );
  }

  Widget _sortOption(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: Obx(() => Radio<String>(
        value: value,
        groupValue: controller.sortBy.value,
        onChanged: (val) {
          controller.sortBy.value = val!;
          Get.back();
        },
      )),
    );
  }

  void _showPlantOptions(BuildContext context, PlantModel plant) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(IconsaxPlusLinear.edit),
              title: const Text('তথ্য সংশোধন'),
              onTap: () { Get.back(); /* Edit Logic */ },
            ),
            ListTile(
              leading: const Icon(IconsaxPlusLinear.trash, color: AppColors.error),
              title: const Text('ডিলিট করুন', style: TextStyle(color: AppColors.error)),
              onTap: () {
                controller.deletePlant(plant.id);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPlantBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddPlantBottomSheet(),
    );
  }
}
