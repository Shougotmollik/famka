import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_colors.dart';

class QuizProgressDots extends StatelessWidget {
  const QuizProgressDots({
    super.key,
    required this.total,
    required this.current,
  });

  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (i) {
        final bool isActive = i <= current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(right: 6.w),
          width: isActive ? 14.w : 10.w,
          height: 10.h,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : const Color(0xFF3A3F4B),
            borderRadius: BorderRadius.circular(6.r),
          ),
        );
      }),
    );
  }
}
