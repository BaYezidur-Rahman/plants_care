import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends GetView {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const Center(child: Text('Settings View')));
  }
}
