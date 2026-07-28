import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PolicySection extends StatelessWidget {
  const PolicySection({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 6.h),
        ...children,
        SizedBox(height: 20.h),
      ],
    );
  }
}

class PolicySubSection extends StatelessWidget {
  const PolicySubSection({
    super.key,
    required this.title,
    this.intro,
    this.bullets = const [],
    this.footer,
  });

  final String title;
  final String? intro;
  final List<String> bullets;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        if (intro != null) ...[SizedBox(height: 4.h), PolicyBody(intro!)],
        if (bullets.isNotEmpty) ...[
          SizedBox(height: 4.h),
          ...bullets.map((b) => PolicyBullet(b)),
        ],
        if (footer != null) ...[SizedBox(height: 6.h), PolicyBody(footer!)],
        SizedBox(height: 10.h),
      ],
    );
  }
}

class PolicyBody extends StatelessWidget {
  const PolicyBody(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        color: const Color(0xFFB3B8C5),
        height: 1.6,
      ),
    );
  }
}

class PolicyBullet extends StatelessWidget {
  const PolicyBullet(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '  •  ',
            style: TextStyle(fontSize: 13.sp, color: const Color(0xFFB3B8C5)),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFB3B8C5),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
