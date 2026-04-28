import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/chat_message_model.dart';
import '../models/plant_model.dart';

class GeminiService {
  final String apiKey = const String.fromEnvironment('GEMINI_API_KEY', defaultValue: 'AIzaSyA_placeholder');
  late final GenerativeModel _model;
  late final GenerativeModel _visionModel;

  final String _chatSystemPrompt = """
তুমি 'পাতা' 🍃 — বাংলাদেশ ও দক্ষিণ এশিয়ার উদ্ভিদ বিশেষজ্ঞ AI।
নিয়মগুলো:
১. ব্যবহারকারী যে ভাষায় লেখে (বাংলা/ইংরেজি), সেই ভাষায় উত্তর দাও
২. উষ্ণ, বন্ধুত্বপূর্ণ এবং উৎসাহদায়ক হও
৩. সমস্যার জৈব ও রাসায়নিক দুটো সমাধানই দাও
৪. সবসময় পরিমাণ ও সতর্কতা উল্লেখ করো
৫. বাংলাদেশের জলবায়ু ও মাটি অনুযায়ী পরামর্শ দাও
৬. ছোট কৃষক ও শখের বাগানি দুজনকেই সাহায্য করো
""";

  final String _plantIdSystemPrompt = """
You are an expert botanist specializing in plants of Bangladesh and South Asia.
Analyze the image carefully and return ONLY valid JSON (no markdown, no extra text):
{
  "plantName": "English name",
  "plantNameBn": "বাংলা নাম",  
  "confidence": 85,
  "description": "বাংলায় ২ বাক্যের বর্ণনা",
  "careBasics": {
    "water": "পানির প্রয়োজন",
    "sunlight": "আলোর প্রয়োজন", 
    "soil": "মাটির ধরন",
    "season": "মৌসুম"
  },
  "commonProblems": ["সমস্যা ১", "সমস্যা ২"],
  "funFact": "মজার তথ্য বাংলায়",
  "isPlant": true
}
If not a plant or cannot identify: set confidence to 0, isPlant to false.
""";

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
    _visionModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  Stream<String> streamChatMessage(String message, List<ChatMessageModel> history, {String? imageBase64}) async* {
    final chat = _model.startChat(
      history: history.map((m) => Content(
        m.isUser ? 'user' : 'model',
        [TextPart(m.message)]
      )).toList(),
    );

    final List<Part> parts = [TextPart("System: $_chatSystemPrompt\nUser: $message")];
    if (imageBase64 != null) {
      parts.add(DataPart('image/jpeg', base64Decode(imageBase64)));
    }

    final response = chat.sendMessageStream(Content.multi(parts));
    await for (final chunk in response) {
      if (chunk.text != null) yield chunk.text!;
    }
  }

  Future<Map<String, dynamic>> identifyPlant(Uint8List imageBytes) async {
    try {
      final content = [
        Content.multi([
          TextPart(_plantIdSystemPrompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];
      final response = await _visionModel.generateContent(content);
      final text = response.text ?? '{}';
      // Clean possible markdown backticks
      final cleanJson = text.replaceAll('```json', '').replaceAll('```', '').trim();
      return jsonDecode(cleanJson);
    } catch (e) {
      return {"confidence": 0, "isPlant": false};
    }
  }

  Future<String> analyzeDisease(Uint8List imageBytes, String plantName) async {
    try {
      final prompt = """
Identify any diseases or pest problems for this $plantName. 
Provide the response in Bengali as 'পাতা' AI.
Include:
1. Problem name
2. Severity (High/Medium/Low)
3. Organic solution
4. Chemical solution
5. Prevention tips
""";
      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];
      final response = await _visionModel.generateContent(content);
      return response.text ?? 'দুঃখিত, কোনো সমস্যা শনাক্ত করা যায়নি।';
    } catch (e) {
      return 'Error analyzing disease: $e';
    }
  }

  Future<String> generateRoutineJSON(List<PlantModel> plants) async {
    final plantList = plants.map((p) => "${p.nameBn} (${p.waterFrequency})").join(", ");
    final prompt = "Create a weekly care routine for these plants: $plantList. Return in Bengali.";
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text ?? '';
  }
}
