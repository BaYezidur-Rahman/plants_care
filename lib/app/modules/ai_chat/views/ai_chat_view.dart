import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AichatView extends GetView {
  const AichatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Aichat')),
        body: const Center(child: Text('Aichat View')));
  }
}
