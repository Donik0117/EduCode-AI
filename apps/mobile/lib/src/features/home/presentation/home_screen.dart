import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.code_rounded, color: Color(0xFF9B91FF)),
            SizedBox(width: 10),
            Text(
              'EduCode AI',
              style: TextStyle(fontWeight: FontWeight.w800),
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
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
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.65),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            _LearningSummaryCard(),
            const SizedBox(height: 28),
            const _SectionTitle(title: 'O‘rganishni davom ettiring'),
            const SizedBox(height: 14),
            const _CourseCard(
              icon: Icons.terminal_rounded,
              title: 'Python dasturlash',
              subtitle: 'Dasturlash asoslari • Beginner',
              progress: 0.32,
              progressLabel: '32% yakunlandi',
            ),
            const SizedBox(height: 12),
            const _CourseCard(
              icon: Icons.phone_android_rounded,
              title: 'Flutter UI asoslari',
              subtitle: 'Mobil dasturlash • Beginner',
              progress: 0.12,
              progressLabel: '12% yakunlandi',
            ),
            const SizedBox(height: 28),
            const _SectionTitle(title: 'AI Mentor'),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [Color(0xFF5146D8), Color(0xFF27245D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.auto_awesome_rounded, size: 30),
                  const SizedBox(height: 14),
                  const Text(
                    'Tushunmagan mavzuingiz bormi?',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'AI Mentor sizga kodni sodda misollar bilan tushuntiradi.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonalIcon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline_rounded),
                    label: const Text('Mentor bilan suhbat'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Bosh sahifa',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Kurslar',
          ),
          NavigationDestination(
            icon: Icon(Icons.code_rounded),
            label: 'Amaliyot',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _LearningSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
              iconColor: Color(0xFFFFA45B),
            ),
          ),
          _MetricDivider(),
          Expanded(
            child: _Metric(
              icon: Icons.bolt_rounded,
              value: '0 XP',
              label: 'Tajriba',
              iconColor: Color(0xFFFFD166),
            ),
          ),
          _MetricDivider(),
          Expanded(
            child: _Metric(
              icon: Icons.track_changes_rounded,
              value: '0%',
              label: 'Progress',
              iconColor: Color(0xFF72D6B2),
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
    required this.iconColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 23),
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
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      color: const Color(0xFF2A3550),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 19,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.progressLabel,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final double progress;
  final String progressLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF695CFF).withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: const Color(0xFFA69EFF)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.55),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white54),
              ],
            ),
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                backgroundColor: const Color(0xFF303A52),
                color: const Color(0xFF8D82FF),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              progressLabel,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.55),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
