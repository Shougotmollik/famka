import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/task_item_model.dart';

class TaskItemCard extends StatelessWidget {
  final TaskItemModel task;
  final bool isFirst;
  final bool isLast;

  const TaskItemCard({
    super.key,
    required this.task,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    Color iconBgColor =
        task.isActive ? const Color(0xFF8E35E1) : Colors.transparent;
    Color iconBorderColor =
        task.isActive ? const Color(0xFF8E35E1) : const Color(0xFF3A4150);
    Color iconColor = task.isActive ? Colors.white : const Color(0xFF8B8E95);
    Color lineColor =
        task.isActive ? const Color(0xFF8E35E1) : const Color(0xFF3A4150);

    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        bottom: isLast ? 16.h : 0,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 40.w,
              child: Column(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: iconBorderColor, width: 1.w),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      task.iconType.assetPath,
                      width: 16.w,
                      height: 16.w,
                      colorFilter: ColorFilter.mode(
                        iconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(width: 1.w, color: lineColor),
                    ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C323E),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFDCDFE6),
                              ),
                            ),
                          ),
                          if (task.isNew)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: const Color(0xFFE4A951),
                                ),
                              ),
                              child: Text(
                                'New',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFE4A951),
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        task.subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF8B8E95),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: ProgressBar(
                              progress: task.progress,
                              total: task.totalProgress,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            '${task.progress}/${task.totalProgress}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF8B8E95),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressBar extends StatelessWidget {
  final int progress;
  final int total;

  const ProgressBar({super.key, required this.progress, required this.total});

  @override
  Widget build(BuildContext context) {
    double ratio = total > 0 ? progress / total : 0.0;
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1F242B),
        borderRadius: BorderRadius.circular(100.r),
      ),
      alignment: Alignment.centerLeft,
      child: ratio > 0
          ? FractionallySizedBox(
              widthFactor: ratio,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF8E35E1),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
