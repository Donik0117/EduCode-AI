import 'package:flutter/material.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  static const _tasks = [
    _Task('O‘zgaruvchilar bilan ishlash', 'Python', 'Oson', 20, Icons.data_object_rounded),
    _Task('Juft yoki toq son', 'Python', 'Oson', 30, Icons.numbers_rounded),
    _Task('Ro‘yxatdagi eng katta son', 'Dart', 'O‘rta', 50, Icons.format_list_numbered_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Kod yozish orqali o‘rganing',
            style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text('Bilimingizni amaliy topshiriqlar bilan mustahkamlang.', style: TextStyle(color: Colors.white60)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF151C30),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF26314A)),
            ),
            child: const Row(
              children: [
                Icon(Icons.bolt_rounded, color: Color(0xFFFFD166), size: 30),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Har kuni mashq qiling', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                      SizedBox(height: 4),
                      Text('Topshiriqlarni bajaring va XP to‘plang.', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Tavsiya etilgan topshiriqlar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          ..._tasks.map((task) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF695CFF).withValues(alpha: 0.18),
                    child: Icon(task.icon, color: const Color(0xFFA69EFF)),
                  ),
                  title: Text(task.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
                  subtitle: Text(task.language + ' • ' + task.difficulty, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                  trailing: Text('+' + task.xp.toString() + ' XP', style: const TextStyle(color: Color(0xFFFFD166), fontWeight: FontWeight.w700, fontSize: 12)),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kod muharriri keyingi bosqichda ulanadi.')),
                  ),
                ),
              )),
          const Text(
            'Topshiriqlar hozircha namuna. Kod muharriri va tekshiruvchi modul keyingi bosqichda ulanadi.',
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _Task {
  const _Task(this.title, this.language, this.difficulty, this.xp, this.icon);

  final String title;
  final String language;
  final String difficulty;
  final int xp;
  final IconData icon;
}
