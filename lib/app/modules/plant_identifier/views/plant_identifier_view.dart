// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/plant_identifier_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class PlantIdentifierView extends GetView<PlantIdentifierController> {
  const PlantIdentifierView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        switch (controller.state.value) {
          case IdentifierState.idle:
            return _buildIdleState(context);
          case IdentifierState.loading:
            return _buildLoadingState(context);
          case IdentifierState.success:
            return _buildSuccessState(context);
          case IdentifierState.notPlant:
            return _buildNotPlantState(context);
          case IdentifierState.error:
            return _buildErrorState(context);
        }
      }),
    );
  }

  Widget _buildIdleState(BuildContext context) {
    return Stack(
      children: [
        // Camera Placeholder
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black54, Colors.black87],
            ),
          ),
          child: const Center(
            child:
                Icon(IconsaxPlusBold.camera, size: 80, color: Colors.white24),
          ),
        ),

        // History List
        Positioned(
          top: 60,
          left: 0,
          right: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('সাম্প্রতিক শনাক্তকরণ',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ),
              const SizedBox(height: 12),
              _buildHistoryList(),
            ],
          ),
        ),

        // Controls
        Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: Column(
            children: [
              const Text('গাছের ছবি তুলুন বা গ্যালারি থেকে নিন',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _circleButton(IconsaxPlusLinear.gallery,
                      () => controller.pickImage(ImageSource.gallery)),
                  _captureButton(
                      () => controller.pickImage(ImageSource.camera)),
                  _circleButton(IconsaxPlusLinear.flash_1, () {}),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          top: 40,
          left: 20,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 24),
          Text('শনাক্ত করা হচ্ছে...',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          SizedBox(height: 8),
          Text('অনুগ্রহ করে অপেক্ষা করুন',
              style: TextStyle(color: Colors.white70)),
        ],
      ).animate().fadeIn(),
    );
  }

  Widget _buildSuccessState(BuildContext context) {
    final data = controller.result.value!;
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                if (controller.selectedImage.value != null)
                  Image.file(controller.selectedImage.value!,
                      width: double.infinity, height: 350, fit: BoxFit.cover),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => controller.reset(),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['plantNameBn'],
                                style: AppTextStyles.displayMedium(context)),
                            Text(data['plantName'],
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 16)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            shape: BoxShape.circle),
                        child: Text('${data['confidence']}%',
                            style: const TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(data['description'],
                      style: const TextStyle(height: 1.5, fontSize: 15)),
                  const SizedBox(height: 32),
                  _infoSection('মৌলিক যত্ন', [
                    _infoRow(IconsaxPlusLinear.drop,
                        'পানি: ${data['careBasics']['water']}'),
                    _infoRow(IconsaxPlusLinear.sun_1,
                        'আলো: ${data['careBasics']['sunlight']}'),
                    _infoRow(IconsaxPlusLinear.status,
                        'মাটি: ${data['careBasics']['soil']}'),
                  ]),
                  const SizedBox(height: 24),
                  _infoSection('মজার তথ্য 💡', [
                    Text(data['funFact'],
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                  ]),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => controller.reset(),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                      child: const Text('আবার চেষ্টা করুন',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().slideY(begin: 1.0);
  }

  Widget _buildNotPlantState(BuildContext context) {
    return _errorLayout(
        context,
        IconsaxPlusBold.close_circle,
        'গাছ খুঁজে পাওয়া যায়নি',
        'অনুগ্রহ করে গাছের পাতার একটি পরিষ্কার ছবি তুলুন');
  }

  Widget _buildErrorState(BuildContext context) {
    return _errorLayout(context, IconsaxPlusBold.warning_2, 'একটি সমস্যা হয়েছে',
        'ইন্টারনেট কানেকশন চেক করে আবার চেষ্টা করুন');
  }

  Widget _errorLayout(
      BuildContext context, IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.white24),
            const SizedBox(height: 24),
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => controller.reset(),
              child: const Text('ফিরে যান'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.history.length,
        itemBuilder: (context, index) {
          final item = controller.history[index];
          return Container(
            width: 70,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
                color: Colors.white12, borderRadius: BorderRadius.circular(12)),
            child: Center(
                child: Text(item['name'][0],
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold))),
          );
        },
      ),
    );
  }

  Widget _infoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.white10),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _captureButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4)),
        child: Container(
            margin: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white)),
      ),
    );
  }
}
