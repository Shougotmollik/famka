import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class StatisticsInfoCard extends StatelessWidget {
  const StatisticsInfoCard({
    super.key,
    required this.assetPath,
    required this.title,
    required this.value,
  });

  final String assetPath;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0XFF_242a33),
          border: Border.all(color: Color(0xff_343949)),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(assetPath),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20.sp,
                    color: Colors.white,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: Color(0xff_B3B8C5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
