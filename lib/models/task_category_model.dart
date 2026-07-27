import 'task_item_model.dart';

class TaskCategoryModel {
  final String title;
  final String subtitle;
  final int totalTasks;
  final int completedTasks;
  final bool isPurple;
  final String? textIcon;
  final List<TaskItemModel> tasks;
  bool isExpanded;

  TaskCategoryModel({
    required this.title,
    required this.subtitle,
    required this.totalTasks,
    required this.completedTasks,
    this.isPurple = false,
    this.textIcon,
    required this.tasks,
    this.isExpanded = false,
  });

  TaskIconType get iconType {
    if (completedTasks >= totalTasks && totalTasks > 0) {
      return TaskIconType.completed;
    }
    if (completedTasks > 0) return TaskIconType.inProgress;
    return TaskIconType.locked;
  }
}
