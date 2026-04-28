import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../controllers/theme_controller.dart';
import '../../controllers/weather_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_card.dart';
import '../../routes/app_routes.dart';
import '../../data/models/plant_model.dart';
import 'controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherController = Get.find<WeatherController>();
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildHeader(context, themeController),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 12),
                  _buildGreeting(context),
                  const SizedBox(height: 24),
                  _buildWeatherCard(context, weatherController),
                  const SizedBox(height: 24),
                  _buildSmartAdviceSection(context, weatherController),
                  const SizedBox(height: 32),
                  _buildTasksSection(context),
                  const SizedBox(height: 32),
                  _buildMyPlantsSection(context),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // [1] HEADER ROW
  Widget _buildHeader(BuildContext context, ThemeController themeController) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                // Avoid potential hang by using a safer navigation call
                Get.toNamed(AppRoutes.profile);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.2), width: 2),
                ),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.accentWarm,
                  backgroundImage:
                      NetworkImage('https://i.pravatar.cc/150?u=gardener'),
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  'গাছের যত্ন 🌿',
                  style: AppTextStyles.labelSmall(context).copyWith(
                    color: AppColors.primary.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded, color: AppColors.primary),
                  onPressed: () {},
                ),
                Obx(() => IconButton(
                      icon: Icon(
                        themeController.isDark
                            ? Icons.wb_sunny_rounded
                            : Icons.nightlight_round,
                        color: AppColors.primary,
                      ),
                      onPressed: themeController.toggleTheme,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // [2] GREETING + DATE
  Widget _buildGreeting(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, d MMMM', 'bn').format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Text(
              '${controller.greeting.value}, ${controller.userName.value}! 🌅',
              style:
                  AppTextStyles.displayMedium(context).copyWith(fontSize: 24),
            )),
        const SizedBox(height: 4),
        Text(
          dateStr,
          style: AppTextStyles.bodyMedium(context)
              .copyWith(color: AppColors.textSecondary.withOpacity(0.7)),
        ),
        const SizedBox(height: 12),
        Obx(() => Text(
              '"${controller.dailyTip.value}"',
              style: AppTextStyles.labelSmall(context).copyWith(
                color: AppColors.textHint,
                fontStyle: FontStyle.italic,
              ),
            )),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05);
  }

  // [3] WEATHER CARD
  Widget _buildWeatherCard(BuildContext context, WeatherController weather) {
    return Obx(() {
      final data = weather.weatherData.value;
      if (data == null) return const SizedBox(height: 140);

      final advice = controller.advisor.getWateringAdvice(
        temp: data.temp,
        humidity: data.humidity,
        rainProbability: data.rainProbability,
      );

      final isWaterNeeded = !advice.contains('দরকার নেই');

      return Container(
        constraints: const BoxConstraints(minHeight: 160),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.1),
              AppColors.accent.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: AppColors.primary.withOpacity(0.1)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(data.city,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${data.temp.round()}°C',
                                style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary),
                              ),
                            ),
                            Text(
                              'অনুভূত: ${data.feelsLike.round()}°C | ${data.condition}',
                              style: const TextStyle(
                                  color: AppColors.textSecondary, fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getWeatherIcon(data.conditionCode),
                            size: 48,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _miniWeatherChip(Icons.water_drop_outlined,
                                  '${data.humidity}%'),
                              const SizedBox(width: 8),
                              _miniWeatherChip(Icons.air_rounded,
                                  '${data.windSpeed} km/h'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  color: (isWaterNeeded ? AppColors.success : Colors.blue)
                      .withOpacity(0.1),
                  child: Row(
                    children: [
                      Icon(
                        isWaterNeeded
                            ? Icons.opacity_rounded
                            : Icons.info_outline_rounded,
                        size: 16,
                        color: isWaterNeeded ? AppColors.success : Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          advice,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color:
                                isWaterNeeded ? AppColors.success : Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05);
    });
  }

  IconData _getWeatherIcon(int conditionCode) {
    if (conditionCode >= 200 && conditionCode <= 531) {
      return Icons.umbrella_rounded; // Rain
    } else if (conditionCode >= 600 && conditionCode <= 622) {
      return Icons.ac_unit_rounded; // Snow
    } else if (conditionCode == 800) {
      return Icons.wb_sunny_rounded; // Sunny
    } else if (conditionCode >= 801 && conditionCode <= 804) {
      return Icons.wb_cloudy_rounded; // Cloudy
    }
    return Icons.cloud_queue_rounded;
  }

  Widget _miniWeatherChip(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(value,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // [4] SMART ADVICE CARD
  Widget _buildSmartAdviceSection(
      BuildContext context, WeatherController weather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('আজকের পরামর্শ 🌱', style: AppTextStyles.titleLarge(context)),
        const SizedBox(height: 16),
        Obx(() {
          final data = weather.weatherData.value;
          if (data == null) return const SizedBox();

          return Row(
            children: [
              _expandableAdviceCard(
                context,
                'রোপণ করুন 🌾',
                controller.advisor
                    .getRecommendedPlantsToPlant(
                      country: data.country,
                      month: DateTime.now().month,
                      temp: data.temp,
                      humidity: data.humidity,
                    )
                    .take(3)
                    .join(', '),
                'এই মাসে লাগানোর উপযুক্ত সময়',
                Colors.green,
              ),
              const SizedBox(width: 12),
              _expandableAdviceCard(
                context,
                'সার দিন 🌿',
                controller.advisor.getFertilizerAdvice(
                  temp: data.temp,
                  humidity: data.humidity,
                  month: DateTime.now().month,
                ),
                'আবহাওয়ার ভিত্তিতে পরামর্শ',
                Colors.orange,
              ),
              const SizedBox(width: 12),
              _expandableAdviceCard(
                context,
                'কীটনাশক 🐛',
                controller.advisor.getPesticideAdvice(
                  temp: data.temp,
                  humidity: data.humidity,
                  isRaining: data.rainProbability > 50,
                ),
                'সুরক্ষার জন্য করণীয়',
                Colors.red,
              ),
            ],
          );
        }),
      ],
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.05);
  }

  Widget _expandableAdviceCard(BuildContext context, String title,
      String advice, String sub, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _showAdviceDetail(context, title, advice, color),
        child: AppCard(
          padding: const EdgeInsets.all(12),
          color: color.withOpacity(0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 8),
              Text(advice,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10)),
              const SizedBox(height: 4),
              Text(sub, style: TextStyle(fontSize: 8, color: Colors.grey[500])),
            ],
          ),
        ),
      ),
    );
  }

  // [5] TODAY'S TASKS
  Widget _buildTasksSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('আজকের কাজ 📋', style: AppTextStyles.titleLarge(context)),
            Obx(() => controller.todayTasks.isEmpty
                ? const SizedBox()
                : Text('${controller.todayTasks.length}টি বাকি',
                    style: AppTextStyles.labelSmall(context))),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.todayTasks.isEmpty) {
            return AppCard(
              color: AppColors.success.withOpacity(0.05),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text('🎉', style: TextStyle(fontSize: 32)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('আজ সব ঠিকঠাক!',
                              style: AppTextStyles.titleMedium(context)),
                          Text('গাছগুলো সুখে আছে',
                              style: AppTextStyles.bodyMedium(context)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.todayTasks.length,
              itemBuilder: (context, index) {
                final task = controller.todayTasks[index];
                return Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 12),
                  child: AppCard(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('🪴', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Text(task.plantNameBn,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                    maxLines: 1)),
                            GestureDetector(
                              onTap: () => controller.completeTask(task.id),
                              child: const Icon(Icons.check_circle_outline_rounded,
                                  size: 20, color: AppColors.textHint),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(task.titleBn,
                            style: const TextStyle(fontSize: 12)),
                        const SizedBox(height: 2),
                        Text(task.scheduledTime,
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.05);
  }

  // [6] MY PLANTS SUMMARY
  Widget _buildMyPlantsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('আমার গাছ 🌱', style: AppTextStyles.titleLarge(context)),
                const SizedBox(width: 8),
                Obx(() => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('${controller.recentPlants.length}',
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary)),
                    )),
              ],
            ),
            TextButton(
              onPressed: () => controller.changePage(1),
              child: const Text('সব দেখুন →', style: TextStyle(fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: Obx(() {
            if (controller.recentPlants.isEmpty) {
              return _buildEmptyPlantCard(context);
            }
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.recentPlants.length + 1,
              itemBuilder: (context, index) {
                if (index == controller.recentPlants.length) {
                  return _buildEmptyPlantCard(context);
                }
                final plant = controller.recentPlants[index];
                return _buildMiniPlantCard(context, plant);
              },
            );
          }),
        ),
      ],
    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.05);
  }

  Widget _buildMiniPlantCard(BuildContext context, PlantModel plant) {
    final healthColor = plant.healthScore > 80
        ? AppColors.success
        : (plant.healthScore > 50 ? AppColors.warning : AppColors.error);

    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      child: AppCard(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.accentWarm,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: plant.photoPath != null && plant.photoPath!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(File(plant.photoPath!),
                            fit: BoxFit.cover))
                    : const Center(
                        child: Text('🪴', style: TextStyle(fontSize: 32))),
              ),
            ),
            const SizedBox(height: 8),
            Text(plant.nameBn,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                maxLines: 1),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                        color: healthColor, shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text('স্বাস্থ্য',
                    style: TextStyle(fontSize: 9, color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPlantCard(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.changePage(1),
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, color: AppColors.primary),
              SizedBox(height: 4),
              Text('গাছ যোগ',
                  style: TextStyle(fontSize: 10, color: AppColors.primary)),
            ],
          ),
        ),
      ),
    );
  }

  void _showAdviceDetail(
      BuildContext context, String title, String advice, Color color) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1), shape: BoxShape.circle),
                  child: Icon(Icons.lightbulb_outline_rounded, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Text(title,
                    style: AppTextStyles.titleLarge(context)
                        .copyWith(color: color)),
              ],
            ),
            const SizedBox(height: 20),
            Text(advice, style: const TextStyle(fontSize: 15, height: 1.6)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(backgroundColor: color),
                child: const Text('ঠিক আছে'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
