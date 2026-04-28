import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BackupView extends GetView {
  const BackupView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Backup')),
        body: const Center(child: Text('Backup View')));
  }
}
