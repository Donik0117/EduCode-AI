import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../auth/application/auth_controller.dart';
import 'models/ai_chat_message.dart';

abstract interface class AIChatRepository {
  Future<AIChatReply> sendMessage({
    required String message,
    String? conversationId,
    String? courseContext,
    String? lessonContext,
    String? programmingLanguage,
  });
}

class ApiAIChatRepository implements AIChatRepository {
  ApiAIChatRepository(this._dio, this._readAccessToken);

  final Dio _dio;
  final Future<String?> Function() _readAccessToken;

  @override
  Future<AIChatReply> sendMessage({
    required String message,
    String? conversationId,
    String? courseContext,
    String? lessonContext,
    String? programmingLanguage,
  }) async {
    final token = await _readAccessToken();
    if (token == null || token.isEmpty) {
      throw const FormatException('AI Mentordan foydalanish uchun tizimga kiring.');
    }

    final response = await _dio.post<Map<String, dynamic>>(
      '/ai/chat',
      data: {
        'message': message,
        if (conversationId != null) 'conversation_id': conversationId,
        if (courseContext != null) 'course_context': courseContext,
        if (lessonContext != null) 'lesson_context': lessonContext,
        if (programmingLanguage != null)
          'programming_language': programmingLanguage,
      },
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    final data = response.data;
    if (data == null) {
      throw const FormatException('AI Mentor bo‘sh javob qaytardi.');
    }
    return AIChatReply.fromJson(data);
  }
}

final aiChatRepositoryProvider = Provider<AIChatRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return ApiAIChatRepository(
    dio,
    () => storage.read(key: 'educode_access_token'),
  );
});
