// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import '../../../controllers/theme_controller.dart';
import '../../../controllers/weather_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/app_card.dart';
import '../../../routes/app_routes.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/plant_model.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherController = Get.find<WeatherController>();
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context, themeController),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildGreetingSection(context),
              _buildWeatherCard(context, weatherController),
              _buildSmartAlertBanner(context, weatherController),
              _buildTodayTasks(context),
              _buildQuickActions(context),
              _buildMyPlants(context),
              _buildTipOfTheDay(context),
              const SizedBox(height: 100), // Bottom padding
            ]),
          ),
        ],
      ),
    );
  }

  // [1] Custom Header
  Widget _buildAppBar(BuildContext context, ThemeController themeController) {
    return SliverAppBar(
      pinned: false,
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.profile),
          child: const CircleAvatar(
            radius: 20,
            backgroundImage:
                NetworkImage('https://i.pravatar.cc/150?u=gardener'),
          ),
        ),
      ),
      title: Text(
        'PlantCare Pro',
        style: AppTextStyles.titleLarge(context).copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(IconsaxPlusLinear.notification,
                  color: AppColors.primary),
              onPressed: () {},
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                child: const Text('2',
                    style: TextStyle(color: Colors.white, fontSize: 8)),
              ),
            ),
          ],
        ),
        Obx(() => IconButton(
              icon: Icon(
                themeController.isDark
                    ? IconsaxPlusLinear.sun_1
                    : IconsaxPlusLinear.moon,
                color: AppColors.primary,
              ),
              onPressed: themeController.toggleTheme,
            )),
        const SizedBox(width: 8),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }

  // [2] Greeting Section
  Widget _buildGreetingSection(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat(
            'EEEE, d MMMM', Get.locale?.languageCode == 'bn' ? 'bn' : 'en')
        .format(now);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => Text(
                '${controller.greeting.value}, ${controller.userName.value}! 🌅',
                style: AppTextStyles.displayMedium(context),
              )),
          const SizedBox(height: 4),
          Text(
            dateStr,
            style: AppTextStyles.bodyMedium(context)
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            '"গাছ আপনার বন্ধুর মতো, যত্ন নিলে সে আপনাকে ছায়া দেবে।"',
            style: AppTextStyles.labelSmall(context).copyWith(
              color: AppColors.textHint,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.05),
    );
  }

  // [3] Weather Card (Glassmorphism)
  Widget _buildWeatherCard(BuildContext context, WeatherController weather) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Obx(() {
        if (weather.weatherState.value == 'loading') {
          return _buildShimmerWeatherCard();
        }

        if (weather.weatherState.value == 'error') {
          return _buildErrorWeatherCard(weather);
        }

        final data = weather.weatherData.value;
        if (data == null) return _buildErrorWeatherCard(weather);

        return ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.15),
                    AppColors.accent.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border:
                    Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data.city,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(
                            '${data.temp.round()}°',
                            style: const TextStyle(
                                fontSize: 48, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'অনুভূত: ${data.feelsLike.round()}° | ${data.condition}',
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 14),
                          ),
                        ],
                      ),
                      Lottie.asset(
                        'assets/animations/${weather.getLottieFile()}',
                        width: 100,
                        height: 100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _weatherChip(IconsaxPlusLinear.drop, '${data.humidity}%',
                          'আর্দ্রতা'),
                      _weatherChip(IconsaxPlusLinear.wind,
                          '${data.windSpeed} km/h', 'বাতাস'),
                      _weatherChip(
                          IconsaxPlusLinear.eye, '১০ km', 'দৃশ্যমানতা'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.05);
  }

  Widget _buildErrorWeatherCard(WeatherController weather) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accentWarm.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const Icon(IconsaxPlusLinear.cloud_cross, size: 40, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          const Text(
            'আবহাওয়া লোড হয়নি 🌤️',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => weather.retry(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('পুনরায় চেষ্টা'),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerWeatherCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  Widget _weatherChip(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  // [4] Smart Alert Banner
  Widget _buildSmartAlertBanner(
      BuildContext context, WeatherController weather) {
    return Obx(() {
      final alert = weather.smartAlert.value;
      if (alert == null) return const SizedBox();

      Color color;
      IconData icon;
      switch (alert.type) {
        case 'danger':
          color = AppColors.error;
          icon = IconsaxPlusBold.danger;
          break;
        case 'warning':
          color = AppColors.warning;
          icon = IconsaxPlusBold.info_circle;
          break;
        default:
          color = Colors.blue;
          icon = IconsaxPlusBold.message_question;
      }

      return AnimatedOpacity(
        opacity: 1.0,
        duration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    alert.message,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: color, size: 18),
                  onPressed: () => weather.smartAlert.value = null,
                ),
              ],
            ),
          ),
        ),
      );
    }).animate().slideY(begin: -0.3).fadeIn();
  }

  // [5] Today's Tasks
  Widget _buildTodayTasks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('আজকের কাজ 📋',
                      style: AppTextStyles.titleLarge(context)),
                  const SizedBox(width: 8),
                  Obx(() => controller.todayTasks.isEmpty
                      ? const SizedBox()
                      : Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                              color: AppColors.primary, shape: BoxShape.circle),
                          child: Text('${controller.todayTasks.length}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10)),
                        )),
                ],
              ),
            ],
          ),
        ),
        Obx(() {
          if (controller.todayTasks.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text('🎉', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('আজ সব ঠিকঠাক! গাছগুলো সুখে আছে',
                            style: AppTextStyles.bodyMedium(context)),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.todayTasks.length,
              itemBuilder: (context, index) {
                final task = controller.todayTasks[index];
                return _buildTaskCard(context, task);
              },
            ),
          );
        }),
      ],
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.05);
  }

  Widget _buildTaskCard(BuildContext context, TaskModel task) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: AppCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.accentWarm,
                  child: Text('🌿', style: TextStyle(fontSize: 18)),
                ),
                GestureDetector(
                  onTap: () => controller.completeTask(task.id),
                  child: Icon(
                    task.isCompleted
                        ? IconsaxPlusBold.tick_circle
                        : IconsaxPlusLinear.tick_circle,
                    color: task.isCompleted
                        ? AppColors.primary
                        : AppColors.textHint,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(task.plantNameBn,
                style: AppTextStyles.titleMedium(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(_getTaskIcon(task.taskType),
                    size: 14, color: _getTaskColor(task.taskType)),
                const SizedBox(width: 4),
                Text(task.titleBn,
                    style: TextStyle(
                        fontSize: 12, color: _getTaskColor(task.taskType))),
              ],
            ),
            const SizedBox(height: 4),
            Text(task.scheduledTime,
                style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // [6] Quick Actions
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
          child: Text('দ্রুত কাজ ⚡', style: AppTextStyles.titleLarge(context)),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _actionButton(context, 'গাছ যোগ', IconsaxPlusBold.add_square,
                AppRoutes.addPlant),
            _actionButton(context, 'গাছ শনাক্ত', IconsaxPlusBold.scan_barcode,
                AppRoutes.plantIdentifier),
            _actionButton(context, 'AI Doctor', IconsaxPlusBold.magic_star,
                AppRoutes.aiChat),
            _actionButton(context, 'তথ্যভান্ডার', IconsaxPlusBold.book,
                AppRoutes.library),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.05);
  }

  Widget _actionButton(
      BuildContext context, String label, IconData icon, String route) {
    return AppCard(
      color: AppColors.accentWarm.withOpacity(0.5),
      child: InkWell(
        onTap: () => Get.toNamed(route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 32),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // [7] My Plants
  Widget _buildMyPlants(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('আমার গাছপালা 🌱', style: AppTextStyles.titleLarge(context)),
              TextButton(
                onPressed: () => Get.find<HomeController>().changePage(1),
                child: const Text('সব দেখুন →'),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: Obx(() => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.recentPlants.length,
                itemBuilder: (context, index) {
                  final plant = controller.recentPlants[index];
                  return _buildMiniPlantCard(context, plant);
                },
              )),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(begin: 0.05);
  }

  Widget _buildMiniPlantCard(BuildContext context, PlantModel plant) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      child: AppCard(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.accentWarm,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                    child: Text('🪴', style: TextStyle(fontSize: 32))),
              ),
            ),
            const SizedBox(height: 8),
            Text(plant.nameBn,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: plant.healthScore > 80
                        ? AppColors.success
                        : AppColors.warning,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(plant.healthScore > 80 ? '✅ ঠিক আছে' : '💧 আজই',
                    style: const TextStyle(fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // [8] Tip of the Day
  Widget _buildTipOfTheDay(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.accentWarm,
              AppColors.accent.withOpacity(0.5)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                const Icon(IconsaxPlusBold.lamp_on,
                    color: AppColors.primary, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('আজকের টিপস 💡',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Obx(() => Text(controller.dailyTip.value,
                          style: const TextStyle(fontSize: 13))),
                    ],
                  ),
                ),
              ],
            ),
            const Positioned(
              right: -10,
              bottom: -10,
              child: Opacity(
                opacity: 0.1,
                child: Icon(IconsaxPlusBold.tree,
                    size: 80, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 400.ms).slideY(begin: 0.05);
  }

  // Helpers
  IconData _getTaskIcon(String type) {
    switch (type) {
      case 'water':
        return IconsaxPlusBold.drop;
      case 'fertilize':
        return IconsaxPlusBold.element_plus;
      case 'prune':
        return IconsaxPlusBold.scissor_1;
      default:
        return IconsaxPlusBold.task_square;
    }
  }

  Color _getTaskColor(String type) {
    switch (type) {
      case 'water':
        return AppColors.water;
      case 'fertilize':
        return AppColors.soil;
      case 'prune':
        return AppColors.primary;
      default:
        return AppColors.success;
    }
  }
}
