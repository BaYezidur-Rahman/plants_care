// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/ai_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../data/models/chat_message_model.dart';

class AiChatScreen extends GetView<AiController> {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('পাতা 🍃 AI'),
        actions: [
          IconButton(
            icon: const Icon(IconsaxPlusLinear.trash),
            onPressed: () => controller.clearHistory(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.messages.isEmpty) {
                return _buildEmptyChat(context);
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return _buildChatBubble(context, msg);
                },
              );
            }),
          ),
          _buildInputArea(context, textController),
        ],
      ),
    );
  }

  Widget _buildEmptyChat(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(IconsaxPlusBold.magic_star, size: 80, color: AppColors.primary),
          const SizedBox(height: 16),
          Text('আমি "পাতা" 🍃', style: AppTextStyles.titleLarge(context)),
          const SizedBox(height: 8),
          const Text('আমি আপনার উদ্ভিদ বিশেষজ্ঞ AI। কিছু জিজ্ঞেস করুন!', style: TextStyle(color: Colors.grey)),
        ],
      ).animate().fadeIn().scale(),
    );
  }

  Widget _buildChatBubble(BuildContext context, ChatMessageModel msg) {
    final isUser = msg.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (msg.imageBase64 != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  base64Decode(msg.imageBase64!),
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            decoration: BoxDecoration(
              color: isUser ? AppColors.primary : AppColors.accentWarm.withOpacity(0.5),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isUser ? 20 : 0),
                bottomRight: Radius.circular(isUser ? 0 : 20),
              ),
            ),
            child: _renderMessageText(context, msg.message, isUser),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: isUser ? 0.1 : -0.1);
  }

  Widget _renderMessageText(BuildContext context, String text, bool isUser) {
    // Simple markdown-like rendering
    return SelectableText(
      text,
      style: AppTextStyles.bodyLarge(context).copyWith(
        color: isUser ? Colors.white : AppColors.textPrimary,
        height: 1.5,
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, TextEditingController textController) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Column(
        children: [
          Obx(() => controller.selectedImageBase64.value != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(base64Decode(controller.selectedImageBase64.value!), height: 80, width: 80, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 0, right: 0,
                      child: GestureDetector(
                        onTap: () => controller.selectedImageBase64.value = null,
                        child: const CircleAvatar(radius: 10, backgroundColor: Colors.red, child: Icon(Icons.close, size: 12, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox()),
          Row(
            children: [
              IconButton(
                icon: const Icon(IconsaxPlusLinear.camera, color: AppColors.primary),
                onPressed: () => controller.pickImage(),
              ),
              Expanded(
                child: TextField(
                  controller: textController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'আপনার প্রশ্ন লিখুন...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Obx(() => controller.isLoading.value 
                ? const SizedBox(width: 48, child: CircularProgressIndicator(strokeWidth: 2))
                : CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      icon: const Icon(IconsaxPlusLinear.send_1, color: Colors.white, size: 20),
                      onPressed: () {
                        if (textController.text.isNotEmpty || controller.selectedImageBase64.value != null) {
                          controller.sendMessage(textController.text);
                          textController.clear();
                        }
                      },
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
