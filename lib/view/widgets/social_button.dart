import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  final String title;
  final String icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: SvgPicture.asset(icon, height: 20.h),
      label: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        side: BorderSide(color: c.outlineVariant),
      ),
    );
  }
}
