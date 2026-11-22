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
