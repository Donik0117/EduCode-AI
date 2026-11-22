class Course {
  const Course({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.category,
    required this.level,
    required this.language,
    required this.lessonsCount,
    required this.estimatedHours,
  });

  final String id;
  final String slug;
  final String title;
  final String description;
  final String category;
  final String level;
  final String language;
  final int lessonsCount;
  final int estimatedHours;

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      level: json['level'] as String,
      language: json['language'] as String,
      lessonsCount: (json['lessons_count'] as num).toInt(),
      estimatedHours: (json['estimated_hours'] as num).toInt(),
    );
  }

  String get levelLabel => switch (level) {
        'beginner' => 'Beginner',
        'intermediate' => 'Intermediate',
        'advanced' => 'Advanced',
        _ => level,
      };
}

class CourseModule {
  const CourseModule({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.position,
    required this.lessonsCount,
  });

  final String id;
  final String courseId;
  final String title;
  final String description;
  final int position;
  final int lessonsCount;

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    return CourseModule(
      id: json['id'] as String,
      courseId: json['course_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      position: (json['position'] as num).toInt(),
      lessonsCount: (json['lessons_count'] as num).toInt(),
    );
  }
}

class LessonSummary {
  const LessonSummary({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.summary,
    required this.language,
    required this.durationMinutes,
    required this.position,
  });

  final String id;
  final String moduleId;
  final String title;
  final String summary;
  final String language;
  final int durationMinutes;
  final int position;

  factory LessonSummary.fromJson(Map<String, dynamic> json) {
    return LessonSummary(
      id: json['id'] as String,
      moduleId: json['module_id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      language: json['language'] as String,
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      position: (json['position'] as num).toInt(),
    );
  }
}

class LessonContent extends LessonSummary {
  const LessonContent({
    required super.id,
    required super.moduleId,
    required super.title,
    required super.summary,
    required super.language,
    required super.durationMinutes,
    required super.position,
    required this.content,
    this.codeExample,
  });

  final String content;
  final String? codeExample;

  factory LessonContent.fromJson(Map<String, dynamic> json) {
    return LessonContent(
      id: json['id'] as String,
      moduleId: json['module_id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      language: json['language'] as String,
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      position: (json['position'] as num).toInt(),
      content: json['content'] as String,
      codeExample: json['code_example'] as String?,
    );
  }
}
