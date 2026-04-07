import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/lesson.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    final blocks = lesson.blocks;

    return Scaffold(
      appBar: AppBar(title: Text(lesson.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson.categoryName,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 12),
            Text(
              lesson.content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (blocks.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Interaktiv bloklar',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              ...blocks.map(_buildBlock),
            ],
          ],
        ),
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
          label: 'Video havola',
          tint: Colors.red.shade50,
        );
      case 'audio':
        return _MediaLinkBlock(
          block: block,
          icon: Icons.graphic_eq_rounded,
          label: 'Audio havola',
          tint: Colors.green.shade50,
        );
      case 'checklist':
        return _ChecklistBlock(block: block);
      default:
        return _TextBlock(block: block);
    }
  }
}

class _TextBlock extends StatelessWidget {
  const _TextBlock({required this.block});

  final LessonBlock block;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (block.title.isNotEmpty) ...[
              Text(block.title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
            ],
            Text(block.body),
          ],
        ),
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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (resolvedUrl.isNotEmpty)
            Image.network(
              resolvedUrl,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 220,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined, size: 40),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (block.title.isNotEmpty) ...[
                  Text(block.title, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                ],
                if (block.body.isNotEmpty) Text(block.body),
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
  final Color tint;

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

    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Havolani ochib bo‘lmadi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: tint,
      child: InkWell(
        onTap: block.resolvedMediaUrl.isNotEmpty ? () => _openUrl(context) : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      block.title.isNotEmpty ? block.title : label,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  if (block.resolvedMediaUrl.isNotEmpty) const Icon(Icons.open_in_new_rounded, size: 18),
                ],
              ),
              if (block.body.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(block.body),
              ],
              if (block.resolvedMediaUrl.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  block.resolvedMediaUrl,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue.shade800,
                        decoration: TextDecoration.underline,
                      ),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: () => _openUrl(context),
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: Text(label),
                ),
              ],
            ],
          ),
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

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (block.title.isNotEmpty) ...[
              Text(block.title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
            ],
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Icon(Icons.check_circle_outline, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
