class QuestionOption {
  final String text;
  final String category;

  QuestionOption({required this.text, required this.category});
}

class Question {
  final String id;
  final String text;
  final String? category; // R, I, A, S, E, C (for static)
  final String emoji;
  final List<QuestionOption>? options; // For dynamic MC

  Question({
    required this.id,
    required this.text,
    this.category,
    required this.emoji,
    this.options,
  });
}
