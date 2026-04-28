import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';

import 'package:intl/intl.dart';

import '../../../data/models/plant_model.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../controllers/garden_controller.dart';

class AddPlantBottomSheet extends StatefulWidget {
  const AddPlantBottomSheet({super.key});

  @override
  State<AddPlantBottomSheet> createState() => _AddPlantBottomSheetState();
}

class _AddPlantBottomSheetState extends State<AddPlantBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<GardenController>();
  final _confettiController = ConfettiController(duration: const Duration(seconds: 2));

  // Form Fields
  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  String _selectedCategory = 'অন্যান্য';
  String _selectedLocation = 'ইনডোর';
  String _selectedWaterFreq = '২দিনে';
  String _selectedSunlight = 'আংশিক ছায়া';
  DateTime _selectedDate = DateTime.now();
  String? _photoPath;
  bool _isSaving = false;

  @override
  void dispose() {
    _confettiController.dispose();
    _nameController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() => _photoPath = image.path);
    }
  }

  void _save() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);

      final newPlant = PlantModel(
        name: _nameController.text,
        nameBn: _nameController.text,
        nickname: _nicknameController.text.isEmpty ? _nameController.text : _nicknameController.text,
        nicknameBn: _nicknameController.text.isEmpty ? _nameController.text : _nicknameController.text,
        category: _selectedCategory,
        location: _selectedLocation,
        datePlanted: _selectedDate,
        waterFrequency: _selectedWaterFreq,
        sunlightNeed: _selectedSunlight,
        photoPath: _photoPath,
        healthScore: 100,
        isFavorite: false,
      );

      await controller.addPlant(newPlant);
      
      _confettiController.play();
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        Get.back();
        Get.snackbar(
          'সফল!',
          'আপনার নতুন বন্ধু "${newPlant.nameBn}" যুক্ত হয়েছে 🌿',
          backgroundColor: AppColors.success,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('নতুন গাছ যোগ করুন 🌱', style: AppTextStyles.titleLarge(context).copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 24),

                      // Photo Picker
                      Center(
                        child: GestureDetector(
                          onTap: () => _showImageSourceActionSheet(),
                          child: Hero(
                            tag: 'add_photo',
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColors.accentWarm,
                              backgroundImage: _photoPath != null ? FileImage(File(_photoPath!)) : null,
                              child: _photoPath == null 
                                ? const Icon(IconsaxPlusLinear.camera, size: 40, color: AppColors.primary) 
                                : null,
                            ).animate().scale(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Name Field
                      _buildTextField(
                        label: 'গাছের নাম (যেমন: বেলী ফুল)',
                        controller: _nameController,
                        icon: IconsaxPlusLinear.tree,
                        validator: (v) => v!.isEmpty ? 'নাম দিন' : null,
                      ),
                      const SizedBox(height: 16),

                      // Nickname Field
                      _buildTextField(
                        label: 'ডাকনাম (ঐচ্ছিক)',
                        controller: _nicknameController,
                        icon: IconsaxPlusLinear.edit,
                      ),
                      const SizedBox(height: 24),

                      _sectionLabel('ক্যাটাগরি'),
                      _buildCategoryChips(),
                      const SizedBox(height: 24),

                      _sectionLabel('অবস্থান'),
                      _buildLocationChips(),
                      const SizedBox(height: 24),

                      _sectionLabel('রোপণের তারিখ'),
                      _buildDatePicker(),
                      const SizedBox(height: 24),

                      _sectionLabel('পানি দেয়ার ফ্রিকোয়েন্সি'),
                      _buildWaterFreqChips(),
                      const SizedBox(height: 24),

                      _sectionLabel('সূর্যালোকে অবস্থান'),
                      _buildSunlightChips(),
                      const SizedBox(height: 40),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: _isSaving 
                            ? const CircularProgressIndicator(color: Colors.white) 
                            : const Text('সংরক্ষণ করুন', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange],
        ),
      ],
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, required IconData icon, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _buildCategoryChips() {
    final categories = ['ফলের গাছ', 'সবজি', 'ফুলের গাছ', 'ভেষজ', 'অন্যান্য'];
    return Wrap(
      spacing: 8,
      children: categories.map((cat) {
        final isSelected = _selectedCategory == cat;
        return ChoiceChip(
          label: Text(cat),
          selected: isSelected,
          onSelected: (val) => setState(() => _selectedCategory = cat),
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
        );
      }).toList(),
    );
  }

  Widget _buildLocationChips() {
    final locations = ['ইনডোর', 'আউটডোর', 'বারান্দা', 'ছাদ'];
    return Wrap(
      spacing: 8,
      children: locations.map((loc) {
        final isSelected = _selectedLocation == loc;
        return ChoiceChip(
          label: Text(loc),
          selected: isSelected,
          onSelected: (val) => setState(() => _selectedLocation = loc),
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
        );
      }).toList(),
    );
  }

  Widget _buildWaterFreqChips() {
    final freqs = ['প্রতিদিন', '২দিনে', 'সপ্তাহে', 'প্রয়োজনে'];
    return Wrap(
      spacing: 8,
      children: freqs.map((f) {
        final isSelected = _selectedWaterFreq == f;
        return ChoiceChip(
          label: Text(f),
          selected: isSelected,
          onSelected: (val) => setState(() => _selectedWaterFreq = f),
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
        );
      }).toList(),
    );
  }

  Widget _buildSunlightChips() {
    final options = ['পূর্ণ রোদ', 'আংশিক ছায়া', 'ছায়া'];
    return Wrap(
      spacing: 8,
      children: options.map((opt) {
        final isSelected = _selectedSunlight == opt;
        return ChoiceChip(
          label: Text(opt),
          selected: isSelected,
          onSelected: (val) => setState(() => _selectedSunlight = opt),
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
        );
      }).toList(),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (date != null) setState(() => _selectedDate = date);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(IconsaxPlusLinear.calendar, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(DateFormat('dd MMMM yyyy').format(_selectedDate)),
          ],
        ),
      ),
    );
  }

  void _showImageSourceActionSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(IconsaxPlusLinear.camera),
              title: const Text('ক্যামেরা দিয়ে ছবি তুলুন'),
              onTap: () { Get.back(); _pickImage(ImageSource.camera); },
            ),
            ListTile(
              leading: const Icon(IconsaxPlusLinear.gallery),
              title: const Text('গ্যালারি থেকে নিন'),
              onTap: () { Get.back(); _pickImage(ImageSource.gallery); },
            ),
          ],
        ),
      ),
    );
  }
}
