import 'package:famka/models/notification.dart';
import 'package:famka/provider/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(notificationsProvider.notifier).fetchNotifications();
      }
    });
  }

  void _retry() {
    ref.read(notificationsProvider.notifier).fetchNotifications();
  }

  Future<void> _refresh() {
    return ref.read(notificationsProvider.notifier).fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: notificationsAsync.when(
        skipLoadingOnRefresh: true,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(onRetry: _retry),
        data: (response) => _buildContent(response),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1A1E25),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64.w,
      leading: Center(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xFF1F242B),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF3A4150)),
            ),
            child: Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 22.r,
            ),
          ),
        ),
      ),
      title: Text(
        'Notifications',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildContent(NotificationResponseModel response) {
    final items = response.items;

    if (items.isEmpty) {
      return _EmptyView(onRefresh: _refresh);
    }

    final newItems = items.where((n) => !n.isRead).toList();
    final earlierItems = items.where((n) => n.isRead).toList();

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        children: [
          if (newItems.isNotEmpty) ...[
            _buildSectionLabel('New'),
            SizedBox(height: 12.h),
            _buildNotificationList(newItems),
            SizedBox(height: 24.h),
          ],
          if (earlierItems.isNotEmpty) ...[
            _buildSectionLabel('Earlier'),
            SizedBox(height: 12.h),
            _buildNotificationList(earlierItems),
          ],
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFFD4A017),
      ),
    );
  }

  Widget _buildNotificationList(List<NotificationModel> items) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _NotificationTile(
                item: item,
                onTap: item.isRead ? null : () => _markAsRead(item),
              ),
            ),
          )
          .toList(),
    );
  }

  void _markAsRead(NotificationModel item) {
    ref.read(notificationsProvider.notifier).readNotification(item.id);
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item, this.onTap});
  final NotificationModel item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1F242B),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFF3A4150)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!item.isRead)
              Padding(
                padding: EdgeInsets.only(top: 6.h, right: 8.w),
                child: Container(
                  width: 7.r,
                  height: 7.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFF7B2FC4),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFB3B8C5),
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: '${item.title} ',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(text: item.message),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              " ${_formatRelativeTime(item.createdAt)} ago",
              style: TextStyle(
                fontSize: 11.sp,
                color: const Color(0xFF8B8E95),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.notifications_off_outlined,
            size: 48,
            color: Colors.white38,
          ),
          SizedBox(height: 12.h),
          Text(
            "Couldn't load notifications",
            style: TextStyle(fontSize: 16.sp, color: Colors.white70),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 120.h),
          Icon(
            Icons.notifications_none_rounded,
            size: 56.r,
            color: const Color(0xFF8B8E95),
          ),
          SizedBox(height: 16.h),
          Text(
            'No notifications yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              'When something happens you will find it here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF8B8E95)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Formats an ISO-8601 timestamp (e.g. 2026-08-04T11:02:44.527019Z)
/// into a compact relative time like "2m", "3h" or "1d".
String _formatRelativeTime(String isoTime) {
  final dateTime = DateTime.tryParse(isoTime)?.toLocal();
  if (dateTime == null) return '';

  final diff = DateTime.now().difference(dateTime);

  if (diff.inMinutes < 1) return 'now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  if (diff.inDays < 7) return '${diff.inDays}d';

  final month = dateTime.month.toString().padLeft(2, '0');
  final day = dateTime.day.toString().padLeft(2, '0');
  return '$day/$month/${dateTime.year}';
}
