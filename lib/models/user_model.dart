class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? avatar;
  final String? bio;
  final String? website;
  final String role;
  final bool isVerified;
  final bool pushNotification;
  final bool dailyReminder;
  final String? reminderTime;
  final String createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatar,
    this.bio,
    this.website,
    required this.role,
    required this.isVerified,
    required this.pushNotification,
    required this.dailyReminder,
    this.reminderTime,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatar: json['avatar_url'] ?? json['avatar'],
      bio: json['bio'] as String?,
      website: json['website'] as String?,
      role: json['role'] as String? ?? 'USER',
      isVerified: json['is_verified'] as bool? ?? false,
      pushNotification: json['push_notification'] as bool? ?? true,
      dailyReminder: json['daily_reminder'] as bool? ?? false,
      reminderTime: json['reminder_time'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
