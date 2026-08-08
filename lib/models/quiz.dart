class QuizResponseModel {
  final List<QuizQuestionModel> questions;
  final QuizMetaModel meta;

  const QuizResponseModel({
    this.questions = const [],
    this.meta = const QuizMetaModel(),
  });

  factory QuizResponseModel.fromJson(Map<String, dynamic> json) {
    return QuizResponseModel(
      questions: (json['data'] as List<dynamic>? ?? [])
          .map((e) => QuizQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: QuizMetaModel.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class QuizQuestionModel {
  final String id;
  final String difficulty;
  final String questionText;
  final String explanation;
  final String audioId;
  final String audio;
  final List<QuizOptionModel> options;

  const QuizQuestionModel({
    this.id = '',
    this.difficulty = '',
    this.questionText = '',
    this.explanation = '',
    this.audioId = '',
    this.audio = '',
    this.options = const [],
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      questionText: json['question_text'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      audioId: json['audio_id'] as String? ?? '',
      audio: json['audio'] as String? ?? '',
      options: (json['options'] as List<dynamic>? ?? [])
          .map((e) => QuizOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class QuizOptionModel {
  final String optionKey;
  final String optionText;
  final bool isCorrect;

  const QuizOptionModel({
    this.optionKey = '',
    this.optionText = '',
    this.isCorrect = false,
  });

  factory QuizOptionModel.fromJson(Map<String, dynamic> json) {
    return QuizOptionModel(
      optionKey: json['option_key'] as String? ?? '',
      optionText: json['option_text'] as String? ?? '',
      isCorrect: json['is_correct'] as bool? ?? false,
    );
  }
}

class QuizMetaModel {
  final int count;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final String? next;
  final String? previous;

  const QuizMetaModel({
    this.count = 0,
    this.totalPages = 0,
    this.currentPage = 0,
    this.pageSize = 0,
    this.next,
    this.previous,
  });

  factory QuizMetaModel.fromJson(Map<String, dynamic> json) {
    return QuizMetaModel(
      count: (json['count'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      currentPage: (json['current_page'] as num?)?.toInt() ?? 0,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
    );
  }
}
