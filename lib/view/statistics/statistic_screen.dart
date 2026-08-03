import 'package:famka/config/theme/app_colors.dart';
import 'package:famka/models/badge_model.dart';
import 'package:famka/models/statistics_model.dart';
import 'package:famka/provider/statistics_provider.dart';
import 'package:famka/view/statistics/widgets/badges_section_widget.dart';
import 'package:famka/view/statistics/widgets/statistics_info_card.dart';
import 'package:famka/view/statistics/widgets/weekly_focus_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class StatisticScreen extends ConsumerStatefulWidget {
  const StatisticScreen({super.key});

  @override
  ConsumerState<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends ConsumerState<StatisticScreen> {
  /// 5x4 color matrix that rotates hue by ~+47° (blue → app purple).
  /// Neutral grays/whites stay put, so the animation keeps its shading.
  static const List<double> _blueToPurpleMatrix = [
    0.593954, -0.295547, 0.701592, 0, 0, //
    0.172318, 1.011759, -0.184077, 0, 0, //
    -0.507841, 0.750289, 0.757552, 0, 0, //
    0, 0, 0, 1, 0,
  ];

  static const Map<String, (String, Color)> _badgeStyles = {
    'The first step': ('assets/icons/play_badge.svg', Color(0xFF2E7D52)),
    'Level complete': ('assets/icons/fire.svg', Color(0xFFB8651A)),
    'Back after the break': (
      'assets/icons/reconnect_badge.svg',
      Color(0xFF2A2F3E),
    ),
    'Listened audios': ('assets/icons/headphone_badge.svg', Color(0xFF7B2FC4)),
    'Quiz master': ('assets/icons/spectra.svg', Color(0xFF5B5FEF)),
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(statisticsProvider.notifier).fetchStatistics();
    });
  }

  List<BadgeModel> _mapBadges(List<BadgeItemModel> items) {
    return items
        .map(
          (item) => BadgeModel(
            id: item.title,
            title: item.title,
            iconAsset:
                _badgeStyles[item.title]?.$1 ?? 'assets/icons/play_badge.svg',
            badgeColor: _badgeStyles[item.title]?.$2 ?? AppColors.primary,
            isUnlocked: item.unlocked,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(statisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Statistics",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: statsAsync.when(
        skipLoadingOnRefresh: true,
        loading: () => Center(
          // Runtime hue-rotation: shifts the animation's blue palette to
          // the app's purple primary so it matches the theme no matter
          // what colors the source JSON is exported with.
          child: ColorFiltered(
            colorFilter: const ColorFilter.matrix(_blueToPurpleMatrix),
            child: Lottie.asset(
              'assets/lottie/statistics.json',
              width: 200.w,
              height: 200.w,
            ),
          ),
        ),
        error: (e, _) => _ErrorView(onRetry: _retry),
        data: (stats) => _buildContent(stats),
      ),
    );
  }

  void _retry() {
    ref.read(statisticsProvider.notifier).fetchStatistics();
  }

  Widget _buildContent(StatisticsModel stats) {
    final weekData = stats.weeklyActivity
        .map((a) => a.count.toDouble())
        .toList(growable: false);
    final todayIndex = DateTime.now().weekday - 1;

    return RefreshIndicator(
      onRefresh: () => ref.read(statisticsProvider.notifier).fetchStatistics(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Row(
              spacing: 12.w,
              children: [
                StatisticsInfoCard(
                  assetPath: "assets/icons/fire.svg",
                  title: "Series of days",
                  value: stats.streak.toString().padLeft(2, '0'),
                ),
                StatisticsInfoCard(
                  assetPath: "assets/icons/filled_check.svg",
                  title: "Stories completed",
                  value: stats.storiesCompleted.toString().padLeft(2, '0'),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            WeeklyFocusChart(weekData: weekData, todayIndex: todayIndex),
            SizedBox(height: 20.h),
            BadgesSectionWidget(
              badges: _mapBadges(stats.badges.items),
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 48, color: Colors.white38),
          SizedBox(height: 12.h),
          Text(
            "Couldn't load statistics",
            style: TextStyle(fontSize: 16.sp, color: Colors.white70),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}
