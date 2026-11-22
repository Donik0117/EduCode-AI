class Quiz {
  const Quiz({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.questionsCount,
  });

  final String id;
  final String moduleId;
  final String title;
  final String description;
  final int durationMinutes;
  final int questionsCount;

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      moduleId: json['module_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      questionsCount: (json['questions_count'] as num).toInt(),
    );
  }
}

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    required this.points,
    required this.position,
  });

  final String id;
  final String prompt;
  final List<String> options;
  final int points;
  final int position;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      prompt: json['prompt'] as String,
      options: (json['options'] as List<dynamic>).whereType<String>().toList(),
      points: (json['points'] as num).toInt(),
      position: (json['position'] as num).toInt(),
    );
  }
}

class QuizDetail extends Quiz {
  const QuizDetail({
    required super.id,
    required super.moduleId,
    required super.title,
    required super.description,
    required super.durationMinutes,
    required super.questionsCount,
    required this.questions,
  });

  final List<QuizQuestion> questions;

  factory QuizDetail.fromJson(Map<String, dynamic> json) {
    return QuizDetail(
      id: json['id'] as String,
      moduleId: json['module_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      questionsCount: (json['questions_count'] as num).toInt(),
      questions: (json['questions'] as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(QuizQuestion.fromJson)
          .toList(growable: false),
    );
  }
}

class QuizQuestionResult {
  const QuizQuestionResult({
    required this.questionId,
    required this.prompt,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.explanation,
    required this.pointsAwarded,
    required this.pointsPossible,
  });

  final String questionId;
  final String prompt;
  final String? selectedAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final String explanation;
  final int pointsAwarded;
  final int pointsPossible;

  factory QuizQuestionResult.fromJson(Map<String, dynamic> json) {
    return QuizQuestionResult(
      questionId: json['question_id'] as String,
      prompt: json['prompt'] as String,
      selectedAnswer: json['selected_answer'] as String?,
      correctAnswer: json['correct_answer'] as String,
      isCorrect: json['is_correct'] as bool,
      explanation: json['explanation'] as String,
      pointsAwarded: (json['points_awarded'] as num).toInt(),
      pointsPossible: (json['points_possible'] as num).toInt(),
    );
  }
}

class QuizResult {
  const QuizResult({
    required this.id,
    required this.quizId,
    required this.quizTitle,
    required this.score,
    required this.totalPoints,
    required this.correctAnswers,
    required this.questionCount,
    required this.percentage,
    required this.submittedAt,
    required this.questionResults,
  });

  final String id;
  final String quizId;
  final String quizTitle;
  final int score;
  final int totalPoints;
  final int correctAnswers;
  final int questionCount;
  final double percentage;
  final DateTime submittedAt;
  final List<QuizQuestionResult> questionResults;

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id'] as String,
      quizId: json['quiz_id'] as String,
      quizTitle: json['quiz_title'] as String,
      score: (json['score'] as num).toInt(),
      totalPoints: (json['total_points'] as num).toInt(),
      correctAnswers: (json['correct_answers'] as num).toInt(),
      questionCount: (json['question_count'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
      submittedAt: DateTime.parse(json['submitted_at'] as String),
      questionResults: (json['question_results'] as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(QuizQuestionResult.fromJson)
          .toList(growable: false),
    );
  }
}
