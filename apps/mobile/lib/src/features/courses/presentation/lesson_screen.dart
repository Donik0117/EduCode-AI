import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../progress/data/progress_repository.dart';
import '../data/course_repository.dart';
import '../data/models/course.dart';

class LessonScreen extends ConsumerStatefulWidget {
  const LessonScreen({required this.lesson, super.key});

  final LessonSummary lesson;

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  bool _isSavingCompletion = false;
  bool _completedLocally = false;

  Future<void> _completeLesson() async {
    setState(() => _isSavingCompletion = true);
    try {
      await ref
          .read(progressRepositoryProvider)
          .completeLesson(widget.lesson.id);
      if (!mounted) return;
      setState(() => _completedLocally = true);
      ref.invalidate(myProgressProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Barakalla! Dars yakunlandi va progress saqlandi.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_completionError(error))),
      );
    } finally {
      if (mounted) setState(() => _isSavingCompletion = false);
    }
  }

  String _completionError(Object error) {
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
    return 'Dars progressini saqlashda xatolik yuz berdi.';
  }

  @override
  Widget build(BuildContext context) {
    final lessonState = ref.watch(lessonContentProvider(widget.lesson.id));
    final progressState = ref.watch(myProgressProvider);
    final completedOnServer = progressState.when(
      data: (summary) => summary.hasCompletedLesson(widget.lesson.id),
      loading: () => false,
      error: (error, stackTrace) => false,
    );
    final isCompleted = completedOnServer || _completedLocally;

    return Scaffold(
      appBar: AppBar(title: const Text('Dars')),
      body: lessonState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Dars mazmunini yuklab bo‘lmadi.',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () =>
                      ref.invalidate(lessonContentProvider(widget.lesson.id)),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Qayta urinish'),
                ),
              ],
            ),
          ),
        ),
        data: (content) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Text(
              content.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${content.durationMinutes} daqiqa • ${content.language}',
              style: const TextStyle(color: Color(0xFFB1A9FF), fontSize: 12),
            ),
            const SizedBox(height: 18),
            Text(
              content.summary,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 22),
            ..._buildLessonContent(content.content),
            if (content.codeExample != null &&
                content.codeExample!.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Kod misoli',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF090D18),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF303A52)),
                ),
                child: SelectableText(
                  content.codeExample!,
                  style: const TextStyle(
                    color: Color(0xFFBDE7CE),
                    fontFamily: 'monospace',
                    height: 1.5,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 28),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: isCompleted || _isSavingCompletion
                    ? null
                    : _completeLesson,
                icon: _isSavingCompletion
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.check_circle_outline_rounded,
                      ),
                label: Text(
                  isCompleted ? 'Dars yakunlangan' : 'Darsni tugatdim',
                ),
              ),
            ),
            if (isCompleted) ...[
              const SizedBox(height: 8),
              const Text(
                'Natijangiz profilingizdagi o‘quv progressiga qo‘shildi.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF72D6B2), fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLessonContent(String content) {
    final widgets = <Widget>[];
    for (final line in content.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        widgets.add(const SizedBox(height: 8));
      } else if (trimmed.startsWith('# ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              trimmed.substring(2),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        );
      } else if (trimmed.startsWith('## ')) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              trimmed.substring(3),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              trimmed,
              style: const TextStyle(
                color: Colors.white70,
                height: 1.55,
                fontSize: 14,
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }
}
