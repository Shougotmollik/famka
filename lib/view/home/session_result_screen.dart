import 'package:famka/config/theme/app_colors.dart';
import 'package:famka/config/routes/router_path.dart';
import 'package:famka/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SessionResultData {
  final int percentage;
  final int lessonsCompleted;
  final int daysInWeek;
  final String feedbackMessage;
  final List<_ReviewItem> reviewItems;

  const SessionResultData({
    required this.percentage,
    required this.lessonsCompleted,
    required this.daysInWeek,
    required this.feedbackMessage,
    required this.reviewItems,
  });
}

class _ReviewItem {
  final String question;
  final bool isCorrect;

  const _ReviewItem({required this.question, required this.isCorrect});
}

// Sample data used when no extras are passed (e.g. from QuizScreen flow)
const _sampleResult = SessionResultData(
  percentage: 80,
  lessonsCompleted: 32,
  daysInWeek: 5,
  feedbackMessage:
      'Good concentration—you maintained your attention as the speakers changed. One question about a detail slipped through.',
  reviewItems: [
    _ReviewItem(
      question: 'Who mentioned that the meeting was postponed to Friday?',
      isCorrect: true,
    ),
    _ReviewItem(
      question: 'What was the main topic discussed at the very beginning?',
      isCorrect: false,
    ),
    _ReviewItem(
      question: 'Which speaker disagreed with the proposed timeline?',
      isCorrect: true,
    ),
    _ReviewItem(
      question: 'How many action items were agreed upon in the conversation?',
      isCorrect: true,
    ),
  ],
);

class SessionResultScreen extends StatelessWidget {
  const SessionResultScreen({super.key, this.result});

  final SessionResultData? result;

  String _performanceLabel(int pct) {
    if (pct >= 90) return 'Excellent Performance!';
    if (pct >= 70) return 'Great Performance!';
    if (pct >= 50) return 'Good Effort!';
    return 'Keep Practicing!';
  }

  @override
  Widget build(BuildContext context) {
    final data = result ?? _sampleResult;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _ResultAppBar(onBack: () => context.pop()),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 8.h),
                    // Percentage
                    Text(
                      '${data.percentage}%',
                      style: TextStyle(
                        fontSize: 56.sp,
                        fontWeight: FontWeight.w800,
                        color: cs.primary,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      _performanceLabel(data.percentage),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Stats row
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            value: '${data.lessonsCompleted}',
                            label: 'Lesson completed',
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _StatCard(
                            value: '${data.daysInWeek}',
                            label: 'Days in week',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    // Question Review card
                    _QuestionReviewCard(items: data.reviewItems),
                    SizedBox(height: 16.h),
                    // Feedback card
                    _FeedbackCard(message: data.feedbackMessage),
                    SizedBox(height: 24.h),
                    // Bottom buttons
                    _ResultBottomBar(
                      onContinue: () => context.go(AppRoutes.home),
                      onStatistics: () => context.go(AppRoutes.statistics),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultAppBar extends StatelessWidget {
  const _ResultAppBar({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF2A2F3B),
                ),
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
            ),
          ),
          Text(
            'Session result',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2F3B),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(fontSize: 13.sp, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

class _QuestionReviewCard extends StatelessWidget {
  const _QuestionReviewCard({required this.items});
  final List<_ReviewItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2F3B),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question Review',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12.h),
          ...items.map((item) => _ReviewRow(item: item)),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.item});
  final _ReviewItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.isCorrect ? Icons.check : Icons.close,
            color: item.isCorrect ? AppColors.success : AppColors.error,
            size: 18.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              item.question,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2F3B),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        message,
        style: TextStyle(fontSize: 13.sp, color: Colors.white60, height: 1.6),
      ),
    );
  }
}

class _ResultBottomBar extends StatelessWidget {
  const _ResultBottomBar({
    required this.onContinue,
    required this.onStatistics,
  });

  final VoidCallback onContinue;
  final VoidCallback onStatistics;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bgColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            title: 'Continue Learning',
            color: AppColors.primary,
            textColor: Colors.white,
            onPressed: onContinue,
          ),
          SizedBox(height: 10.h),
          CustomElevatedButton(
            title: 'View Statistics',
            color: const Color(0xFF2A2F3B),
            textColor: Colors.white,
            onPressed: onStatistics,
          ),
        ],
      ),
    );
  }
}
