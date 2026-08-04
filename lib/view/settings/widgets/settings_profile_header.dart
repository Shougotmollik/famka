import 'package:famka/utils/text_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsProfileHeader extends StatelessWidget {
  const SettingsProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.imageUrl,
    this.onEditTap,
  });

  final String name;
  final String email;
  final String? imageUrl;
  final VoidCallback? onEditTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: const Color(0xFF3A4150),
              backgroundImage: imageUrl != null
                  ? NetworkImage(imageUrl!)
                  : null,
              child: imageUrl == null
                  ? Icon(
                      Icons.person_rounded,
                      size: 30.r,
                      color: const Color(0xFF8B8E95),
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onEditTap,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff_242A36),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/camera-01.svg",
                    height: 17.w,
                    width: 17.w,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 14.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name.toTitleCase(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              email,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF8B8E95),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
