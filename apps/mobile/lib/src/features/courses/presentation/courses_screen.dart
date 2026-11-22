import 'package:flutter/material.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _query = '';
  String _level = 'Barchasi';

  static const _courses = [
    _Course('Python dasturlash', 'Backend va algoritmlar', 'Beginner', 36, Icons.terminal_rounded, Color(0xFF6FA8FF)),
    _Course('Dart dasturlash', 'Mobil dasturlash', 'Beginner', 28, Icons.flutter_dash_rounded, Color(0xFF55B8E8)),
    _Course('Flutter', 'Mobil dasturlash', 'Intermediate', 42, Icons.phone_android_rounded, Color(0xFF72D6B2)),
    _Course('JavaScript', 'Web dasturlash', 'Beginner', 40, Icons.javascript_rounded, Color(0xFFFFD166)),
    _Course('SQL va ma’lumotlar bazasi', 'Database', 'Intermediate', 30, Icons.storage_rounded, Color(0xFFFFA45B)),
    _Course('C++ algoritmlar', 'Algoritmlar', 'Advanced', 34, Icons.account_tree_rounded, Color(0xFFB69CFF)),
  ];

  @override
  Widget build(BuildContext context) {
    final visibleCourses = _courses.where((course) {
      final matchesText = course.title.toLowerCase().contains(_query.toLowerCase()) ||
          course.category.toLowerCase().contains(_query.toLowerCase());
      final matchesLevel = _level == 'Barchasi' || course.level == _level;
      return matchesText && matchesLevel;
    }).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Bilimingizni keyingi bosqichga olib chiqing',
            style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text('Yo‘nalishingizni tanlang va o‘rganishni boshlang.', style: TextStyle(color: Colors.white60)),
          const SizedBox(height: 20),
          TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Kurs qidirish...',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: const Color(0xFF151C30),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            children: ['Barchasi', 'Beginner', 'Intermediate', 'Advanced']
                .map((level) => ChoiceChip(
                      label: Text(level),
                      selected: _level == level,
                      onSelected: (_) => setState(() => _level = level),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Barcha kurslar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              Text(visibleCourses.length.toString() + ' ta kurs', style: const TextStyle(color: Colors.white60, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          if (visibleCourses.isEmpty)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Center(child: Text('Mos kurs topilmadi.', style: TextStyle(color: Colors.white70))),
            )
          else
            ...visibleCourses.map((course) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CourseCard(course: course),
                )),
          const Text(
            'Kurslar hozircha namuna ma’lumotlari bilan ko‘rsatilgan.',
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _Course {
  const _Course(this.title, this.category, this.level, this.lessons, this.icon, this.color);

  final String title;
  final String category;
  final String level;
  final int lessons;
  final IconData icon;
  final Color color;
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course});

  final _Course course;

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
                CircleAvatar(
                  backgroundColor: course.color.withValues(alpha: 0.14),
                  child: Icon(course.icon, color: course.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(course.category, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white54),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              children: [
                _Pill(course.level),
                _Pill(course.lessons.toString() + ' dars'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: const Color(0xFF27314A), borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ),
    );
  }
}
