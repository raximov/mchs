import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.score, required this.total});

  final int score;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = total == 0 ? 0.0 : score / total;
    final percent = (ratio * 100).round();
    final summary = _summaryFor(percent);
    final palette = _paletteFor(percent);

    return Scaffold(
      appBar: AppBar(title: const Text('Natija')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                colors: palette,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: palette.first.withValues(alpha: 0.2),
                  blurRadius: 28,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 170,
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.78),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 132,
                        height: 132,
                        child: CircularProgressIndicator(
                          value: ratio.clamp(0, 1),
                          strokeWidth: 11,
                          backgroundColor: const Color(0xFFEADFD8),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(palette.first),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$percent%',
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2D221D),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$score / $total',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7A5C4E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  summary.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D221D),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  summary.body,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Color(0xFF4E3D35),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  title: 'To‘g‘ri javob',
                  value: '$score',
                  icon: Icons.verified_rounded,
                  accent: const Color(0xFF2D8C61),
                  tint: const Color(0xFFEAF7EF),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Qolganlari',
                  value: '${(total - score).clamp(0, total)}',
                  icon: Icons.refresh_rounded,
                  accent: const Color(0xFFB85C38),
                  tint: const Color(0xFFFFEFE7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFFE9DBCF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Keyingi qadam',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D221D),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  summary.tip,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.55,
                    color: Color(0xFF5A483F),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.replay_rounded),
            label: const Text('Testni qayta ishlash'),
          ),
        ],
      ),
    );
  }

  List<Color> _paletteFor(int percent) {
    if (percent >= 80) {
      return const [Color(0xFFD9F2E3), Color(0xFFF4FBF7)];
    }
    if (percent >= 50) {
      return const [Color(0xFFFFE6D6), Color(0xFFFFF7F1)];
    }
    return const [Color(0xFFFFDFDF), Color(0xFFFFF6F6)];
  }

  _ResultCopy _summaryFor(int percent) {
    if (percent >= 80) {
      return const _ResultCopy(
        title: 'Ajoyib natija',
        body:
            'Siz mavzularni yaxshi o‘zlashtirgansiz. Favqulodda vaziyatlarda to‘g‘ri qaror qilishga tayyorgarligingiz yuqori.',
        tip:
            'Endi darslarni yana bir ko‘zdan kechirib, ayniqsa checklist va media bloklarni takrorlab bilimni yanada mustahkamlang.',
      );
    }
    if (percent >= 50) {
      return const _ResultCopy(
        title: 'Yaxshi urinish',
        body:
            'Asosiy tushunchalar bor, lekin ayrim vaziyatlarda qaror qilish tezligini oshirish uchun yana mashq kerak.',
        tip:
            'Interaktiv lesson bloklaridagi video, audio va qadam-baqadam checklistlarni qayta ko‘rib chiqing, keyin testni yana ishlang.',
      );
    }
    return const _ResultCopy(
      title: 'Yana bir marta urinib ko‘ring',
      body:
          'Bu safar natija pastroq chiqdi, lekin bu qayta o‘rganish uchun yaxshi signal. Amaliy bloklar sizga yordam beradi.',
      tip:
          'Avval lessonlarni birma-bir ko‘rib chiqing, ayniqsa matnli bloklar va checklistlarni o‘qib chiqqach testga qayting.',
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
    required this.tint,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accent;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.84),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent),
          ),
          const SizedBox(height: 18),
          Text(
            value,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D221D),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6D5A4E),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCopy {
  const _ResultCopy({
    required this.title,
    required this.body,
    required this.tip,
  });

  final String title;
  final String body;
  final String tip;
}
