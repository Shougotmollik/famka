import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StreakDayItem extends StatelessWidget {
  final String day;
  final String date;
  final bool isCompleted;
  final bool isToday;

  const StreakDayItem({
    super.key,
    required this.day,
    required this.date,
    required this.isCompleted,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = isCompleted ? const Color(0xFF8E35E1) : Colors.transparent;
    Color borderColor = isToday
        ? const Color(0xFF8E35E1)
        : (isCompleted ? const Color(0xFF8E35E1) : const Color(0xFF3A4150));
    Color topTextColor = isCompleted ? Colors.white : const Color(0xFFB3B8C5);
    Color circleColor = isToday ? const Color(0xFF8E35E1) : Colors.white;
    Color bottomTextColor = isToday
        ? Colors.white
        : (isCompleted ? const Color(0xFF8E35E1) : const Color(0xFF1F242B));

    return Container(
      width: 44.w,
      height: 76.h,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: borderColor, width: 1.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: topTextColor,
            ),
          ),
          SizedBox(height: 6.h),
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              date,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                color: bottomTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
