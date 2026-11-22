import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'models/course.dart';

abstract interface class CourseRepository {
  Future<List<Course>> getCourses();
}

class ApiCourseRepository implements CourseRepository {
  ApiCourseRepository(this._dio);

  final Dio _dio;

  @override
  Future<List<Course>> getCourses() async {
    final response = await _dio.get<List<dynamic>>('/courses');
    final data = response.data;
    if (data == null) {
      throw const FormatException('Kurslar ro‘yxati serverdan olinmadi.');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(Course.fromJson)
        .toList(growable: false);
  }
}

final courseRepositoryProvider = Provider<CourseRepository>(
  (ref) => ApiCourseRepository(ref.watch(dioProvider)),
);

final coursesProvider = FutureProvider.autoDispose<List<Course>>(
  (ref) => ref.watch(courseRepositoryProvider).getCourses(),
);
