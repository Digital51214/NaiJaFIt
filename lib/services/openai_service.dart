import 'package:dio/dio.dart';

class OpenAIService {
  static OpenAIService? _instance;
  static OpenAIService get instance => _instance ??= OpenAIService._();

  OpenAIService._();

  late final Dio _dio;
  static const String apiKey = String.fromEnvironment('OPENAI_API_KEY');

  void initialize() {
    if (apiKey.isEmpty) {
      throw Exception('OPENAI_API_KEY must be provided via --dart-define');
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.openai.com/v1',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
      ),
    );
  }

  /// Send chat message and get AI response for Nigerian nutrition guidance
  Future<String> sendChatMessage({
    required List<ChatMessage> messages,
    String model = 'gpt-4o-mini',
  }) async {
    try {
      final requestData = {
        'model': model,
        'messages': messages.map((m) => m.toJson()).toList(),
        'temperature': 0.7,
        'max_tokens': 500,
      };

      final response = await _dio.post('/chat/completions', data: requestData);
      final text = response.data['choices'][0]['message']['content'];
      return text;
    } on DioException catch (e) {
      throw OpenAIException(
        statusCode: e.response?.statusCode ?? 500,
        message:
            e.response?.data['error']['message'] ??
            e.message ??
            'Unknown error',
      );
    }
  }

  /// Get system prompt for Nigerian nutrition context
  String getSystemPrompt(String? userGoal) {
    return '''
You are a Nigerian nutrition expert AI assistant for NaijaFit, specializing in personalized nutrition guidance for Nigerians.

User's Goal: ${userGoal ?? 'General health and wellness'}

Your expertise includes:
- Nigerian foods (Jollof rice, Egusi soup, Moi moi, Suya, Pounded yam, etc.)
- Calorie and macro content of Nigerian dishes
- Healthy Nigerian meal planning and portion control
- Cultural food practices and healthier alternatives
- Weight loss/gain strategies using Nigerian foods

Guidelines:
- Provide practical, actionable advice
- Reference specific Nigerian foods and dishes
- Keep responses concise (2-3 paragraphs max)
- Be encouraging and culturally sensitive
- Suggest realistic portion sizes and meal timing
- Recommend healthier cooking methods when appropriate
''';
  }
}

class ChatMessage {
  final String role;
  final String content;

  ChatMessage({required this.role, required this.content});

  Map<String, dynamic> toJson() => {'role': role, 'content': content};

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'] as String,
      content: json['content'] as String,
    );
  }
}

class OpenAIException implements Exception {
  final int statusCode;
  final String message;

  OpenAIException({required this.statusCode, required this.message});

  @override
  String toString() => 'OpenAI Error ($statusCode): $message';
}
