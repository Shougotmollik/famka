import 'package:animations/animations.dart';
import 'package:famka/config/routes/router_path.dart';
import 'package:famka/config/theme/app_colors.dart';
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
  late final List<Animation<double>> _cardAnimations;

  late final List<TaskCategoryModel> _categories = [
    TaskCategoryModel(
      title: 'Easy',
      subtitle: 'Level 1 · Stories 3',
      totalTasks: 3,
      completedTasks: 3,
      tasks: [
        TaskItemModel(
          title: 'Basic Greetings',
          subtitle: '02:15 · Story 1',
          progress: 3,
          totalProgress: 3,
        ),
        TaskItemModel(
          title: 'Colors & Numbers',
          subtitle: '03:00 · Story 2',
          progress: 3,
          totalProgress: 3,
        ),
        TaskItemModel(
          title: 'Simple Conversations',
          subtitle: '04:30 · Story 3',
          progress: 3,
          totalProgress: 3,
        ),
      ],
    ),
    TaskCategoryModel(
      title: 'Medium',
      subtitle: 'Level 2 · Stories 3',
      totalTasks: 3,
      completedTasks: 1,
      isPurple: true,
      textIcon: '2',
      tasks: [
        TaskItemModel(
          title: 'Radio Interview: Climate',
          subtitle: '07:20 · Story 1',
          progress: 2,
          totalProgress: 3,
          isActive: true,
        ),
        TaskItemModel(
          title: 'Morning Habits Podcast',
          subtitle: '07:20 · Story 2',
          progress: 0,
          totalProgress: 3,
        ),
        TaskItemModel(
          title: 'Morning Habits Podcast',
          subtitle: '07:20 · Story 3',
          progress: 0,
          totalProgress: 3,
          isNew: true,
        ),
      ],
    ),
    TaskCategoryModel(
      title: 'Advanced',
      subtitle: 'Level 3 · Stories 3',
      totalTasks: 3,
      completedTasks: 0,
      tasks: [],
    ),
    TaskCategoryModel(
      title: 'Hard',
      subtitle: 'Level 3 · Stories 3',
      totalTasks: 3,
      completedTasks: 0,
      tasks: [],
    ),
  ];
  final Map<String, bool> _expandedStates = {'Medium': true};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(notificationsProvider.notifier).fetchNotifications();
      }
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
    _cardAnimations = List.generate(
      _categories.length,
      (i) => CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.3 + i * 0.12, 0.55 + i * 0.12, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
              FadeScaleTransition(
                animation: _streakAnimation,
                child: _buildStreakSection(),
              ),
              SizedBox(height: 24.h),
              _buildTasksList(),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakSection() {
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
              "5 of 7 days",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color(0XFF_B3B8C5),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreakDayItem(
              day: 'MON',
              date: '01',
              isCompleted: true,
              isToday: false,
            ),
            StreakDayItem(
              day: 'TUE',
              date: '02',
              isCompleted: false,
              isToday: false,
            ),
            StreakDayItem(
              day: 'WED',
              date: '03',
              isCompleted: true,
              isToday: false,
            ),
            StreakDayItem(
              day: 'THR',
              date: '04',
              isCompleted: false,
              isToday: true,
            ),
            StreakDayItem(
              day: 'FRI',
              date: '05',
              isCompleted: true,
              isToday: false,
            ),
            StreakDayItem(
              day: 'SAT',
              date: '06',
              isCompleted: true,
              isToday: false,
            ),
            StreakDayItem(
              day: 'SUN',
              date: '07',
              isCompleted: true,
              isToday: false,
            ),
          ],
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
                color: Color(0XFF_B3B8C5),
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
                  color: Color(0XFF_1F242B),
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(color: Color(0XFF_3A4150)),
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

  Widget _buildTasksList() {
    return Column(
      children: List.generate(_categories.length, (index) {
        final category = _categories[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: FadeScaleTransition(
            animation: _cardAnimations[index],
            child: TaskCategoryCard(
              category: category,
              isExpanded: _expandedStates[category.title] ?? false,
              onTap: () {
                setState(() {
                  _expandedStates[category.title] =
                      !(_expandedStates[category.title] ?? false);
                });
              },
            ),
          ),
        );
      }),
    );
  }
}
