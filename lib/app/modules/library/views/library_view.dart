import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LibraryView extends GetView {
  const LibraryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Library')),
        body: const Center(child: Text('Library View')));
  }
}
