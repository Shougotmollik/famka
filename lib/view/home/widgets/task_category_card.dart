import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/task_category_model.dart';
import '../../../models/task_item_model.dart';
import 'task_item_card.dart';

class TaskCategoryCard extends StatelessWidget {
  final TaskCategoryModel category;
  final bool isExpanded;
  final VoidCallback onTap;

  const TaskCategoryCard({
    super.key,
    required this.category,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isCompleted = category.completedTasks == category.totalTasks &&
        category.totalTasks > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: const Color(0xFF232832),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isExpanded
              ? const Color(0xFF8E35E1)
              : const Color(0xFF3A4150),
          width: 1.w,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  StatusIcon(
                    iconType: category.iconType,
                    text: category.textIcon,
                    isCompleted: isCompleted,
                    isPurple: category.isPurple,
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          category.subtitle,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFB3B8C5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${category.completedTasks}/${category.totalTasks}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFB3B8C5),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFFB3B8C5),
                      size: 24.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity, height: 0),
            secondChild: Column(
              children: List.generate(category.tasks.length, (index) {
                final task = category.tasks[index];
                return TaskItemCard(
                  task: task,
                  isFirst: index == 0,
                  isLast: index == category.tasks.length - 1,
                );
              }),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}

class StatusIcon extends StatelessWidget {
  final TaskIconType? iconType;
  final String? text;
  final bool isCompleted;
  final bool isPurple;

  const StatusIcon({
    super.key,
    this.iconType,
    this.text,
    this.isCompleted = false,
    this.isPurple = false,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = isCompleted
        ? const Color(0xFF22B07D)
        : (isPurple ? const Color(0xFF8E35E1) : const Color(0xFF3A4150));
    Color iconColor = isCompleted
        ? const Color(0xFF22B07D)
        : (isPurple ? const Color(0xFF8E35E1) : const Color(0xFF8B8E95));
    Color bgColor = isCompleted
        ? const Color(0xFF1E2B2C)
        : (isPurple ? const Color(0xFF302046) : Colors.transparent);

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.w),
      ),
      alignment: Alignment.center,
      child: text != null
          ? Text(
              text!,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: iconColor,
              ),
            )
          : SvgPicture.asset(
              iconType?.assetPath ?? 'assets/icons/tick.svg',
              width: 20.w,
              height: 20.w,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
    );
  }
}
