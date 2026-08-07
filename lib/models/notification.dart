class NotificationModel {
  final String id;
  final String notificationType;
  final String type;
  final String title;
  final String message;
  final bool isRead;
  final String? readAt;
  final String createdAt;

  const NotificationModel({
    this.id = '',
    this.notificationType = '',
    this.type = '',
    this.title = '',
    this.message = '',
    this.isRead = false,
    this.readAt,
    this.createdAt = '',
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String? ?? '',
      notificationType: json['notification_type'] as String? ?? '',
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      isRead: json['is_read'] as bool? ?? false,
      readAt: json['read_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  NotificationModel copyWith({
    String? id,
    String? notificationType,
    String? type,
    String? title,
    String? message,
    bool? isRead,
    String? readAt,
    String? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      notificationType: notificationType ?? this.notificationType,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class NotificationMetaModel {
  final int count;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final String? next;
  final String? previous;
  final int unreadCount;

  const NotificationMetaModel({
    this.count = 0,
    this.totalPages = 0,
    this.currentPage = 0,
    this.pageSize = 0,
    this.next,
    this.previous,
    this.unreadCount = 0,
  });

  factory NotificationMetaModel.fromJson(Map<String, dynamic> json) {
    return NotificationMetaModel(
      count: (json['count'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
      currentPage: (json['current_page'] as num?)?.toInt() ?? 0,
      pageSize: (json['page_size'] as num?)?.toInt() ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
    );
  }

  NotificationMetaModel copyWith({
    int? count,
    int? totalPages,
    int? currentPage,
    int? pageSize,
    String? next,
    String? previous,
    int? unreadCount,
  }) {
    return NotificationMetaModel(
      count: count ?? this.count,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      next: next ?? this.next,
      previous: previous ?? this.previous,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationResponseModel {
  final List<NotificationModel> items;
  final NotificationMetaModel meta;

  const NotificationResponseModel({
    this.items = const [],
    this.meta = const NotificationMetaModel(),
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      items: (json['data'] as List<dynamic>? ?? [])
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta:
          NotificationMetaModel.fromJson(json['meta'] as Map<String, dynamic>? ??
              {}),
    );
  }
}
