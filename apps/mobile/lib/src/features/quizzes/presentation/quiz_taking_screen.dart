import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/quiz_repository.dart';
import '../data/models/quiz.dart';
import 'quiz_result_screen.dart';

class QuizTakingScreen extends ConsumerStatefulWidget {
  const QuizTakingScreen({required this.quiz, super.key});

  final Quiz quiz;

  @override
  ConsumerState<QuizTakingScreen> createState() => _QuizTakingScreenState();
}

class _QuizTakingScreenState extends ConsumerState<QuizTakingScreen> {
  final Map<String, String> _answers = {};
  bool _isSubmitting = false;

  Future<void> _submit(QuizDetail quiz) async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    try {
      final result = await ref
          .read(quizRepositoryProvider)
          .submitQuiz(quiz.id, Map<String, String>.from(_answers));
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => QuizResultScreen(result: result),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage(error))),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _errorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic> && data['detail'] is String) {
        return data['detail'] as String;
      }
      if (error.response == null) {
        return 'Serverga ulanib bo‘lmadi. Internet va API manzilini tekshiring.';
      }
    }
    if (error is FormatException) return error.message;
    return 'Testni topshirishda xatolik yuz berdi.';
  }

  Future<void> _confirmSubmit(QuizDetail quiz) async {
    final unanswered = quiz.questions.length - _answers.length;
    if (unanswered > 0) {
      final shouldSubmit = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Testni yakunlash'),
          content: Text(
            '$unanswered ta savolga javob berilmadi. Javobsiz savollar noto‘g‘ri deb baholanadi. Davom etasizmi?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Qaytish'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Topshirish'),
            ),
          ],
        ),
      );
      if (shouldSubmit != true) return;
    }
    await _submit(quiz);
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizDetailProvider(widget.quiz.id));

    return Scaffold(
      appBar: AppBar(title: const Text('Test')),
      body: quizState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Test savollarini yuklab bo‘lmadi.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () =>
                      ref.invalidate(quizDetailProvider(widget.quiz.id)),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Qayta urinish'),
                ),
              ],
            ),
          ),
        ),
        data: (quiz) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Text(
              quiz.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              quiz.description,
              style: const TextStyle(color: Colors.white70, height: 1.4),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  size: 17,
                  color: Color(0xFFA69EFF),
                ),
                const SizedBox(width: 6),
                Text(
                  '${quiz.durationMinutes} daqiqa',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.help_outline_rounded,
                  size: 17,
                  color: Color(0xFFA69EFF),
                ),
                const SizedBox(width: 6),
                Text(
                  '${quiz.questions.length} savol',
                  style: const TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 22),
            ...quiz.questions.asMap().entries.map(
              (entry) => _QuestionCard(
                question: entry.value,
                questionNumber: entry.key + 1,
                selectedAnswer: _answers[entry.value.id],
                onAnswerSelected: (answer) {
                  setState(() => _answers[entry.value.id] = answer);
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : () => _confirmSubmit(quiz),
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_rounded),
                label: Text(
                  _isSubmitting ? 'Tekshirilmoqda...' : 'Testni topshirish',
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Javoblar serverda tekshiriladi. To‘g‘ri javoblar test topshirilgandan keyin ko‘rsatiladi.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.question,
    required this.questionNumber,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  final QuizQuestion question;
  final int questionNumber;
  final String? selectedAnswer;
  final ValueChanged<String> onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Savol $questionNumber',
                  style: const TextStyle(
                    color: Color(0xFFA69EFF),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  '${question.points} ball',
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              question.prompt,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            ...question.options.map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onAnswerSelected(option),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: selectedAnswer == option
                          ? const Color(0xFF695CFF).withValues(alpha: 0.2)
                          : const Color(0xFF0F1527),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedAnswer == option
                            ? const Color(0xFF8D82FF)
                            : const Color(0xFF303A52),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selectedAnswer == option
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: selectedAnswer == option
                              ? const Color(0xFFA69EFF)
                              : Colors.white54,
                          size: 19,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            option,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
