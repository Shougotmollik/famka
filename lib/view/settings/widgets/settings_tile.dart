import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.svgAsset,
    required this.iconColor,
    required this.title,
    this.trailing,
    this.trailingText,
    this.showChevron = false,
    this.titleColor,
    this.onTap,
  });

  final String svgAsset;
  final Color iconColor;
  final String title;
  final Widget? trailing;
  final String? trailingText;
  final bool showChevron;
  final Color? titleColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            _IconBadge(svgAsset: svgAsset, color: iconColor),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: titleColor ?? Colors.white,
                ),
              ),
            ),
            if (trailing != null) trailing!,
            if (trailingText != null)
              Text(
                trailingText!,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF8B8E95),
                ),
              ),
            if (showChevron) ...[
              SizedBox(width: 4.w),
              Icon(
                Icons.chevron_right_rounded,
                color: const Color(0xFF8B8E95),
                size: 20.r,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.svgAsset, required this.color});

  final String svgAsset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.r,
      height: 36.r,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
          width: 18.r,
          height: 18.r,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
      ),
    );
  }
}
