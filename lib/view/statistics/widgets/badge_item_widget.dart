import 'package:famka/models/badge_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BadgeItemWidget extends StatelessWidget {
  const BadgeItemWidget({super.key, required this.badge, this.onTap});

  final BadgeModel badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Badge icon container
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: badge.isUnlocked ? 1.0 : 0.35,
                child: Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: badge.badgeColor.withValues(alpha: 0.18),
                    border: Border.all(
                      color: badge.badgeColor.withValues(alpha: 0.55),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      badge.iconAsset,
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                ),
              ),
              if (badge.isUnlocked)
                Positioned(
                  bottom: -2.h,
                  right: -2.w,
                  child: Container(
                    width: 16.w,
                    height: 16.w,
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: badge.badgeColor,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/tick.svg",
                      color: Colors.white,
                    ),
                  ),
                ),
              if (!badge.isUnlocked)
                Positioned(
                  bottom: -2.h,
                  right: -2.w,
                  child: Container(
                    width: 16.w,
                    height: 16.w,
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Color(0xff_1B1E28),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: badge.badgeColor.withValues(alpha: 0.55),
                        width: 1.5,
                      ),
                    ),
                    child: SvgPicture.asset(
                      "assets/icons/Lock.svg",
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: 72.w,
            child: Text(
              badge.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: badge.isUnlocked
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: badge.isUnlocked
                    ? Colors.white
                    : const Color(0xFF6B7280),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
