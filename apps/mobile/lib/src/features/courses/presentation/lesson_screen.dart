import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/course_repository.dart';
import '../data/models/course.dart';

class LessonScreen extends ConsumerWidget {
  const LessonScreen({required this.lesson, super.key});

  final LessonSummary lesson;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonState = ref.watch(lessonContentProvider(lesson.id));

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
                      ref.invalidate(lessonContentProvider(lesson.id)),
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
            FilledButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Dars progressini saqlash keyingi bosqichda ulanadi.',
                  ),
                ),
              ),
              icon: const Icon(Icons.check_circle_outline_rounded),
              label: const Text('Darsni tugatdim'),
            ),
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
