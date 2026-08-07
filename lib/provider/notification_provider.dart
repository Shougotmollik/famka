import 'package:famka/config/constants/api_constants.dart';
import 'package:famka/models/notification.dart';
import 'package:famka/services/custom_http.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_provider.g.dart';

@riverpod
class Notifications extends _$Notifications {
  @override
  FutureOr<NotificationResponseModel> build() {
    return const NotificationResponseModel();
  }

  // fetch notifications
  Future<void> fetchNotifications() async {
    state = const AsyncLoading();
    try {
      final response = await CustomHttp.get(
        endpoint: ApiConstants.notifications,
      );

      if (response.ok && response.data is Map<String, dynamic>) {
        state = AsyncData(
          NotificationResponseModel.fromJson(
            response.data as Map<String, dynamic>,
          ),
        );
      } else {
        throw Exception(response.error ?? 'Something went wrong');
      }
    } catch (e, stackTrace) {
      state = AsyncError(e, stackTrace);
    }
  }

  // read single notification
  Future<void> readNotification(String id) async {
    final current = state.value;
    final target = current?.items.where((n) => n.id == id).firstOrNull;
    if (target == null || target.isRead) return;

    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.readNotification,
        body: {'notification_id': id},
      );

      if (!response.ok) {
        return;
      }

      NotificationModel? updated;
      final data = response.data?['data'];
      if (data is Map<String, dynamic>) {
        updated = NotificationModel.fromJson(data);
      } else if (response.data is Map<String, dynamic>) {
        final body = response.data as Map<String, dynamic>;
        if (body['id'] != null || body['is_read'] != null) {
          updated = NotificationModel.fromJson(body);
        }
      }

      final latest = state.value;
      if (latest != null) {
        final updatedItems = latest.items.map((n) {
          if (n.id != id) return n;
          if (updated != null && updated.isRead) return updated;
          return n.copyWith(isRead: true);
        }).toList();

        final meta = latest.meta;
        final newMeta = meta.unreadCount <= 0
            ? meta
            : meta.copyWith(unreadCount: meta.unreadCount - 1);

        state = AsyncData(
          NotificationResponseModel(items: updatedItems, meta: newMeta),
        );
      }
    } catch (e) {
      debugPrint('Failed to mark notification $id as read: $e');
    }
  }

  // mark all notifications as read
  Future<void> markAllAsRead() async {
    // Nothing to do when there are no unread items.
    final current = state.value;
    if (current == null || current.items.every((n) => n.isRead)) return;

    try {
      final response = await CustomHttp.post(
        endpoint: ApiConstants.allNotification,
      );

      if (!response.ok) {
        // CustomHttp already shows a floating snackbar on error;
        // keep the current list intact.
        return;
      }

      final latest = state.value;
      if (latest != null) {
        final updatedItems = latest.items
            .map((n) => n.isRead ? n : n.copyWith(isRead: true))
            .toList();

        state = AsyncData(
          NotificationResponseModel(
            items: updatedItems,
            meta: latest.meta.copyWith(unreadCount: 0),
          ),
        );
      }
    } catch (e) {
      // Keep the list intact — the error was already surfaced by CustomHttp.
      debugPrint('Failed to mark all notifications as read: $e');
    }
  }
}
