import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import '../data/models/chat_message_model.dart';
import '../data/services/gemini_service.dart';
import '../utils/hive_boxes.dart';

class AiController extends GetxController {
  final GeminiService _geminiService = GeminiService();
  late Box<ChatMessageModel> _chatBox;
  
  final messages = <ChatMessageModel>[].obs;
  final isLoading = false.obs;
  final selectedImageBase64 = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    _chatBox = Hive.box<ChatMessageModel>(HiveBoxes.chats);
    _loadMessages();
  }

  void _loadMessages() {
    messages.assignAll(_chatBox.values.toList()..sort((a, b) => a.timestamp.compareTo(b.timestamp)));
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      final bytes = await image.readAsBytes();
      selectedImageBase64.value = base64Encode(bytes);
    }
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty && selectedImageBase64.value == null) return;

    final userMessage = ChatMessageModel(
      message: text,
      isUser: true,
      timestamp: DateTime.now(),
      imageBase64: selectedImageBase64.value,
    );

    messages.add(userMessage);
    await _chatBox.add(userMessage);
    
    final currentText = text;
    final currentImage = selectedImageBase64.value;
    selectedImageBase64.value = null; // Clear after sending

    isLoading.value = true;
    
    try {
      String fullResponse = "";
      final aiMsgPlaceholder = ChatMessageModel(
        message: "",
        isUser: false,
        timestamp: DateTime.now(),
      );
      messages.add(aiMsgPlaceholder);
      final placeholderIndex = messages.length - 1;

      final stream = _geminiService.streamChatMessage(
        currentText, 
        messages.sublist(0, messages.length - 1), 
        imageBase64: currentImage
      );

      await for (final chunk in stream) {
        fullResponse += chunk;
        messages[placeholderIndex] = aiMsgPlaceholder.copyWith(message: fullResponse);
        messages.refresh();
      }

      // Save final AI message to Hive
      await _chatBox.add(messages[placeholderIndex]);
      
    } catch (e) {
      Get.snackbar('Error', 'AI এর সাথে যোগাযোগ করা যাচ্ছে না');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearHistory() async {
    await _chatBox.clear();
    messages.clear();
  }
}

extension ChatMessageExtension on ChatMessageModel {
  ChatMessageModel copyWith({String? message}) {
    return ChatMessageModel(
      message: message ?? this.message,
      isUser: isUser,
      timestamp: timestamp,
      imageBase64: imageBase64,
    );
  }
}
