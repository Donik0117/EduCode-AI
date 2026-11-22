import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../auth/application/auth_controller.dart';
import 'models/quiz.dart';

abstract interface class QuizRepository {
  Future<List<Quiz>> getQuizzes();

  Future<QuizDetail> getQuiz(String quizId);

  Future<QuizResult> submitQuiz(
    String quizId,
    Map<String, String> answers,
  );
}

class ApiQuizRepository implements QuizRepository {
  ApiQuizRepository(this._dio, this._readAccessToken);

  final Dio _dio;
  final Future<String?> Function() _readAccessToken;

  Future<Options> _authorizedOptions() async {
    final token = await _readAccessToken();
    if (token == null || token.isEmpty) {
      throw const FormatException('Testni topshirish uchun qayta tizimga kiring.');
    }
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<List<Quiz>> getQuizzes() async {
    final response = await _dio.get<List<dynamic>>('/quizzes');
    final data = response.data;
    if (data == null) {
      throw const FormatException('Testlar ro‘yxati olinmadi.');
    }
    return data
        .whereType<Map<String, dynamic>>()
        .map(Quiz.fromJson)
        .toList(growable: false);
  }

  @override
  Future<QuizDetail> getQuiz(String quizId) async {
    final response = await _dio.get<Map<String, dynamic>>('/quizzes/$quizId');
    final data = response.data;
    if (data == null) {
      throw const FormatException('Test ma’lumotlari olinmadi.');
    }
    return QuizDetail.fromJson(data);
  }

  @override
  Future<QuizResult> submitQuiz(
    String quizId,
    Map<String, String> answers,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/quizzes/$quizId/submit',
      data: {'answers': answers},
      options: await _authorizedOptions(),
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('Test natijasi serverdan olinmadi.');
    }
    return QuizResult.fromJson(data);
  }
}

final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return ApiQuizRepository(
    dio,
    () => storage.read(key: 'educode_access_token'),
  );
});

final quizzesProvider = FutureProvider.autoDispose<List<Quiz>>(
  (ref) => ref.watch(quizRepositoryProvider).getQuizzes(),
);

final quizDetailProvider = FutureProvider.family<QuizDetail, String>(
  (ref, quizId) => ref.watch(quizRepositoryProvider).getQuiz(quizId),
);
