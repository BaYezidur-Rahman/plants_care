import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import '../../utils/hive_boxes.dart';
import '../../routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _startNavigation();
  }

  void _startNavigation() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    final box = Hive.box(HiveBoxes.settings);
    final bool onboardingDone = box.get('onboardingDone', defaultValue: false);

    if (onboardingDone) {
      Get.offAllNamed(AppRoutes.main);
    } else {
      Get.offAllNamed(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF2D6A4F), Color(0xFF1B2F1E)],
            center: Alignment.center,
            radius: 1.0,
          ),
        ),
        child: Stack(
          children: [
            // Animated Dots
            ...List.generate(6, (index) => _buildAnimatedDot()),
            
            // Center Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🌿', style: TextStyle(fontSize: 80))
                      .animate()
                      .scale(
                        begin: Offset.zero,
                        end: const Offset(1, 1),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.elasticOut,
                      ),
                  const SizedBox(height: 20),
                  Text(
                    'গাছের যত্ন',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
                  const SizedBox(height: 8),
                  Text(
                    'PlantCare Pro',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white70),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 700)),
                  const SizedBox(height: 30),
                  Text(
                    'গাছকে ভালোবাসুন 🌱',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white54),
                  ).animate().fadeIn(delay: const Duration(milliseconds: 1000)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDot() {
    final random = Random();
    final left = random.nextDouble() * 400;
    final top = random.nextDouble() * 800;
    
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      )
      .animate(onPlay: (c) => c.repeat())
      .moveY(begin: 0, end: -30, duration: const Duration(milliseconds: 2000), curve: Curves.easeInOut)
      .fadeIn()
      .then()
      .fadeOut(),
    );
  }
}
