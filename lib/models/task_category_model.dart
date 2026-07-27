import 'task_item_model.dart';

class TaskCategoryModel {
  final String title;
  final String subtitle;
  final int totalTasks;
  final int completedTasks;
  final bool isPurple;
  final String? textIcon;
  final List<TaskItemModel> tasks;

  TaskCategoryModel({
    required this.title,
    required this.subtitle,
    required this.totalTasks,
    required this.completedTasks,
    this.isPurple = false,
    this.textIcon,
    required this.tasks,
  });

  TaskIconType get iconType {
    if (completedTasks >= totalTasks && totalTasks > 0) {
      return TaskIconType.completed;
    }
    if (completedTasks > 0) return TaskIconType.inProgress;
    return TaskIconType.locked;
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'total_tasks': totalTasks,
        'completed_tasks': completedTasks,
        'is_purple': isPurple,
        'text_icon': textIcon,
        'tasks': tasks.map((t) => t.toJson()).toList(),
      };

  factory TaskCategoryModel.fromJson(Map<String, dynamic> json) {
    return TaskCategoryModel(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      totalTasks: json['total_tasks'] as int,
      completedTasks: json['completed_tasks'] as int,
      isPurple: json['is_purple'] as bool? ?? false,
      textIcon: json['text_icon'] as String?,
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map(
                  (t) => TaskItemModel.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
