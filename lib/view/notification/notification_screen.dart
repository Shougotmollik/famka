import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            _buildSectionLabel('New'),
            SizedBox(height: 12.h),
            _buildNotificationList(_newNotifications),
            SizedBox(height: 24.h),
            _buildSectionLabel('Earlier'),
            SizedBox(height: 12.h),
            _buildNotificationList(_earlierNotifications),
          ],
        ),
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

  Widget _buildNotificationList(List<_NotificationItem> items) {
    return Column(
      children: items
          .map(
            (item) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _NotificationTile(item: item),
            ),
          )
          .toList(),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});
  final _NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF1F242B),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFF3A4150)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.isUnread)
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
                  TextSpan(text: item.body),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            item.time,
            style: TextStyle(fontSize: 11.sp, color: const Color(0xFF8B8E95)),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem {
  const _NotificationItem({
    required this.title,
    required this.body,
    required this.time,
    this.isUnread = false,
  });

  final String title;
  final String body;
  final String time;
  final bool isUnread;
}

const _newNotifications = [
  _NotificationItem(
    title: 'Morning Habits Podcast',
    body: 'a new story has been added to Level 2',
    time: '2m',
    isUnread: true,
  ),
  _NotificationItem(
    title: 'Morning Habits Podcast',
    body: 'a new story has been added to Level 2',
    time: '15m',
    isUnread: true,
  ),
];

const _earlierNotifications = [
  _NotificationItem(
    title: 'Morning Habits Podcast',
    body: 'a new story has been added to Level 2',
    time: '1d',
  ),
  _NotificationItem(
    title: 'Morning Habits Podcast',
    body: 'a new story has been added to Level 2',
    time: '2d',
  ),
];
