enum TaskIconType {
  completed,
  inProgress,
  locked;

  String get assetPath {
    switch (this) {
      case TaskIconType.completed:
        return 'assets/icons/tick.svg';
      case TaskIconType.inProgress:
        return 'assets/icons/ci_headphones.svg';
      case TaskIconType.locked:
        return 'assets/icons/Lock.svg';
    }
  }

  String toJson() => name;

  static TaskIconType fromJson(String json) {
    switch (json) {
      case 'completed':
        return TaskIconType.completed;
      case 'in_progress':
      case 'inProgress':
        return TaskIconType.inProgress;
      case 'locked':
        return TaskIconType.locked;
      default:
        return TaskIconType.locked;
    }
  }
}

class TaskItemModel {
  final String title;
  final String subtitle;
  final int progress;
  final int totalProgress;
  final bool isActive;
  final bool isNew;

  /// The story's id from the home model — used when navigating to the
  /// task details / session flow.
  final String storyId;

  /// Attempted state of each difficulty key ("EASY"/"MEDIUM"/"HARD"),
  /// sourced from the home model's story difficulties.
  final Map<String, bool> attemptedDifficulties;

  TaskItemModel({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.totalProgress,
    this.isActive = false,
    this.isNew = false,
    this.storyId = '',
    this.attemptedDifficulties = const {},
  });

  TaskIconType get iconType {
    if (progress >= totalProgress && totalProgress > 0) {
      return TaskIconType.completed;
    }
    // The home model has no "locked" concept — every story is available, so
    // un-attempted stories show the start (headphones) affordance instead.
    return TaskIconType.inProgress;
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'progress': progress,
        'total_progress': totalProgress,
        'is_active': isActive,
        'is_new': isNew,
        'story_id': storyId,
        'attempted_difficulties': attemptedDifficulties,
      };

  factory TaskItemModel.fromJson(Map<String, dynamic> json) {
    return TaskItemModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      progress: json['progress'] as int,
      totalProgress: json['total_progress'] as int,
      isActive: json['is_active'] as bool? ?? false,
      isNew: json['is_new'] as bool? ?? false,
      storyId: json['story_id'] as String? ?? '',
      attemptedDifficulties:
          (json['attempted_difficulties'] as Map<String, dynamic>? ?? {})
              .map((key, value) => MapEntry(key, value as bool? ?? false)),
    );
  }
}
