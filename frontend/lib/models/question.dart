class AnswerOption {
  final int id;
  final String text;

  const AnswerOption({required this.id, required this.text});

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(id: json['id'] as int, text: json['text'] as String);
  }
}

class Question {
  final int id;
  final int categoryId;
  final String text;
  final List<AnswerOption> answers;

  const Question({
    required this.id,
    required this.categoryId,
    required this.text,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final items = json['answers'] as List<dynamic>;
    return Question(
      id: json['id'] as int,
      categoryId: json['category'] as int,
      text: json['text'] as String,
      answers: items.map((e) => AnswerOption.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
