class LessonCompletion {
  const LessonCompletion({
    required this.id,
    required this.lessonId,
    required this.isCompleted,
    this.completedAt,
  });

  final String id;
  final String lessonId;
  final bool isCompleted;
  final DateTime? completedAt;

  factory LessonCompletion.fromJson(Map<String, dynamic> json) {
    return LessonCompletion(
      id: json['id'] as String,
      lessonId: json['lesson_id'] as String,
      isCompleted: json['is_completed'] as bool,
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );
  }
}

class LearningProgressSummary {
  const LearningProgressSummary({
    required this.userId,
    required this.completedLessonCount,
    required this.completedCourseCount,
    required this.completedLessonIds,
  });

  final String userId;
  final int completedLessonCount;
  final int completedCourseCount;
  final Set<String> completedLessonIds;

  bool hasCompletedLesson(String lessonId) =>
      completedLessonIds.contains(lessonId);

  factory LearningProgressSummary.fromJson(Map<String, dynamic> json) {
    return LearningProgressSummary(
      userId: json['user_id'] as String,
      completedLessonCount: (json['completed_lesson_count'] as num).toInt(),
      completedCourseCount: (json['completed_course_count'] as num).toInt(),
      completedLessonIds: (json['completed_lesson_ids'] as List<dynamic>)
          .whereType<String>()
          .toSet(),
    );
  }
}
