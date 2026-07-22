import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.color,
    required this.textColor,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final String title;
  final Color color;
  final Color textColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading ? color.withValues(alpha: 0.6) : color,
          foregroundColor: textColor,
          disabledBackgroundColor: color.withValues(alpha: 0.6),
          disabledForegroundColor: textColor.withValues(alpha: 0.7),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 20.sp,
                width: 20.sp,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              )
            : Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      ),
    );
  }
}
