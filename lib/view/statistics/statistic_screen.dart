import 'package:famka/view/statistics/widgets/statistics_info_card.dart';
import 'package:famka/view/statistics/widgets/weekly_focus_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Statistics",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Row(
              spacing: 12.w,
              children: [
                StatisticsInfoCard(
                  assetPath: "assets/icons/fire.svg",
                  title: "Series of days",
                  value: "05",
                ),
                StatisticsInfoCard(
                  assetPath: "assets/icons/filled_check.svg",
                  title: "Stories completed",
                  value: "12",
                ),
              ],
            ),
            SizedBox(height: 20.h),
            WeeklyFocusChart(
              weekData: const [2, 0, 5, 3, 7, 0, 4],
              todayIndex: 6,
            ),
          ],
        ),
      ),
    );
  }
}
