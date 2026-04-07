class LessonBlock {
  final int id;
  final int order;
  final String blockType;
  final String title;
  final String body;
  final String mediaUrl;

  const LessonBlock({
    required this.id,
    required this.order,
    required this.blockType,
    required this.title,
    required this.body,
    required this.mediaUrl,
  });

  factory LessonBlock.fromJson(Map<String, dynamic> json) {
    return LessonBlock(
      id: json['id'] as int,
      order: json['order'] as int,
      blockType: json['block_type'] as String,
      title: (json['title'] as String?) ?? '',
      body: (json['body'] as String?) ?? '',
      mediaUrl: (json['media_url'] as String?) ?? '',
    );
  }
}

class Lesson {
  final int id;
  final int categoryId;
  final String categoryName;
  final String title;
  final String content;
  final List<LessonBlock> blocks;

  const Lesson({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.title,
    required this.content,
    required this.blocks,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    final category = json['category'] as Map<String, dynamic>;
    final rawBlocks = (json['blocks'] as List<dynamic>?) ?? const [];
    return Lesson(
      id: json['id'] as int,
      categoryId: category['id'] as int,
      categoryName: category['name'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      blocks: rawBlocks
          .map((block) => LessonBlock.fromJson(block as Map<String, dynamic>))
          .toList(),
    );
  }
}
