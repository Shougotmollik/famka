import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/app_colors.dart';

enum QuizOptionState { idle, correct, incorrect }

class QuizOptionTile extends StatelessWidget {
  const QuizOptionTile({
    super.key,
    required this.label,
    required this.text,
    required this.state,
    required this.onTap,
  });

  final String label;
  final String text;
  final QuizOptionState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color borderColor;
    final Color bgColor;
    final Color labelBg;
    final Color labelFg;

    switch (state) {
      case QuizOptionState.correct:
        borderColor = AppColors.success;
        bgColor = AppColors.success.withValues(alpha: 0.12);
        labelBg = AppColors.success;
        labelFg = Colors.white;
      case QuizOptionState.incorrect:
        borderColor = AppColors.error;
        bgColor = AppColors.error.withValues(alpha: 0.12);
        labelBg = AppColors.error;
        labelFg = Colors.white;
      case QuizOptionState.idle:
        borderColor = const Color(0xFF3A3F4B);
        bgColor = const Color(0xFF252A34);
        labelBg = Colors.transparent;
        labelFg = Colors.white70;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: labelBg,
                border: state == QuizOptionState.idle
                    ? Border.all(color: Colors.white38, width: 1)
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: labelFg,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
