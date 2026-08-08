import 'package:famka/config/routes/router_path.dart';
import 'package:famka/config/theme/app_colors.dart';
import 'package:famka/models/quiz.dart';
import 'package:famka/provider/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'widgets/quiz_difficulty_dialog.dart';

class TaskDetailsScreen extends ConsumerStatefulWidget {
  const TaskDetailsScreen({
    super.key,
    this.title,
    this.storyId,
    this.difficulty,
    this.about,
  });

  final String? title;
  final String? storyId;
  final QuizDifficulty? difficulty;
  final String? about;

  @override
  ConsumerState<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends ConsumerState<TaskDetailsScreen> {
  static const _gradientTop = Color(0xFF241B35);
  static const _gradientBottom = Color(0xFF12151C);

  static const _beforeYouStartItems = [
    'Use headphones for the best experience',
    'Find a quiet environment',
    'Forward skipping is disabled — this is intentional',
    'Listen carefully — the quiz follows immediately',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fetchQuiz();
    });
  }

  void _fetchQuiz() {
    final storyId = widget.storyId;
    final difficulty = widget.difficulty;
    if (storyId == null || difficulty == null) return;
    ref
        .read(quizProvider.notifier)
        .fetchQuiz(storyId: storyId, difficulty: difficulty.name.toUpperCase());
  }

  String get _badgeLabel {
    final level = switch (widget.difficulty) {
      QuizDifficulty.easy => 'LEVEL 1',
      QuizDifficulty.medium => 'LEVEL 2',
      QuizDifficulty.hard => 'LEVEL 3',
      null => 'LEVEL 1',
    };

    final id = widget.storyId ?? '';
    final story = id.isNotEmpty
        ? 'STORY ${id.substring(0, id.length > 8 ? 8 : id.length).toUpperCase()}'
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
                          widget.title ?? 'Task Details',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w800,
                            color: c.onSurface,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        _buildContent(c),
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

  Widget _buildContent(ColorScheme c) {
    final quizAsync = ref.watch(quizProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoCard(
          title: 'About this Story',
          child: Text(
            widget.about ?? 'Story description coming soon.',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFB3B8C5),
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        _buildSessionSummary(quizAsync),
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
            context.push(
              AppRoutes.session,
              extra: {
                'storyId': widget.storyId,
                'difficulty': widget.difficulty?.name.toUpperCase(),
                'title': widget.title,
              },
            );
          },
          primaryColor: c.primary,
          textColor: c.onPrimary,
        ),
      ],
    );
  }

  Widget _buildSessionSummary(AsyncValue<QuizResponseModel> quizAsync) {
    // Without a story/difficulty there's nothing to fetch — show a hint
    // instead of an endless spinner.
    final hasParams = widget.storyId != null && widget.difficulty != null;

    return _InfoCard(
      title: 'Session Summary',
      child: !hasParams
          ? Text(
              'Select a story to see session details.',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFB3B8C5),
                height: 1.5,
              ),
            )
          : quizAsync.when(
        skipLoadingOnRefresh: true,
        loading: () => Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Center(
            child: SizedBox(
              width: 28.w,
              height: 28.w,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2.5,
              ),
            ),
          ),
        ),
        error: (error, stackTrace) => Column(
          children: [
            Text(
              'Could not load the session details.',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFB3B8C5),
                height: 1.5,
              ),
            ),
            SizedBox(height: 14.h),
            _RetryButton(onTap: _fetchQuiz),
          ],
        ),
        data: (response) {
          final questions = response.questions;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SummaryRow(
                icon: Icons.quiz_outlined,
                label: 'Questions',
                value: '${questions.length}',
              ),
              if (questions.isNotEmpty &&
                  questions.first.difficulty.isNotEmpty) ...[
                SizedBox(height: 12.h),
                _SummaryRow(
                  icon: Icons.speed_rounded,
                  label: 'Difficulty',
                  value: questions.first.difficulty,
                ),
              ],
              if (questions.isNotEmpty && questions.first.audio.isNotEmpty) ...[
                SizedBox(height: 12.h),
                _SummaryRow(
                  icon: Icons.headphones_rounded,
                  label: 'Audio',
                  value: 'Included',
                ),
              ],
            ],
          );
        },
      ),
    );
  }

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
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.w, color: AppColors.primary),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFFB3B8C5),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _RetryButton extends StatelessWidget {
  const _RetryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
          ),
        ),
        child: Text(
          'Retry',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
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
