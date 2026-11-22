import 'package:flutter/material.dart';

import '../../courses/presentation/courses_screen.dart';
import '../../practice/presentation/practice_screen.dart';
import '../../profile/presentation/profile_screen.dart';

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

class _DashboardScreen extends StatelessWidget {
  const _DashboardScreen();

  @override
  Widget build(BuildContext context) {
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
            style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          const _ProgressCourse(
            icon: Icons.terminal_rounded,
            title: 'Python dasturlash',
            subtitle: 'Dasturlash asoslari • Beginner',
            progress: 0.32,
          ),
          const SizedBox(height: 12),
          const _ProgressCourse(
            icon: Icons.phone_android_rounded,
            title: 'Flutter UI asoslari',
            subtitle: 'Mobil dasturlash • Beginner',
            progress: 0.12,
          ),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('AI Mentor keyingi bosqichda ulanadi.'),
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF151C30),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF26314A)),
      ),
      child: const Row(
        children: [
          Expanded(
            child: _Metric(
              icon: Icons.local_fire_department_rounded,
              value: '0 kun',
              label: 'Streak',
              color: Color(0xFFFFA45B),
            ),
          ),
          Expanded(
            child: _Metric(
              icon: Icons.bolt_rounded,
              value: '0 XP',
              label: 'Tajriba',
              color: Color(0xFFFFD166),
            ),
          ),
          Expanded(
            child: _Metric(
              icon: Icons.track_changes_rounded,
              value: '0%',
              label: 'Progress',
              color: Color(0xFF72D6B2),
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
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        const SizedBox(height: 3),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }
}

class _ProgressCourse extends StatelessWidget {
  const _ProgressCourse({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.progress,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFFA69EFF), size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: const Color(0xFF303A52),
              color: const Color(0xFF8D82FF),
            ),
            const SizedBox(height: 7),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                (progress * 100).round().toString() + '% yakunlandi',
                style: const TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
