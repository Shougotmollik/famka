import 'package:famka/models/badge_model.dart';
import 'package:famka/view/statistics/widgets/badges_section_widget.dart';
import 'package:famka/view/statistics/widgets/statistics_info_card.dart';
import 'package:famka/view/statistics/widgets/weekly_focus_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

  static final List<BadgeModel> _badges = const [
    BadgeModel(
      id: 'first_step',
      title: 'The first step',
      iconAsset: 'assets/icons/play_badge.svg',
      badgeColor: Color(0xFF2E7D52),
      isUnlocked: true,
    ),
    BadgeModel(
      id: 'level_complete',
      title: 'Level complete',
      iconAsset: 'assets/icons/fire.svg',
      badgeColor: Color(0xFFB8651A),
      isUnlocked: true,
    ),
    BadgeModel(
      id: 'back_after_break',
      title: 'Back after the break',
      iconAsset: 'assets/icons/reconnect_badge.svg',
      badgeColor: Color(0xFF_2A2F3E),
      isUnlocked: false,
    ),
    BadgeModel(
      id: 'listened_audios',
      title: 'Listened audios',
      iconAsset: 'assets/icons/headphone_badge.svg',
      badgeColor: Color(0xFF7B2FC4),
      isUnlocked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Statistics",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Row(
              spacing: 12.w,
              children: [
                StatisticsInfoCard(
                  assetPath: "assets/icons/fire.svg",
                  title: "Series of days",
                  value: "05",
                ),
                StatisticsInfoCard(
                  assetPath: "assets/icons/filled_check.svg",
                  title: "Stories completed",
                  value: "12",
                ),
              ],
            ),
            SizedBox(height: 20.h),
            WeeklyFocusChart(
              weekData: const [2, 0, 5, 3, 7, 0, 4],
              todayIndex: 6,
            ),
            SizedBox(height: 20.h),
            BadgesSectionWidget(
              badges: _badges,
              onBadgeTap: (badge) {
                if (!badge.isUnlocked) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(badge.title),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
