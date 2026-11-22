import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull;
    final displayName = user?.fullName?.isNotEmpty == true
        ? user!.fullName!
        : user?.email ?? 'O‘quvchi';

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 42,
              backgroundColor: const Color(0xFF292554),
              child: Text(
                displayName.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFB1A9FF),
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            displayName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? 'EduCode AI o‘quvchisi',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
          ),
          const SizedBox(height: 28),
          const _StatsCard(),
          const SizedBox(height: 24),
          const Text(
            'Hisob sozlamalari',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 10),
          const _ProfileOption(
            icon: Icons.person_outline_rounded,
            title: 'Shaxsiy ma’lumotlar',
          ),
          const _ProfileOption(
            icon: Icons.emoji_events_outlined,
            title: 'Yutuqlar va sertifikatlar',
          ),
          const _ProfileOption(
            icon: Icons.notifications_none_rounded,
            title: 'Bildirishnomalar',
          ),
          const _ProfileOption(
            icon: Icons.language_rounded,
            title: 'Ilova tili',
            value: 'O‘zbekcha',
          ),
          const _ProfileOption(
            icon: Icons.dark_mode_outlined,
            title: 'Ko‘rinish',
            value: 'Dark',
          ),
          const _ProfileOption(
            icon: Icons.help_outline_rounded,
            title: 'Yordam va qo‘llab-quvvatlash',
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () => _confirmSignOut(context, ref),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Hisobdan chiqish'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFFF9A9A),
              side: const BorderSide(color: Color(0xFF673D50)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'EduCode AI • 0.1.0',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hisobdan chiqish'),
        content: const Text('Haqiqatan ham hisobingizdan chiqmoqchimisiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Bekor qilish'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Chiqish'),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
      await ref.read(authControllerProvider.notifier).signOut();
    }
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
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.title,
    this.value,
  });

  final IconData icon;
  final String title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFA69EFF)),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        trailing: value == null
            ? const Icon(Icons.chevron_right_rounded, color: Colors.white54)
            : Text(
                value!,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
        onTap: () {},
      ),
    );
  }
}
