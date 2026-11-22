import 'package:material_ui/material_ui.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 42,
              backgroundColor: Color(0xFF292554),
              child: Icon(Icons.person_rounded, size: 42, color: Color(0xFFB1A9FF)),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Yangi o‘quvchi',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            'Hisob yaratilgach profilingizni to‘ldiring',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 28),
          const _StatsCard(),
          const SizedBox(height: 24),
          const Text('Hisob sozlamalari', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
          const SizedBox(height: 10),
          const _ProfileOption(icon: Icons.person_outline_rounded, title: 'Shaxsiy ma’lumotlar'),
          const _ProfileOption(icon: Icons.emoji_events_outlined, title: 'Yutuqlar va sertifikatlar'),
          const _ProfileOption(icon: Icons.notifications_none_rounded, title: 'Bildirishnomalar'),
          const _ProfileOption(icon: Icons.language_rounded, title: 'Ilova tili', value: 'O‘zbekcha'),
          const _ProfileOption(icon: Icons.dark_mode_outlined, title: 'Ko‘rinish', value: 'Dark'),
          const _ProfileOption(icon: Icons.help_outline_rounded, title: 'Yordam va qo‘llab-quvvatlash'),
          const SizedBox(height: 18),
          const Text('EduCode AI • 0.1.0', textAlign: TextAlign.center, style: TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF151C30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF26314A)),
      ),
      child: const Row(
        children: [
          Expanded(child: _Stat(value: '0', label: 'Kurs')),
          Expanded(child: _Stat(value: '0 XP', label: 'Tajriba')),
          Expanded(child: _Stat(value: '0', label: 'Yutuq')),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      ],
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({required this.icon, required this.title, this.value});

  final IconData icon;
  final String title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFA69EFF)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: value == null
            ? const Icon(Icons.chevron_right_rounded, color: Colors.white54)
            : Text(value!, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        onTap: () {},
      ),
    );
  }
}
