import 'package:animations/animations.dart';
import 'package:famka/config/routes/router_path.dart';
import 'package:famka/config/theme/app_colors.dart';
import 'package:famka/models/home.dart';
import 'package:famka/provider/home_provider.dart';
import 'package:famka/provider/notification_provider.dart';
import 'package:famka/provider/user_provider.dart';
import 'package:famka/utils/text_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../models/task_category_model.dart';
import '../../models/task_item_model.dart';
import 'widgets/task_category_card.dart';
import 'widgets/streak_day_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _appBarAnimation;
  late final Animation<double> _streakAnimation;
  final Map<int, Animation<double>> _cardAnimationCache = {};

  final Map<String, bool> _expandedStates = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(notificationsProvider.notifier).fetchNotifications();
      ref.read(homeProvider.notifier).fetchHomeData();
    });
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _appBarAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
    );
    _streakAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.15, 0.45, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Animation<double> _cardAnimationFor(int index) {
    return _cardAnimationCache.putIfAbsent(
      index,
      () => CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.3 + index * 0.12,
          0.55 + index * 0.12,
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeAsync = ref.watch(homeProvider);
    final data = homeAsync.value;
    final hasData =
        (data?.weekProgress.days.isNotEmpty ?? false) ||
        (data?.levels.isNotEmpty ?? false);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeProvider.notifier).fetchHomeData(),
        color: AppColors.primary,
        backgroundColor: const Color(0xFF1A1E25),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 54.h),
                FadeScaleTransition(
                  animation: _appBarAnimation,
                  child: _buildAppBar(ref),
                ),
                SizedBox(height: 24.h),
                if (!hasData)
                  homeAsync.hasError
                      ? _buildErrorState()
                      : _buildLoadingState()
                else ...[
                  if (data!.weekProgress.days.isNotEmpty) ...[
                    FadeScaleTransition(
                      animation: _streakAnimation,
                      child: _buildStreakSection(data.weekProgress),
                    ),
                    SizedBox(height: 24.h),
                  ],
                  _buildTasksList(data.levels),
                ],
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60.h),
      child: Column(
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: const CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading your lessons...',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFB3B8C5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Column(
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 48.w,
            color: const Color(0xFF8B8E95),
          ),
          SizedBox(height: 12.h),
          Text(
            'Could not load home data',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Pull to refresh or tap Retry to try again.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFB3B8C5),
            ),
          ),
          SizedBox(height: 16.h),
          FilledButton.icon(
            onPressed: () => ref.read(homeProvider.notifier).fetchHomeData(),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            ),
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakSection(WeekProgressModel progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "This Week",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              '${progress.completedDays} of ${progress.totalDays} days',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0XFF_B3B8C5),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: progress.days.map((d) {
            return StreakDayItem(
              day: d.day,
              date: d.date.toString().padLeft(2, '0'),
              isCompleted: d.isCompleted,
              isToday: d.isToday,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAppBar(WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final notifications = ref.watch(notificationsProvider).value;
    final unreadCount = notifications?.meta.unreadCount ?? 0;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100.r),
          child: Image.network(
            userState.value?.avatar ?? "",
            width: 42.w,
            height: 42.w,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.white,
                child: Icon(Icons.person, size: 42.sp, color: Colors.black),
              );
            },
          ),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning, ${userState.value?.fullName.firstName ?? ""} 👋',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0XFF_B3B8C5),
              ),
            ),
            Text(
              "Let's Train Today",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
        ),

        Spacer(),
        GestureDetector(
          onTap: () => context.push(AppRoutes.notification),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: const Color(0XFF_1F242B),
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(color: const Color(0XFF_3A4150)),
                ),
                child: SvgPicture.asset("assets/icons/Bell.svg"),
              ),
              if (unreadCount > 0) _buildUnreadBadge(unreadCount),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUnreadBadge(int count) {
    return Positioned(
      top: -4.r,
      right: -4.r,
      // Bouncy scale + fade entrance whenever the badge first appears.
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Transform.scale(scale: value, child: child),
          );
        },
        child: Container(
          constraints: BoxConstraints(minWidth: 18.r, minHeight: 18.r),
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(color: const Color(0xFF1A1E25), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.45),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            count > 99 ? '99+' : '$count',
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTasksList(List<LevelModel> levels) {
    return Column(
      children: List.generate(levels.length, (index) {
        final category = _toCategory(levels[index]);
        final expanded = _expandedStates[category.title] ?? index == 0;
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: FadeScaleTransition(
            animation: _cardAnimationFor(index),
            child: TaskCategoryCard(
              category: category,
              isExpanded: expanded,
              onTap: () {
                setState(() {
                  _expandedStates[category.title] = !expanded;
                });
              },
            ),
          ),
        );
      }),
    );
  }

  TaskCategoryModel _toCategory(LevelModel level) {
    var newBadgeAssigned = false;
    return TaskCategoryModel(
      title: level.levelName,
      subtitle: 'Stories ${level.totalStories}',
      totalTasks: level.totalStories,
      completedTasks: level.completedStories,
      isPurple: level.levelName.toLowerCase().contains('new'),
      tasks: level.stories.map((story) {
        final attempted = story.difficulties.values
            .where((d) => d.attempted)
            .length;
        // Show the "New" badge only on the first un-attempted story per
        // level, so a fresh user doesn't see it on every story.
        final isNew = !newBadgeAssigned && !story.completed && attempted == 0;
        if (isNew) newBadgeAssigned = true;
        return _toTask(story, isNew: isNew);
      }).toList(),
    );
  }

  TaskItemModel _toTask(StoryModel story, {bool isNew = false}) {
    final total = story.difficulties.length;
    final attempted = story.difficulties.values
        .where((d) => d.attempted)
        .length;
    return TaskItemModel(
      title: story.storyName,
      subtitle: story.about,
      progress: story.completed ? total : attempted,
      totalProgress: total,
      isActive: attempted > 0 && !story.completed,
      isNew: isNew,
      storyId: story.storyId,
      attemptedDifficulties: story.difficulties.map(
        (key, value) => MapEntry(key, value.attempted),
      ),
    );
  }
}
