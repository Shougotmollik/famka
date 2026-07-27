class QuizOption {
  final String label;
  final String text;

  const QuizOption({required this.label, required this.text});
}

class QuizQuestion {
  final String question;
  final List<QuizOption> options;
  final String correctLabel;
  final String? explanation;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctLabel,
    this.explanation,
  });
}

class QuizModel {
  final String title;
  final List<QuizQuestion> questions;

  const QuizModel({required this.title, required this.questions});
}
