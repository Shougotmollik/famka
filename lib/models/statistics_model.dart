class StatisticsModel {
  final int streak;
  final int storiesCompleted;
  final List<WeeklyActivityModel> weeklyActivity;
  final BadgesModel badges;

  const StatisticsModel({
    this.streak = 0,
    this.storiesCompleted = 0,
    this.weeklyActivity = const [],
    this.badges = const BadgesModel(),
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      storiesCompleted: (json['stories_completed'] as num?)?.toInt() ?? 0,
      weeklyActivity: (json['weekly_activity'] as List<dynamic>? ?? [])
          .map((e) => WeeklyActivityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      badges: BadgesModel.fromJson(json['badges'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class WeeklyActivityModel {
  final String day;
  final int count;

  const WeeklyActivityModel({this.day = '', this.count = 0});

  factory WeeklyActivityModel.fromJson(Map<String, dynamic> json) {
    return WeeklyActivityModel(
      day: json['day'] as String? ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
    );
  }
}

class BadgesModel {
  final int total;
  final int unlocked;
  final List<BadgeItemModel> items;

  const BadgesModel({this.total = 0, this.unlocked = 0, this.items = const []});

  factory BadgesModel.fromJson(Map<String, dynamic> json) {
    return BadgesModel(
      total: (json['total'] as num?)?.toInt() ?? 0,
      unlocked: (json['unlocked'] as num?)?.toInt() ?? 0,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => BadgeItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BadgeItemModel {
  final String title;
  final bool unlocked;

  const BadgeItemModel({this.title = '', this.unlocked = false});

  factory BadgeItemModel.fromJson(Map<String, dynamic> json) {
    return BadgeItemModel(
      title: json['title'] as String? ?? '',
      unlocked: json['unlocked'] as bool? ?? false,
    );
  }
}
