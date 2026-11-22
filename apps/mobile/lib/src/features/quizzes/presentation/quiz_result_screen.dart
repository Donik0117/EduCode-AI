import 'package:material_ui/material_ui.dart';

import '../data/models/quiz.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({required this.result, super.key});

  final QuizResult result;

  @override
  Widget build(BuildContext context) {
    final isSuccessful = result.percentage >= 70;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test natijasi'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF151C30),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF303A52)),
            ),
            child: Column(
              children: [
                Icon(
                  isSuccessful
                      ? Icons.emoji_events_rounded
                      : Icons.school_rounded,
                  size: 48,
                  color: isSuccessful
                      ? const Color(0xFFFFD166)
                      : const Color(0xFFA69EFF),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Natijangiz',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '${result.percentage.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${result.score} / ${result.totalPoints} ball',
                  style: const TextStyle(
                    color: Color(0xFFB1A9FF),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  '${result.correctAnswers} ta to‘g‘ri javob / ${result.questionCount} ta savol',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const SizedBox(height: 14),
                Text(
                  isSuccessful
                      ? 'Ajoyib! Mavzuni yaxshi o‘zlashtirgansiz.'
                      : 'Yaxshi harakat! Izohlarni ko‘rib, yana mashq qiling.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Javoblar tahlili',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...result.questionResults.map(
            (question) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          question.isCorrect
                              ? Icons.check_circle_rounded
                              : Icons.cancel_rounded,
                          color: question.isCorrect
                              ? const Color(0xFF72D6B2)
                              : const Color(0xFFFF8E8E),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            question.prompt,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _AnswerLine(
                      label: 'Sizning javobingiz',
                      value: question.selectedAnswer ?? 'Javob berilmagan',
                      color: question.isCorrect
                          ? const Color(0xFF72D6B2)
                          : const Color(0xFFFF8E8E),
                    ),
                    if (!question.isCorrect) ...[
                      const SizedBox(height: 6),
                      _AnswerLine(
                        label: 'To‘g‘ri javob',
                        value: question.correctAnswer,
                        color: const Color(0xFF72D6B2),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Text(
                      question.explanation,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Amaliyotga qaytish'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerLine extends StatelessWidget {
  const _AnswerLine({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 135,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
