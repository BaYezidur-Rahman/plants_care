import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GardenView extends GetView {
  const GardenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Garden')),
        body: const Center(child: Text('Garden View')));
  }
}
