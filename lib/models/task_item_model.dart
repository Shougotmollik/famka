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
}
