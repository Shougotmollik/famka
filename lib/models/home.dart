class HomeModel {
  final WeekProgressModel weekProgress;
  final List<LevelModel> levels;

  const HomeModel({
    this.weekProgress = const WeekProgressModel(),
    this.levels = const [],
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      weekProgress: WeekProgressModel.fromJson(
        json['week_progress'] as Map<String, dynamic>? ?? {},
      ),
      levels: (json['levels'] as List<dynamic>? ?? [])
          .map((e) => LevelModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WeekProgressModel {
  final int completedDays;
  final int totalDays;
  final List<WeekDayModel> days;

  const WeekProgressModel({
    this.completedDays = 0,
    this.totalDays = 0,
    this.days = const [],
  });

  factory WeekProgressModel.fromJson(Map<String, dynamic> json) {
    return WeekProgressModel(
      completedDays: (json['completed_days'] as num?)?.toInt() ?? 0,
      totalDays: (json['total_days'] as num?)?.toInt() ?? 0,
      days: (json['days'] as List<dynamic>? ?? [])
          .map((e) => WeekDayModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WeekDayModel {
  final String day;
  final int date;
  final String fullDate;
  final bool isToday;
  final bool isCompleted;

  const WeekDayModel({
    this.day = '',
    this.date = 0,
    this.fullDate = '',
    this.isToday = false,
    this.isCompleted = false,
  });

  factory WeekDayModel.fromJson(Map<String, dynamic> json) {
    return WeekDayModel(
      day: json['day'] as String? ?? '',
      date: (json['date'] as num?)?.toInt() ?? 0,
      fullDate: json['full_date'] as String? ?? '',
      isToday: json['today'] as bool? ?? false,
      isCompleted: json['completed'] as bool? ?? false,
    );
  }
}

class LevelModel {
  final String levelId;
  final String levelName;
  final int totalStories;
  final int completedStories;
  final bool levelCompleted;
  final List<StoryModel> stories;

  const LevelModel({
    this.levelId = '',
    this.levelName = '',
    this.totalStories = 0,
    this.completedStories = 0,
    this.levelCompleted = false,
    this.stories = const [],
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      levelId: json['level_id'] as String? ?? '',
      levelName: json['level_name'] as String? ?? '',
      totalStories: (json['total_stories'] as num?)?.toInt() ?? 0,
      completedStories: (json['completed_stories'] as num?)?.toInt() ?? 0,
      levelCompleted: json['level_completed'] as bool? ?? false,
      stories: (json['stories'] as List<dynamic>? ?? [])
          .map((e) => StoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class StoryModel {
  final String storyId;
  final String storyName;
  final String about;
  final bool completed;
  final Map<String, DifficultyModel> difficulties;

  const StoryModel({
    this.storyId = '',
    this.storyName = '',
    this.about = '',
    this.completed = false,
    this.difficulties = const {},
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    final difficultiesJson =
        json['difficulties'] as Map<String, dynamic>? ?? {};
    return StoryModel(
      storyId: json['story_id'] as String? ?? '',
      storyName: json['story_name'] as String? ?? '',
      about: json['about'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      difficulties: difficultiesJson.map(
        (key, value) => MapEntry(
          key,
          DifficultyModel.fromJson(value as Map<String, dynamic>? ?? {}),
        ),
      ),
    );
  }
}

class DifficultyModel {
  final bool attempted;

  const DifficultyModel({this.attempted = false});

  factory DifficultyModel.fromJson(Map<String, dynamic> json) {
    return DifficultyModel(
      attempted: json['attempted'] as bool? ?? false,
    );
  }
}
