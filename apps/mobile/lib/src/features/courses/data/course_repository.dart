import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import 'models/course.dart';

abstract interface class CourseRepository {
  Future<List<Course>> getCourses();

  Future<List<CourseModule>> getModules(String courseId);

  Future<List<LessonSummary>> getLessons(String moduleId);

  Future<LessonContent> getLesson(String lessonId);
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

  @override
  Future<List<CourseModule>> getModules(String courseId) async {
    final response = await _dio.get<List<dynamic>>('/courses/$courseId/modules');
    final data = response.data;
    if (data == null) {
      throw const FormatException('Kurs modullari serverdan olinmadi.');
    }
    return data
        .whereType<Map<String, dynamic>>()
        .map(CourseModule.fromJson)
        .toList(growable: false);
  }

  @override
  Future<List<LessonSummary>> getLessons(String moduleId) async {
    final response = await _dio.get<List<dynamic>>(
      '/courses/modules/$moduleId/lessons',
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('Darslar ro‘yxati serverdan olinmadi.');
    }
    return data
        .whereType<Map<String, dynamic>>()
        .map(LessonSummary.fromJson)
        .toList(growable: false);
  }

  @override
  Future<LessonContent> getLesson(String lessonId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/courses/lessons/$lessonId',
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('Dars mazmuni serverdan olinmadi.');
    }
    return LessonContent.fromJson(data);
  }
}

final courseRepositoryProvider = Provider<CourseRepository>(
  (ref) => ApiCourseRepository(ref.watch(dioProvider)),
);

final coursesProvider = FutureProvider.autoDispose<List<Course>>(
  (ref) => ref.watch(courseRepositoryProvider).getCourses(),
);

final courseModulesProvider =
    FutureProvider.family<List<CourseModule>, String>(
  (ref, courseId) => ref.watch(courseRepositoryProvider).getModules(courseId),
);

final moduleLessonsProvider =
    FutureProvider.family<List<LessonSummary>, String>(
  (ref, moduleId) => ref.watch(courseRepositoryProvider).getLessons(moduleId),
);

final lessonContentProvider =
    FutureProvider.family<LessonContent, String>(
  (ref, lessonId) => ref.watch(courseRepositoryProvider).getLesson(lessonId),
);
