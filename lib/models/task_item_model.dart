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

  TaskItemModel({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.totalProgress,
    this.isActive = false,
    this.isNew = false,
  });

  TaskIconType get iconType {
    if (progress >= totalProgress) return TaskIconType.completed;
    if (progress > 0) return TaskIconType.inProgress;
    return TaskIconType.locked;
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'progress': progress,
        'total_progress': totalProgress,
        'is_active': isActive,
        'is_new': isNew,
      };

  factory TaskItemModel.fromJson(Map<String, dynamic> json) {
    return TaskItemModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      progress: json['progress'] as int,
      totalProgress: json['total_progress'] as int,
      isActive: json['is_active'] as bool? ?? false,
      isNew: json['is_new'] as bool? ?? false,
    );
  }
}
