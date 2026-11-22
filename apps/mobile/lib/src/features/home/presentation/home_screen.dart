import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../ai_mentor/presentation/ai_chat_screen.dart';
import '../../courses/data/course_repository.dart';
import '../../courses/data/models/course.dart';
import '../../courses/presentation/course_detail_screen.dart';
import '../../courses/presentation/courses_screen.dart';
import '../../practice/presentation/practice_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../progress/data/progress_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const _titles = ['EduCode AI', 'Kurslar', 'Amaliyot', 'Profil'];

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _DashboardScreen(),
      const CoursesScreen(),
      const PracticeScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.code_rounded, color: Color(0xFF9B91FF)),
            const SizedBox(width: 10),
            Text(
              _titles[_selectedIndex],
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: 'Bildirishnomalar',
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Bosh sahifa',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Kurslar',
          ),
          NavigationDestination(
            icon: Icon(Icons.code_rounded),
            selectedIcon: Icon(Icons.code_rounded),
            label: 'Amaliyot',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _DashboardScreen extends ConsumerWidget {
  const _DashboardScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Xush kelibsiz! 👋',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bugun yangi bilim va ko‘nikmalarni egallash uchun ajoyib kun.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
          ),
          const SizedBox(height: 22),
          const _SummaryCard(),
          const SizedBox(height: 26),
          const Text(
            'O‘rganishni davom ettiring',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          const _RecommendedCourses(),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                colors: [Color(0xFF5146D8), Color(0xFF27245D)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome_rounded, size: 30),
                const SizedBox(height: 12),
                const Text(
                  'AI Mentor',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tushunmagan mavzuingizni sodda misollar bilan o‘rganing.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                ),
                const SizedBox(height: 14),
                FilledButton.tonalIcon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AIChatScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                  label: const Text('Mentor bilan suhbat'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends ConsumerWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(myProgressProvider);
    final completedLessons = progressState.when(
      data: (summary) => summary.completedLessonCount.toString(),
      loading: () => '…',
      error: (error, stackTrace) => '—',
    );
    final completedCourses = progressState.when(
      data: (summary) => summary.completedCourseCount.toString(),
      loading: () => '…',
      error: (error, stackTrace) => '—',
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF151C30),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF26314A)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Metric(
              icon: Icons.menu_book_rounded,
              value: completedLessons,
              label: 'Tugallangan dars',
              color: const Color(0xFF72D6B2),
            ),
          ),
          Expanded(
            child: _Metric(
              icon: Icons.school_rounded,
              value: completedCourses,
              label: 'Tugallangan kurs',
              color: const Color(0xFFFFD166),
            ),
          ),
          const Expanded(
            child: _Metric(
              icon: Icons.local_fire_department_rounded,
              value: '—',
              label: 'Streak',
              color: Color(0xFFFFA45B),
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }
}

class _RecommendedCourses extends ConsumerWidget {
  const _RecommendedCourses();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesState = ref.watch(coursesProvider);

    return coursesState.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Card(
        child: ListTile(
          leading: const Icon(Icons.cloud_off_rounded, color: Colors.white60),
          title: const Text(
            'Kurslarni yuklab bo‘lmadi',
            style: TextStyle(color: Colors.white),
          ),
          subtitle: const Text(
            'Internet va server aloqasini tekshiring.',
            style: TextStyle(color: Colors.white60),
          ),
          trailing: IconButton(
            onPressed: () => ref.invalidate(coursesProvider),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ),
      ),
      data: (courses) {
        if (courses.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'Hozircha kurslar mavjud emas.',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          );
        }

        final recommended = courses.take(2).toList(growable: false);
        return Column(
          children: recommended
              .map(
                (course) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _RecommendedCourseCard(course: course),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _RecommendedCourseCard extends StatelessWidget {
  const _RecommendedCourseCard({required this.course});

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

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => CourseDetailScreen(course: course),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF695CFF).withValues(alpha: 0.18),
                child: Icon(icon, color: const Color(0xFFA69EFF)),
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
                      '${course.levelLabel} • ${course.lessonsCount} dars',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }
}
