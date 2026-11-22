import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../quizzes/data/quiz_repository.dart';
import '../../quizzes/data/models/quiz.dart';
import '../../quizzes/presentation/quiz_taking_screen.dart';

class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizzesState = ref.watch(quizzesProvider);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          const Text(
            'Bilimingizni amaliyotda sinang',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Testlarni yeching, natijangizni ko‘ring va bilimlaringizni mustahkamlang.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.62)),
          ),
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
                      Text(
                        'Har bir savol — yangi tajriba',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Javoblaringiz tekshiriladi va har bir savol bo‘yicha izoh beriladi.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Mavjud testlar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          quizzesState.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stackTrace) => _QuizListError(
              onRetry: () => ref.invalidate(quizzesProvider),
            ),
            data: (quizzes) {
              if (quizzes.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      'Hozircha testlar mavjud emas.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              }
              return Column(
                children: quizzes
                    .map(
                      (quiz) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _QuizCard(quiz: quiz),
                      ),
                    )
                    .toList(growable: false),
              );
            },
          ),
          const SizedBox(height: 16),
          const _ComingSoonCard(),
        ],
      ),
    );
  }
}

class _QuizCard extends StatelessWidget {
  const _QuizCard({required this.quiz});

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => QuizTakingScreen(quiz: quiz),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF695CFF).withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: Color(0xFFA69EFF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quiz.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${quiz.questionsCount} savol • ${quiz.durationMinutes} daqiqa',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      quiz.description,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        height: 1.3,
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

class _QuizListError extends StatelessWidget {
  const _QuizListError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.cloud_off_rounded, color: Colors.white60),
        title: const Text(
          'Testlarni yuklab bo‘lmadi',
          style: TextStyle(color: Colors.white),
        ),
        subtitle: const Text(
          'Internet va backend serverini tekshiring.',
          style: TextStyle(color: Colors.white60),
        ),
        trailing: IconButton(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
        ),
      ),
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        leading: Icon(
          Icons.code_rounded,
          color: Color(0xFF72D6B2),
        ),
        title: Text(
          'Coding Lab',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          'Kod muharriri va avtomatik tekshiruvchi keyingi bosqichda ulanadi.',
          style: TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ),
    );
  }
}
