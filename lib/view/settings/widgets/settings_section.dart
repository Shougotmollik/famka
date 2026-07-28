import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.label,
    required this.children,
  });

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF8B8E95),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF_1F222D),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFF3A4150)),
          ),
          child: Column(children: _buildChildren()),
        ),
      ],
    );
  }

  List<Widget> _buildChildren() {
    final result = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(
          const Divider(height: 1, thickness: 1, color: Color(0xFF3A4150)),
        );
      }
    }
    return result;
  }
}
