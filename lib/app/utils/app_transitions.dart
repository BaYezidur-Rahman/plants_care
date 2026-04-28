import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTransitions {
  static CustomTransition get fadeScale => CustomFadeScaleTransition();
}

class CustomFadeScaleTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.97, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: curve ?? Curves.easeOut),
        ),
        child: child,
      ),
    );
  }
}
