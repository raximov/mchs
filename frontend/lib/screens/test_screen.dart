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

    return Scaffold(
      appBar: AppBar(title: Text('Savol ${currentIndex + 1}/${state.questions.length}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.text, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...question.answers.map(
              (answer) => RadioListTile<int>(
                value: answer.id,
                groupValue: state.selectedAnswers[question.id],
                onChanged: (value) {
                  if (value != null) {
                    state.pickAnswer(question.id, value);
                  }
                },
                title: Text(answer.text),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final isLast = currentIndex == state.questions.length - 1;
                  if (!isLast) {
                    setState(() => currentIndex += 1);
                    return;
                  }
                  final score = await state.submit();
                  if (!mounted) {
                    return;
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResultScreen(
                        score: score,
                        total: state.questions.length,
                      ),
                    ),
                  );
                },
                child: Text(currentIndex == state.questions.length - 1 ? 'Yakunlash' : 'Keyingi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
