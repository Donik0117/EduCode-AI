import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../auth/application/auth_controller.dart';
import 'models/learning_progress.dart';

abstract interface class ProgressRepository {
  Future<LessonCompletion> completeLesson(String lessonId);

  Future<LearningProgressSummary> getMyProgress();
}

class ApiProgressRepository implements ProgressRepository {
  ApiProgressRepository(this._dio, this._readAccessToken);

  final Dio _dio;
  final Future<String?> Function() _readAccessToken;

  Future<Options> _authorizedOptions() async {
    final token = await _readAccessToken();
    if (token == null || token.isEmpty) {
      throw const FormatException('Davom etish uchun qayta tizimga kiring.');
    }
    return Options(
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  @override
  Future<LessonCompletion> completeLesson(String lessonId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/progress/lessons/$lessonId/complete',
      options: await _authorizedOptions(),
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('Dars progressi saqlanmadi.');
    }
    return LessonCompletion.fromJson(data);
  }

  @override
  Future<LearningProgressSummary> getMyProgress() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/progress/me',
      options: await _authorizedOptions(),
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('O‘quv progressi olinmadi.');
    }
    return LearningProgressSummary.fromJson(data);
  }
}

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final storage = ref.watch(secureStorageProvider);
  return ApiProgressRepository(
    dio,
    () => storage.read(key: 'educode_access_token'),
  );
});

final myProgressProvider = FutureProvider.autoDispose<LearningProgressSummary>(
  (ref) => ref.watch(progressRepositoryProvider).getMyProgress(),
);
