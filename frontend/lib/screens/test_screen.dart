import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state.dart';
import 'result_screen.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key, this.categoryId});

  final int? categoryId;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().loadTest(categoryId: widget.categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final theme = Theme.of(context);

    if (state.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Test')),
        body: const Center(child: Text('Savollar topilmadi')),
      );
    }

    final question = state.questions[currentIndex];

    final progress = (currentIndex + 1) / state.questions.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Aralash test')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFE8DA), Color(0xFFFFF8F2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Savol ${currentIndex + 1}/${state.questions.length}',
                          style: const TextStyle(
                            color: Color(0xFF9B2226),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${(progress * 100).round()}%',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF6A3123),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: progress,
                      backgroundColor: Colors.white,
                      valueColor:
                          const AlwaysStoppedAnimation(Color(0xFFE76F51)),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    question.text,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      color: const Color(0xFF2D221D),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  ...question.answers.map(
                    (answer) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _AnswerTile(
                        text: answer.text,
                        selected:
                            state.selectedAnswers[question.id] == answer.id,
                        onTap: () => state.pickAnswer(question.id, answer.id),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final isLast = currentIndex == state.questions.length - 1;
                  if (!isLast) {
                    setState(() => currentIndex += 1);
                    return;
                  }
                  final navigator = Navigator.of(context);
                  final score = await state.submit();
                  if (!mounted) {
                    return;
                  }
                  navigator.pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => ResultScreen(
                        score: score,
                        total: state.questions.length,
                      ),
                    ),
                  );
                },
                child: Text(currentIndex == state.questions.length - 1
                    ? 'Testni yakunlash'
                    : 'Keyingi savol'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerTile extends StatelessWidget {
  const _AnswerTile({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFFFFE5DB)
                : Colors.white.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color:
                  selected ? const Color(0xFFE76F51) : const Color(0xFFEBD8CD),
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      selected ? const Color(0xFF9B2226) : Colors.transparent,
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF9B2226)
                        : const Color(0xFFC6AFA2),
                    width: 2,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.circle, size: 10, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.45,
                    color: Color(0xFF2D221D),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
