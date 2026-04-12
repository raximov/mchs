import 'package:flutter/material.dart';

import '../models/lesson.dart';

class LessonCard extends StatelessWidget {
  const LessonCard({super.key, required this.lesson, required this.onTap});

  final Lesson lesson;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blockCount = lesson.blocks.length;
    final accents = _accentFor(lesson.categoryName);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: accents,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: accents.last.withOpacity(0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.72),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(_iconFor(lesson.categoryName), color: const Color(0xFF7A1F1F)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.categoryName,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: const Color(0xFF7A1F1F),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          lesson.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF2D221D),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _InfoChip(
                              icon: Icons.widgets_outlined,
                              label: '$blockCount blok',
                            ),
                            _InfoChip(
                              icon: Icons.menu_book_rounded,
                              label: 'Interaktiv dars',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.82),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.arrow_forward_rounded, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _accentFor(String category) {
    switch (category.toLowerCase()) {
      case "yong'in":
        return const [Color(0xFFFFE3D7), Color(0xFFFFF5EF)];
      case 'zilzila':
        return const [Color(0xFFF2E4D7), Color(0xFFFFF6EE)];
      case 'suv toshqini':
        return const [Color(0xFFDDF1F8), Color(0xFFF4FBFD)];
      case 'elektr xavfi':
        return const [Color(0xFFFFF0BF), Color(0xFFFFF8E4)];
      case 'birinchi yordam':
        return const [Color(0xFFFFE1E1), Color(0xFFFFF5F5)];
      default:
        return const [Color(0xFFE1F0DE), Color(0xFFF5FBF3)];
    }
  }

  IconData _iconFor(String category) {
    switch (category.toLowerCase()) {
      case "yong'in":
        return Icons.local_fire_department_rounded;
      case 'zilzila':
        return Icons.vibration_rounded;
      case 'suv toshqini':
        return Icons.water_drop_rounded;
      case 'elektr xavfi':
        return Icons.bolt_rounded;
      case 'birinchi yordam':
        return Icons.medical_services_rounded;
      default:
        return Icons.wb_sunny_outlined;
    }
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF7A1F1F)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF513B33),
            ),
          ),
        ],
      ),
    );
  }
}
