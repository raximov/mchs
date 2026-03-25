class Lesson {
  final int id;
  final int categoryId;
  final String categoryName;
  final String title;
  final String content;

  const Lesson({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.title,
    required this.content,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    final category = json['category'] as Map<String, dynamic>;
    return Lesson(
      id: json['id'] as int,
      categoryId: category['id'] as int,
      categoryName: category['name'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
}
