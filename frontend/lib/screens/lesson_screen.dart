import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/lesson.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final blocks = lesson.blocks;
    final accents = _accentFor(lesson.categoryName);

    return Scaffold(
      appBar: AppBar(title: const Text('Dars tafsiloti')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                colors: accents,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: accents.first.withValues(alpha: 0.18),
                  blurRadius: 28,
                  offset: const Offset(0, 16),
                ),
              ],
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
                        color: Colors.white.withValues(alpha: 0.82),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        lesson.categoryName,
                        style: const TextStyle(
                          color: Color(0xFF7A1F1F),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const Spacer(),
                    _MetricPill(
                      icon: Icons.widgets_outlined,
                      label: '${blocks.length} blok',
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  lesson.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    color: const Color(0xFF2D221D),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  lesson.content,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.65,
                    color: const Color(0xFF4E3D35),
                  ),
                ),
              ],
            ),
          ),
          if (blocks.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Interaktiv bloklar',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF2D221D),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFE7D7CB)),
                  ),
                  child: const Text(
                    'Media + amaliy',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7A5C4E),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Mavzuni matn, rasm, video, audio va checklist bloklari orqali bosqichma-bosqich o‘rganing.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6E5A50),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            ...blocks.map(_buildBlock),
          ],
        ],
      ),
    );
  }

  Widget _buildBlock(LessonBlock block) {
    switch (block.blockType) {
      case 'image':
        return _ImageBlock(block: block);
      case 'video':
        return _MediaLinkBlock(
          block: block,
          icon: Icons.play_circle_fill_rounded,
          label: 'Video havolani ochish',
          tint: const [Color(0xFFFFE2DA), Color(0xFFFFF7F4)],
        );
      case 'audio':
        return _MediaLinkBlock(
          block: block,
          icon: Icons.graphic_eq_rounded,
          label: 'Audio havolani ochish',
          tint: const [Color(0xFFE1F3E7), Color(0xFFF6FCF7)],
        );
      case 'checklist':
        return _ChecklistBlock(block: block);
      default:
        return _TextBlock(block: block);
    }
  }

  List<Color> _accentFor(String category) {
    switch (category.toLowerCase()) {
      case "yong'in":
        return const [Color(0xFFFFE2D6), Color(0xFFFFF7F1)];
      case 'zilzila':
        return const [Color(0xFFF3E5D8), Color(0xFFFFF7EF)];
      case 'suv toshqini':
        return const [Color(0xFFDDF2F8), Color(0xFFF4FBFD)];
      case 'elektr xavfi':
        return const [Color(0xFFFFF0C6), Color(0xFFFFF9E7)];
      case 'birinchi yordam':
        return const [Color(0xFFFFE0E0), Color(0xFFFFF6F6)];
      default:
        return const [Color(0xFFE2F0DF), Color(0xFFF6FBF5)];
    }
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
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
              color: Color(0xFF513B33),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.gradient,
  });

  final Widget child;
  final EdgeInsets padding;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: gradient == null ? Colors.white.withValues(alpha: 0.86) : null,
          gradient: gradient,
          border: Border.all(color: const Color(0xFFEADCD1)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5C4033).withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _BlockHeader extends StatelessWidget {
  const _BlockHeader({
    required this.icon,
    required this.title,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF9B2226)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2D221D),
                ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _TextBlock extends StatelessWidget {
  const _TextBlock({required this.block});

  final LessonBlock block;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      gradient: const LinearGradient(
        colors: [Color(0xFFFFF2EA), Color(0xFFFFFFFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BlockHeader(
            icon: Icons.article_outlined,
            title: block.title.isNotEmpty ? block.title : 'Matnli blok',
          ),
          if (block.body.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              block.body,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: const Color(0xFF4E3D35),
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ImageBlock extends StatelessWidget {
  const _ImageBlock({required this.block});

  final LessonBlock block;

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = block.resolvedMediaUrl;

    return _SectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (resolvedUrl.isNotEmpty)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(26)),
              child: Image.network(
                resolvedUrl,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: const Color(0xFFF1E3DA),
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image_outlined, size: 42),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BlockHeader(
                  icon: Icons.image_outlined,
                  title: block.title.isNotEmpty ? block.title : 'Rasmli blok',
                ),
                if (block.body.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    block.body,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: const Color(0xFF4E3D35),
                        ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaLinkBlock extends StatelessWidget {
  const _MediaLinkBlock({
    required this.block,
    required this.icon,
    required this.label,
    required this.tint,
  });

  final LessonBlock block;
  final IconData icon;
  final String label;
  final List<Color> tint;

  Future<void> _openUrl(BuildContext context) async {
    final raw = block.resolvedMediaUrl.trim();
    if (raw.isEmpty) {
      return;
    }

    final uri = Uri.tryParse(raw);
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Havola noto‘g‘ri formatda.')),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Havolani ochib bo‘lmadi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      gradient: LinearGradient(
        colors: tint,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: InkWell(
        onTap:
            block.resolvedMediaUrl.isNotEmpty ? () => _openUrl(context) : null,
        borderRadius: BorderRadius.circular(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BlockHeader(
              icon: icon,
              title: block.title.isNotEmpty ? block.title : label,
              trailing: block.resolvedMediaUrl.isNotEmpty
                  ? const Icon(Icons.open_in_new_rounded,
                      size: 18, color: Color(0xFF7A1F1F))
                  : null,
            ),
            if (block.body.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                block.body,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: const Color(0xFF4E3D35),
                    ),
              ),
            ],
            if (block.resolvedMediaUrl.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  block.resolvedMediaUrl,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF245E91),
                        decoration: TextDecoration.underline,
                      ),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => _openUrl(context),
                icon: const Icon(Icons.open_in_new_rounded),
                label: Text(label),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChecklistBlock extends StatelessWidget {
  const _ChecklistBlock({required this.block});

  final LessonBlock block;

  @override
  Widget build(BuildContext context) {
    final items = block.body
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    return _SectionCard(
      gradient: const LinearGradient(
        colors: [Color(0xFFEFF7E8), Color(0xFFFFFFFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BlockHeader(
            icon: Icons.checklist_rounded,
            title: block.title.isNotEmpty ? block.title : 'Checklist',
          ),
          const SizedBox(height: 14),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D8C61).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: Color(0xFF2D8C61),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.5,
                            color: const Color(0xFF35443A),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
