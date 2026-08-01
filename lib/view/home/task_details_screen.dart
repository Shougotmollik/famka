import 'package:famka/config/routes/router_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../models/task_item_model.dart';
import 'widgets/quiz_difficulty_dialog.dart';

class TaskDetailsScreen extends StatelessWidget {
  final TaskItemModel? task;
  final QuizDifficulty? difficulty;

  const TaskDetailsScreen({super.key, this.task, this.difficulty});

  static const _gradientTop = Color(0xFF241B35);
  static const _gradientBottom = Color(0xFF12151C);

  static BoxDecoration get _screenBackgroundDecoration {
    const stepCount = 18;
    final colors = List<Color>.generate(stepCount, (index) {
      final t = index / (stepCount - 1);
      final blend = Curves.easeOutCubic.transform(t);
      return Color.lerp(_gradientTop, _gradientBottom, blend)!;
    });
    final stops = List<double>.generate(
      stepCount,
      (index) => index / (stepCount - 1),
    );

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: colors,
        stops: stops,
        tileMode: TileMode.clamp,
      ),
    );
  }

  static const _beforeYouStartItems = [
    'Use headphones for the best experience',
    'Find a quiet environment',
    'Forward skipping is disabled — this is intentional',
    'Listen carefully — the quiz follows immediately',
  ];

  String get _badgeLabel {
    final level = switch (difficulty) {
      QuizDifficulty.easy => 'LEVEL 1',
      QuizDifficulty.medium => 'LEVEL 2',
      QuizDifficulty.hard => 'LEVEL 3',
      null => 'LEVEL 1',
    };

    final storyMatch = RegExp(
      r'Story\s*(\d+)',
      caseSensitive: false,
    ).firstMatch(task?.subtitle ?? '');

    final story = storyMatch != null
        ? 'STORY ${storyMatch.group(1)}'
        : 'STORY 1';
    return '$level • $story';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Scaffold(
      backgroundColor: _gradientBottom,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(decoration: _screenBackgroundDecoration),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),
                        _BackButton(onTap: () => context.pop()),
                        SizedBox(height: 20.h),
                        _LevelBadge(label: _badgeLabel, color: c.primary),
                        SizedBox(height: 12.h),
                        Text(
                          task?.title ?? 'Task Details',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: c.onSurface,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        _InfoCard(
                          title: 'About this Session',
                          child: Text(
                            'Follow a three-way conversation between colleagues '
                            'discussing a project deadline. Each speaker has a '
                            'distinct speaking style. You will be tested on content '
                            'recall and speaker attribution.',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFFB3B8C5),
                              height: 1.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _InfoCard(
                          title: 'Before You Start',
                          child: Column(
                            children: [
                              for (
                                var i = 0;
                                i < _beforeYouStartItems.length;
                                i++
                              ) ...[
                                if (i > 0) SizedBox(height: 14.h),
                                _ChecklistItem(
                                  text: _beforeYouStartItems[i],
                                  accentColor: c.primary,
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        _StartListeningButton(
                          onPressed: () {
                            context.push(AppRoutes.session);
                          },
                          primaryColor: c.primary,
                          textColor: c.onPrimary,
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: const Color(0xFF1F242B),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF3A4150)),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.chevron_left_rounded,
          color: Colors.white,
          size: 24.sp,
        ),
      ),
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF8E35E1),
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF262B35),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: c.outlineVariant.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: c.onSurface,
            ),
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({required this.text, required this.accentColor});

  final String text;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: SvgPicture.asset(
            'assets/icons/tick.svg',
            width: 16.w,
            height: 16.w,
            colorFilter: ColorFilter.mode(accentColor, BlendMode.srcIn),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFB3B8C5),
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _StartListeningButton extends StatelessWidget {
  const _StartListeningButton({
    required this.onPressed,
    required this.primaryColor,
    required this.textColor,
  });

  final VoidCallback onPressed;
  final Color primaryColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textColor,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow_outlined, size: 24.sp, color: textColor),
            Text(
              'Start listening',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
