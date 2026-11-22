import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/course_repository.dart';
import '../data/models/course.dart';

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key});

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> {
  String _query = '';
  String _selectedLevel = 'Barchasi';

  @override
  Widget build(BuildContext context) {
    final coursesState = ref.watch(coursesProvider);

    return SafeArea(
      child: coursesState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _CoursesError(
          onRetry: () => ref.invalidate(coursesProvider),
        ),
        data: (courses) {
          final visibleCourses = courses.where((course) {
            final query = _query.trim().toLowerCase();
            final matchesQuery = query.isEmpty ||
                course.title.toLowerCase().contains(query) ||
                course.category.toLowerCase().contains(query) ||
                course.language.toLowerCase().contains(query);
            final matchesLevel = _selectedLevel == 'Barchasi' ||
                course.levelLabel == _selectedLevel;
            return matchesQuery && matchesLevel;
          }).toList(growable: false);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              const Text(
                'Bilimingizni keyingi bosqichga olib chiqing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Yo‘nalishingizni tanlang va o‘rganishni boshlang.',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.62)),
              ),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: 'Kurs qidirish...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  filled: true,
                  fillColor: const Color(0xFF151C30),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                children: [
                  'Barchasi',
                  'Beginner',
                  'Intermediate',
                  'Advanced',
                ]
                    .map(
                      (level) => ChoiceChip(
                        label: Text(level),
                        selected: _selectedLevel == level,
                        onSelected: (_) =>
                            setState(() => _selectedLevel = level),
                      ),
                    )
                    .toList(growable: false),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Barcha kurslar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${visibleCourses.length} ta kurs',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (visibleCourses.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: Text(
                      'Mos kurs topilmadi.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                )
              else
                ...visibleCourses.map(
                  (course) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _CourseCard(course: course),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CoursesError extends StatelessWidget {
  const _CoursesError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              color: Colors.white54,
              size: 40,
            ),
            const SizedBox(height: 14),
            const Text(
              'Kurslarni yuklab bo‘lmadi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Backend server ishlayotganini va API manzilini tekshiring.',
              style: TextStyle(color: Colors.white60),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Qayta yuklash'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final icon = switch (course.language.toLowerCase()) {
      'python' => Icons.terminal_rounded,
      'dart' => Icons.flutter_dash_rounded,
      'javascript' => Icons.javascript_rounded,
      'sql' => Icons.storage_rounded,
      'c++' => Icons.account_tree_rounded,
      _ => Icons.code_rounded,
    };
    final color = switch (course.language.toLowerCase()) {
      'python' => const Color(0xFF6FA8FF),
      'dart' => const Color(0xFF55B8E8),
      'javascript' => const Color(0xFFFFD166),
      'sql' => const Color(0xFFFFA45B),
      'c++' => const Color(0xFFB69CFF),
      _ => const Color(0xFF72D6B2),
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.14),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.category,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white54,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              course.description,
              style: const TextStyle(
                color: Colors.white70,
                height: 1.4,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              children: [
                _InfoPill(course.levelLabel),
                _InfoPill('${course.lessonsCount} dars'),
                _InfoPill('${course.estimatedHours} soat'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF27314A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ),
    );
  }
}
