import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/course_repository.dart';
import '../data/models/course.dart';
import 'lesson_screen.dart';

class CourseDetailScreen extends ConsumerWidget {
  const CourseDetailScreen({required this.course, super.key});

  final Course course;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modulesState = ref.watch(courseModulesProvider(course.id));

    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: modulesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _ContentError(
          message: 'Kurs modullarini yuklab bo‘lmadi.',
          onRetry: () => ref.invalidate(courseModulesProvider(course.id)),
        ),
        data: (modules) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF191F3B),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.levelLabel,
                    style: const TextStyle(
                      color: Color(0xFFB1A9FF),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    course.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: const TextStyle(color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [
                      _CoursePill('${course.lessonsCount} dars'),
                      _CoursePill('${course.estimatedHours} soat'),
                      _CoursePill(course.language),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Kurs dasturi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            if (modules.isEmpty)
              const Text(
                'Bu kurs uchun modullar hali qo‘shilmagan.',
                style: TextStyle(color: Colors.white60),
              )
            else
              ...modules.map(
                (module) => _ModuleCard(module: module),
              ),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends ConsumerWidget {
  const _ModuleCard({required this.module});

  final CourseModule module;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsState = ref.watch(moduleLessonsProvider(module.id));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFF2A2754),
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: Color(0xFFB1A9FF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        module.description,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${module.lessonsCount} dars',
                  style: const TextStyle(
                    color: Color(0xFFB1A9FF),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            lessonsState.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(12),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stackTrace) => TextButton.icon(
                onPressed: () =>
                    ref.invalidate(moduleLessonsProvider(module.id)),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Darslarni qayta yuklash'),
              ),
              data: (lessons) => Column(
                children: lessons
                    .map(
                      (lesson) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.play_circle_outline_rounded,
                          color: Color(0xFF9D93FF),
                        ),
                        title: Text(
                          lesson.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${lesson.durationMinutes} daqiqa • ${lesson.language}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white54,
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => LessonScreen(lesson: lesson),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoursePill extends StatelessWidget {
  const _CoursePill(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF2B3150),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ),
    );
  }
}

class _ContentError extends StatelessWidget {
  const _ContentError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Qayta urinish'),
          ),
        ],
      ),
    );
  }
}
