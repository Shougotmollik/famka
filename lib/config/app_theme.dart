import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      surface: AppColors.bgColor,
      onPrimary: AppColors.onPrimary,
      primary: AppColors.primary,
      error: AppColors.error,
    );
    final c = colorScheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: c,
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: c.surface,
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(color: c.outlineVariant.withValues(alpha: 0.5)),
        ),
        clipBehavior: Clip.antiAlias,
        color: c.surfaceContainerHighest,
        surfaceTintColor: c.surfaceTint,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
        ),
      ),

      dividerTheme: DividerThemeData(
        color: c.outlineVariant,
        thickness: 0.5,
        space: 1,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.primary,
        linearTrackColor: c.primaryContainer.withValues(alpha: 0.5),
        circularTrackColor: c.primaryContainer.withValues(alpha: 0.5),
      ),
    );
  }
}
