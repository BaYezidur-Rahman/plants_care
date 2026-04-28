// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../controllers/garden_controller.dart';
import '../../../data/models/plant_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class PlantDetailView extends StatefulWidget {
  const PlantDetailView({super.key});

  @override
  State<PlantDetailView> createState() => _PlantDetailViewState();
}

class _PlantDetailViewState extends State<PlantDetailView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final controller = Get.find<GardenController>();
  late PlantModel plant;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    plant = Get.arguments as PlantModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              stretch: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: Hero(
                  tag: 'plant_${plant.id}',
                  child: plant.photoPath != null && plant.photoPath!.isNotEmpty
                      ? Image.file(File(plant.photoPath!), fit: BoxFit.cover)
                      : Container(
                          decoration: const BoxDecoration(
                            gradient: AppColors.primaryGradient,
                          ),
                          child: Center(
                            child: Text(
                              _getCategoryEmoji(plant.category),
                              style: const TextStyle(fontSize: 80),
                            ),
                          ),
                        ),
                ),
              ),
              leading: IconButton(
                icon: const Icon(IconsaxPlusLinear.arrow_left, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(IconsaxPlusLinear.edit, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(IconsaxPlusLinear.trash, color: Colors.white),
                  onPressed: () => _confirmDelete(),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plant.nameBn, style: AppTextStyles.displayMedium(context)),
                    Text(plant.name, style: AppTextStyles.titleMedium(context).copyWith(color: AppColors.textHint)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _chip(plant.category, IconsaxPlusLinear.category),
                        const SizedBox(width: 8),
                        _chip(plant.location, IconsaxPlusLinear.location),
                        const SizedBox(width: 8),
                        _chip(controller.calculateAge(plant.datePlanted), IconsaxPlusLinear.calendar),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primary,
                  tabs: const [
                    Tab(text: 'সারসংক্ষেপ'),
                    Tab(text: 'ডায়েরি'),
                    Tab(text: 'যত্ন লগ'),
                    Tab(text: 'AI চেক'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildJournalTab(),
            _buildCareLogTab(),
            _buildAiAnalysisTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('যত্নের নিয়মাবলী'),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: [
              _careInfoCard('💧 পানি', plant.waterFrequency, AppColors.water),
              _careInfoCard('☀️ রোদ', plant.sunlightNeed, AppColors.sun),
              _careInfoCard('🌱 মাটি', 'দোআঁশ', AppColors.soil),
              _careInfoCard('🌡️ তাপমাত্রা', '১৫-২৫°C', Colors.orange),
              _careInfoCard('📅 মৌসুম', 'বারোমাসি', Colors.green),
              _careInfoCard('🕐 বয়স', controller.calculateAge(plant.datePlanted), AppColors.primary),
            ],
          ),
          const SizedBox(height: 32),
          _sectionTitle('যত্নের গাইড'),
          const SizedBox(height: 12),
          const Text(
            'এই গাছের সঠিক যত্নের জন্য নিয়মিত পানি দিন এবং পর্যাপ্ত আলো নিশ্চিত করুন। বেশি পানি দিলে শিকড় পচে যেতে পারে। মাঝে মাঝে জৈব সার দিন।',
            style: TextStyle(height: 1.5),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildJournalTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(IconsaxPlusLinear.note, size: 80, color: AppColors.textHint),
          const SizedBox(height: 16),
          const Text('গাছের প্রথম স্মৃতি লিখুন 📝'),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () {}, child: const Text('ডায়েরি যোগ করুন')),
        ],
      ),
    );
  }

  Widget _buildCareLogTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 3,
      itemBuilder: (context, index) {
        return const Card(
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.water,
              child: Icon(IconsaxPlusBold.drop, color: Colors.white, size: 16),
            ),
            title: Text('পানি দেওয়া হয়েছে'),
            subtitle: Text('আজ সকাল ৮:৩০'),
            trailing: Text('সফল', style: TextStyle(color: AppColors.success)),
          ),
        );
      },
    );
  }

  Widget _buildAiAnalysisTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(IconsaxPlusBold.magic_star, size: 80, color: AppColors.primary),
          const SizedBox(height: 24),
          const Text(
            'AI দিয়ে গাছ পরীক্ষা করুন',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'গাছের একটি পরিষ্কার ছবি তুলুন, AI বলে দেবে আপনার গাছ সুস্থ আছে কি না।',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(IconsaxPlusLinear.scan),
              label: const Text('পরীক্ষা শুরু করুন'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _careInfoCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _chip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
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

  void _confirmDelete() {
    Get.defaultDialog(
      title: 'ডিলিট নিশ্চিত করুন',
      middleText: 'আপনি কি নিশ্চিতভাবে এই গাছটি মুছে ফেলতে চান?',
      textConfirm: 'ডিলিট',
      textCancel: 'বাতিল',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      onConfirm: () {
        controller.deletePlant(plant.id);
        Get.back(); // close dialog
        Get.back(); // go back to garden
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
