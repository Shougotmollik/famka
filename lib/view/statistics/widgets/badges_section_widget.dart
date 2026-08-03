import 'package:famka/models/badge_model.dart';
import 'package:famka/view/statistics/widgets/badge_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BadgesSectionWidget extends StatelessWidget {
  const BadgesSectionWidget({super.key, required this.badges, this.onBadgeTap});

  final List<BadgeModel> badges;
  final void Function(BadgeModel badge)? onBadgeTap;

  int get _unlockedCount => badges.where((b) => b.isUnlocked).length;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF242A33),
        border: Border.all(color: const Color(0xFF343949)),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Badges",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Track your progress here",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF_5B5FEF).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "$_unlockedCount/${badges.length} unlocked",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF_A445FF),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Horizontally scrollable badges row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              spacing: 16.w,
              children: badges
                  .map(
                    (badge) => BadgeItemWidget(
                      badge: badge,
                      onTap: () => onBadgeTap?.call(badge),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
